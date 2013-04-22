ANDROID_SDK="/Users/nicotroia/Development/android-sdk"
AIR_SDK="/Users/nicotroia/Development/air-sdk"
IPHONE_SDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk"
PROJECT_PATH="/Users/nicotroia/PROJECTS/what_color_is_this"
SRC_PATH="$PROJECT_PATH/src"
ASSETS_PATH="$SRC_PATH/assets"
FILENAME="what_color_is_this"
APP_ID="com.nicotroia.whatcoloristhis"

if [ $# -lt 2 ]
then
	echo ;
	echo "Error. Target arguments are missing. build.sh -platform -target #device-id"
	echo ;
	echo "Example: build.sh -ios -debug 3"
	echo ;
	exit 1
fi

echo $1 $2 $3
echo ;

echo "FILENAME = $FILENAME"
echo "PROJECT_PATH = $PROJECT_PATH"
echo "SRC_PATH = $SRC_PATH"
echo "ASSETS_PATH = $ASSETS_PATH"
echo ;
echo "...Building swf..."
echo ;

# Creates dir if doesn't exist
mkdir -p $PROJECT_PATH/bin-debug

cd $SRC_PATH

if [ $2 == "-debug" ] 
then
	DEBUG="true"
else 
	DEBUG="false"
fi

#For some reason I get "Initial window content is invalid" when I remove "-debug"...
#-compress=false required for ios simulator
"$AIR_SDK/bin/amxmlc" -compress=false -debug=$DEBUG -library-path+=$PROJECT_PATH/libs $FILENAME.as -output $PROJECT_PATH/bin-debug/$FILENAME.swf

# Read the exit static of mxmlc to determine if there was an error
STATUS=$?
if [ $STATUS -eq 0 ] 
then
	echo "SWF success"
	echo ;
	
	cd $PROJECT_PATH/bin-debug
	
	if [ $1 == "-android" ] 
	then
		echo "...Building android APK..."
		echo ;
		
		mkdir -p $PROJECT_PATH/bin-android
		
		LISTEN=""
		
		if [ $2 == "-release" ]
		then
			# apk or apk-captive-runtime for release builds
			# Starting AIR 3.7, packaging AIR applications for Android in any target will embed the AIR runtime in the application itself.
			ANDROID_TARGET="apk-captive-runtime" 
		elif [ $2 == "-debug" ]
		then
			ANDROID_TARGET="apk-debug"
			LISTEN="-listen 7936"
		elif [ $2 == "-emulator" ]
		then
			#apk-emulator 
			ANDROID_TARGET="apk-captive-runtime"
		else 
			ANDROID_TARGET="apk-debug"
			LISTEN="-listen 7936"
		fi
		
		# -connect wifi debug
		# -listen usb debug
		"$AIR_SDK/bin/adt" -package -target $ANDROID_TARGET $LISTEN -storetype pkcs12 -keystore $PROJECT_PATH/build/android/cert.p12 -storepass 12345 $PROJECT_PATH/bin-android/$FILENAME.apk $PROJECT_PATH/src/$FILENAME-app.xml $FILENAME.swf assets/
	
	elif [ $1 == "-ios" ]
	then
		echo "...Building iOS IPA..."
		echo ;
		
		mkdir -p $PROJECT_PATH/bin-ios
		
		LISTEN=""
		EXTRA=""
		KEYSTORE=""
		PROVISIONING_PROFILE=""
		
		if [ $2 == "-debug" ] 
		then
			echo "In another window, call \"idb -forward 7936 7936 #\""
			echo ;
		
			IOS_TARGET="ipa-debug"
			LISTEN="-listen 7936"
			KEYSTORE="$PROJECT_PATH/build/ios/cert.p12"
			PROVISIONING_PROFILE="$PROJECT_PATH/build/ios/what_color_is_this_development.mobileprovision"
		elif [ $2 == "-simulator" ]
		then
			IOS_TARGET="ipa-debug-interpreter-simulator"
			EXTRA="-platformsdk $IPHONE_SDK"
			KEYSTORE="$PROJECT_PATH/build/ios/cert.p12"
			PROVISIONING_PROFILE="$PROJECT_PATH/build/ios/what_color_is_this_development.mobileprovision"
		elif [ $2 == "-adhoc" ]
		then
			IOS_TARGET="ipa-ad-hoc"
			KEYSTORE="$PROJECT_PATH/build/ios/distribution.p12"
			PROVISIONING_PROFILE="$PROJECT_PATH/build/ios/what_color_is_this_distribution.mobileprovision"
		elif [ $2 == "-appstore" ]
		then
			IOS_TARGET="ipa-app-store"
			KEYSTORE="$PROJECT_PATH/build/ios/distribution.p12"
			PROVISIONING_PROFILE="$PROJECT_PATH/build/ios/what_color_is_this_distribution.mobileprovision"
		else
			IOS_TARGET="ipa-debug"
			KEYSTORE="$PROJECT_PATH/build/ios/cert.p12"
			PROVISIONING_PROFILE="$PROJECT_PATH/build/ios/what_color_is_this_development.mobileprovision"
		fi
		
		"$AIR_SDK/bin/adt" -package -target $IOS_TARGET $LISTEN -storetype pkcs12 -keystore $KEYSTORE -provisioning-profile $PROVISIONING_PROFILE $PROJECT_PATH/bin-ios/$FILENAME.ipa $PROJECT_PATH/src/$FILENAME-app.xml Default-568h@2x.png $FILENAME.swf assets/ $EXTRA
	else
		echo "Error. Invalid target."
		exit 1
	fi
	
	# Read status again
	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		echo "Package success"
		echo ;
		echo "...Installing package..."
		echo ;
		
		if [ $3 == "-none" ]
		then
			echo "Not installing to a device."
			exit 1
		fi 
	
		if [ $1 == "-android" ] 
		then
			# Install android package
			
			cd $PROJECT_PATH/bin-android
			
			TARGET=""
			
			if [ -z "$3" ]
			then
				TARGET="-d"
			else
				TARGET=$3
			fi
			
			# -e emulator -d device -s serial
			# -r reinstall 
			# -t allow test apks
			adb $TARGET install -r $FILENAME.apk
			
			# Read status again
			STATUS=$?
			if [ $STATUS -eq 0 ]
			then
				echo ;
				echo "Install success"
				echo ;
				echo "Please run the app on the device then type 'run' in fdb"
				echo ;
				
				adb forward tcp:7936 tcp:7936
				
				fdb -p 7936
				
				# End.
			else
				echo "Install failed"
				echo ;
			fi
			
		elif [ $1 == "-ios" ]
		then
			# Install ios package
			
			cd $PROJECT_PATH/bin-ios
			
			if [ $2 == "-simulator" ] 
			then
				"$AIR_SDK/bin/adt" -installApp -platform ios -platformsdk $IPHONE_SDK -device ios-simulator -package $FILENAME.ipa
			
			else 
				# -z string length > 0
				if [ -z "$3" ]
				then
					echo "Error: device-id argument missing. Example: build.sh -ios -debug 3"
					exit 1
				fi
				
				"$AIR_SDK/lib/aot/bin/iOSBin/idb" -install $FILENAME.ipa $3
				
			fi
			
			
			# Read status again
			STATUS=$?
			if [ $STATUS -eq 0 ]
			then
				echo ;
				echo "Install success"
				echo ;
				
				if [ $2 == "-simulator" ] 
				then
					"$AIR_SDK/bin/adt" -launchApp -platform ios -platformsdk $IPHONE_SDK -device ios-simulator -appid $APP_ID
				
				else 
					echo "Run the app on the device then type 'run' in fdb"
					echo ;
					
					# This command hangs the terminal for some reason...
					# "$AIR_SDK/lib/aot/bin/iOSBin/idb" -forward 7936 7936 3
					
					fdb -p 7936
					
				fi
				
				# End.
			else
				echo "Install failed"
				echo ;
			fi
		else
			echo "Error. Invalid target."
			exit 1
		fi
	else
		echo "Package failed"
		echo ;
	fi
else
	echo "SWF failed"
	echo ;
fi