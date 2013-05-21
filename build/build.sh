##
# CONFIG... 
##

# Name
FILENAME="what_color_is_this"
APP_ID="com.nicotroia.whatcoloristhis"

# SDKs
ANDROID_SDK="/Users/nicotroia/Development/android-sdk"
AIR_SDK="/Users/nicotroia/Development/air-sdk"
BB_SDK="/Users/nicotroia/Development/blackberry-tablet-sdk-3.1.2"
IPHONE_SDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk"

# Paths
PROJECT_PATH="/Users/nicotroia/PROJECTS/what_color_is_this"
SRC_PATH="$PROJECT_PATH/src"
LIB_PATH="$PROJECT_PATH/libs"
ASSETS_PATH="$SRC_PATH/assets"
EXTENSIONS_PATH="$SRC_PATH/extensions"

# All
# Leave blank to be prompted for your certificate password
STOREPASS=""

# iOS 
# To create a p12 file for iOS, download the .cer certificate from Apple iOS Provisioning Profile and add it to KeyChain if it doesn't exist. Find it, locate the private key and right-click export to .p12 file.
IOS_DEVELOPMENT_CERT="$PROJECT_PATH/build/ios/cert.p12"
IOS_DISTRIBUTION_CERT="$PROJECT_PATH/build/ios/distribution.p12"
IOS_DEVELOPMENT_MOBILEPROVISION="$PROJECT_PATH/build/ios/what_color_is_this_development.mobileprovision"
IOS_DISTRIBUTION_MOBILEPROVISION="$PROJECT_PATH/build/ios/what_color_is_this_appstore.mobileprovision"
# IOS_DISTRIBUTION_MOBILEPROVISION="$PROJECT_PATH/build/ios/what_color_is_this_distribution.mobileprovision"

# Android
# We just use a self-signed certificate with Android...
ANDROID_CERT="$PROJECT_PATH/build/android/cert.p12"

# BlackBerry



##
# CODE SIGNING... 
##

if [ $1 == "-sign" ]
then
	echo ;
	echo "Creating a self-signed digital code signing certificate with ADT"
	echo ;
	
	cd $PROJECT_PATH/build
	
	# adt -certificate -cn name -ou orgUnit -o orgName -c country -validityPeriod years key-type output password
	"$AIR_SDK/bin/adt" -certificate -cn $FILENAME -c US 1024-RSA ./$FILENAME-cert.p12 12345
	
	STATUS=$?
	if [ $STATUS -eq 0 ] 
	then
		echo ;
		echo "Cert build Success"
		echo ;
		
		exit 0
	else
		echo ;
		echo "Cert build Fail"
		echo ;
		
		exit 1
	fi

