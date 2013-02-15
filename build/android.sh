ANDROID_SDK="C:\Development\Android SDK"
AIR_SDK="C:\Development\AIR SDK"
PROJECT_PATH="F:\actionscript\what_color_is_this"
SRC_PATH="$PROJECT_PATH\src"
ASSETS_PATH="$SRC_PATH\assets"
FILENAME=what_color_is_this

echo PROJECT_PATH = $PROJECT_PATH
echo SRC_PATH = $SRC_PATH
echo ASSETS_PATH = $ASSETS_PATH
echo FILENAME = $FILENAME
echo ...building swf...

cd $SRC_PATH

#"$AIR_SDK/bin/amxmlc" -debug -library-path+=$ASSETS_PATH/swc/MinimalComps_0_9_10.swc what_color_is_this.as #-output ../bin-debug/$FILENAME.swf

if [ $? == "0" ] 
then
	echo SUCCESS
	
	echo ...packaging apk...

	cd $PROJECT_PATH/bin-debug
	
	# -connect -listen
	#"$AIR_SDK/bin/adt" -package -target apk-debug -connect 192.168.0.50 -storetype pkcs12 -keystore ../build/cert.p12 -storepass 12345 ../bin-android/$FILENAME.apk $FILENAME-app.xml $FILENAME.swf
	
	if [ $? == "0" ] 
	then 
		echo SUCCESS
		echo ...installing...
		
		#cd ../bin-android
		
		# -r reinstall 
		# -t allow test apks
		#adb -e install -r -t $FILENAME.apk
		#adb forward tcp:7936 tcp:7936
		
		#"$AIR_SDK/bin/fdb" -p 7936
	else 
		echo FAIL
	fi
else
	echo FAIL
fi