# echo There are $# arguments to $0: 
# echo PROJECT_PATH = $1
# echo FILENAME = $2

PROJECT_PATH=F:\\actionscript\\what_color_is_this
FILENAME=what_color_is_this

echo PROJECT_PATH = $PROJECT_PATH
echo FILENAME = $FILENAME

# echo ...building swf...
# amxmlc -library-path+=assets/swc/MinimalComps_0_9_10.swc -- what_color_is_this.as

echo ...packaging apk...

ANDROID_SDK="C:\Development\Android SDK"
AIR_SDK="C:\Program Files (x86)\Adobe\Adobe Flash Builder 4.6\sdks\4.6.0"

cd $PROJECT_PATH/bin-debug
"$AIR_SDK/bin/adt" -package -target apk-debug -listen -storetype pkcs12 -keystore ../build/cert.p12 -storepass 12345 ../bin-android/$FILENAME.apk $FILENAME-app.xml $FILENAME.swf # &> /dev/null

#-connect 192.168.0.50
#-listen



#install all new player, SDKs in both flash builder and flash ide... 
#unexpected flash player version...
#AIR namespace 3.1 3.2...



if [ $? == "0" ] 
then 
	echo SUCCESS
	echo ...installing...
	
	cd ../bin-android
	adb install -r $FILENAME.apk
	adb forward tcp:7936 tcp:7936
	
	"$AIR_SDK/bin/fdb" -p 7936
	
else 
	echo PACKAGE: FAIL
fi