elif [ $# -lt 2 ]
then
	# Too few arguments supplied
	
	echo ;
	echo "Error. Target arguments are missing. build.sh -platform -target #device-id"
	echo ;
	echo "Example: build.sh -ios -debug 3"
	echo ;
	
	exit 1
	
else
	# All good, continue...
	
	echo $1 $2 $3
	echo ;
fi


echo "FILENAME = $FILENAME"
echo "PROJECT_PATH = $PROJECT_PATH"
echo "SRC_PATH = $SRC_PATH"
echo "ASSETS_PATH = $ASSETS_PATH"


##
# BUILD SWF... 
##

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

# "Initial window content is invalid" if no "-debug"...
# -compress=false required for ios simulator
"$AIR_SDK/bin/amxmlc" -compress=false -debug=$DEBUG -library-path+=$LIB_PATH $FILENAME.as -output $PROJECT_PATH/bin-debug/$FILENAME.swf

# Read the exit status of amxmlc to determine if there was an error
STATUS=$?
if [ $STATUS -eq 0 ] 
then
	echo "SWF success"
	echo ;
	
	# Creates assets dir if doesn't exist
	mkdir -p $PROJECT_PATH/src/assets
	
	# Copy necessary files to the bin-debug dir
	cp -r $PROJECT_PATH/src/assets $PROJECT_PATH/bin-debug
	cp $PROJECT_PATH/src/$FILENAME-app.xml $PROJECT_PATH/bin-debug/$FILENAME-app.xml
	cp $PROJECT_PATH/src/Default-568h@2x.png $PROJECT_PATH/bin-debug/Default-568h@2x.png
	
	
	##
	# BUILD PACKAGE..
	##
	
	if [ -z $EXTENSIONS_PATH ]
	then
		EXTENSIONS=""
	else
		EXTENSIONS="-extdir $EXTENSIONS_PATH"
	fi
	
	if [ -z $STOREPASS ]
	then
		PASSWORD=""
	else 
		PASSWORD="-storepass $STOREPASS"
	fi
	
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
		"$AIR_SDK/bin/adt" -package -target $ANDROID_TARGET $LISTEN -storetype pkcs12 -keystore $ANDROID_CERT $PASSWORD $PROJECT_PATH/bin-android/$FILENAME.apk $PROJECT_PATH/src/$FILENAME-app.xml $FILENAME.swf assets/ $EXTENSIONS
	
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
			KEYSTORE=$IOS_DEVELOPMENT_CERT
			PROVISIONING_PROFILE=$IOS_DEVELOPMENT_MOBILEPROVISION
		elif [ $2 == "-simulator" ]
		then
			IOS_TARGET="ipa-debug-interpreter-simulator"
			EXTRA="-platformsdk $IPHONE_SDK"
			KEYSTORE=$IOS_DEVELOPMENT_CERT
			PROVISIONING_PROFILE=$IOS_DEVELOPMENT_MOBILEPROVISION
		elif [ $2 == "-adhoc" ]
		then
			IOS_TARGET="ipa-ad-hoc"
			KEYSTORE=$IOS_DISTRIBUTION_CERT
			PROVISIONING_PROFILE=$IOS_DISTRIBUTION_MOBILEPROVISION
		elif [ $2 == "-appstore" ]
		then
			IOS_TARGET="ipa-app-store"
			KEYSTORE=$IOS_DISTRIBUTION_CERT
			PROVISIONING_PROFILE=$IOS_DISTRIBUTION_MOBILEPROVISION
		else
			IOS_TARGET="ipa-debug"
			KEYSTORE=$IOS_DEVELOPMENT_CERT
			PROVISIONING_PROFILE=$IOS_DEVELOPMENT_MOBILEPROVISION
		fi
		
		"$AIR_SDK/bin/adt" -package -target $IOS_TARGET $LISTEN -storetype pkcs12 -keystore $KEYSTORE $PASSWORD -provisioning-profile $PROVISIONING_PROFILE $PROJECT_PATH/bin-ios/$FILENAME.ipa $PROJECT_PATH/src/$FILENAME-app.xml Default-568h@2x.png $FILENAME.swf assets/ $EXTENSIONS $EXTRA
	
	elif [ $1 == "-bb" ]
	then
		echo "...Building blackberry BAR..."
		echo ;
		
		mkdir -p $PROJECT_PATH/bin-bb
		
		# blackberry-airpackager -package [project_name].bar -installApp -launchApp [project_name]-app.xml [project_name].swf [ANE files][icon file][other_project_files] -device [Simulator_IP_address] -password password -forceAirVersion 3.1
		# -installApp -launchApp 
		# -device [Simulator_IP_address] -forceAirVersion 3.1
		
		"$BB_SDK/bin/blackberry-airpackager" -package $PROJECT_PATH/bin-bb/$FILENAME.bar $PROJECT_PATH/src/$FILENAME-app.xml $FILENAME.swf assets/ -forceAirVersion 3.1
		
	else
		echo "Error. Invalid target."
		echo ;
		
		exit 1
	fi
	
	
	
	##
	# INSTALL PACKAGE..
	##
	
	# Read status again
	STATUS=$?
	if [ $STATUS -eq 0 ]
	then
		echo "Package success"
		echo ;
		
		echo "...Installing package..."
		echo ;
		
		if [ "$3" == "-none" ]
		then
			echo "Not installing to a device."
			echo ;
			
			exit 0
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
				echo "Android Install success"
				echo ;
				
				if [ $2 == "-debug" ]
				then
					echo "Please run the app on the device then type 'run' in fdb"
					echo ;
					
					adb forward tcp:7936 tcp:7936
					
					fdb -p 7936
					
					exit 0
				else
					exit 0
				fi
			else
				echo "Android Install failed"
				echo ;
				
				exit 1
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
					echo ;
					
					exit 1
				fi
				
				"$AIR_SDK/lib/aot/bin/iOSBin/idb" -install $FILENAME.ipa $3
				
			fi
			
			STATUS=$?
			if [ $STATUS -eq 0 ]
			then
				echo ;
				echo "iOS Install success"
				echo ;
				
				if [ $2 == "-simulator" ] 
				then
					"$AIR_SDK/bin/adt" -launchApp -platform ios -platformsdk $IPHONE_SDK -device ios-simulator -appid $APP_ID
				
				elif [ $2 == "-debug" ]
				then
					echo "Run the app on the device then type 'run' in fdb"
					echo ;
					
					# This command hangs the terminal for some reason...
					# "$AIR_SDK/lib/aot/bin/iOSBin/idb" -forward 7936 7936 3
					
					fdb -p 7936
				else
					echo ;
				fi
				
				exit 0
				
			else
				echo "iOS Install failed"
				echo ;
				
				exit 1
			fi
			
		elif [ $1 == "-bb" ]
		then
			# Install bb package
			
			cd $PROJECT_PATH/bin-bb
			
			if [ $2 == "-simulator" ] 
			then
				# -z string length > 0
				if [ -z "$3" ]
				then
					echo "Error: simulator ip argument missing. Example: build.sh -bb -simulator 192.168.2.1"
					exit 1
				fi
				
				# /blackberry-deploy -installApp -password <simulator password> -device <simulator IP address> -package <BAR file path>
				
				"$BB_SDK/bin/blackberry-deploy" -installApp -device $3 -package $FILENAME.bar
				
			else
			 	echo "Not installing to BB simulator"
			 	echo ;
			 	echo "If you want to sign your application..."
			 	echo ;
			 	echo "$BB_SDK/bin/blackberry-signer -storepass <KeystorePassword> <BAR_file.bar>"
			 	echo ;
			 	
			 	exit 0
			fi
			
			STATUS=$?
			if [ $STATUS -eq 0 ]
			then
				echo "BB Install success"
				echo ;
				
				exit 0
			else
				echo "BB Install failed"
				echo ;
				
				exit 1
			fi
			
		else
			echo "Error. Invalid target."
			echo ;
			
			exit 1
		fi
	else
		echo "Package failed"
		echo ;
		
		exit 1
	fi
else
	echo "SWF failed"
	echo ;
	
	exit 1
fi
