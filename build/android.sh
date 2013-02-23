ANDROID_SDK="C:\Development\Android SDK"
AIR_SDK="C:\Development\AIR SDK"
PROJECT_PATH="F:\actionscript\what_color_is_this"
SRC_PATH="$PROJECT_PATH\src"
ASSETS_PATH="$SRC_PATH\assets"
FILENAME=what_color_is_this

echo FILENAME = $FILENAME
echo PROJECT_PATH = $PROJECT_PATH
echo SRC_PATH = $SRC_PATH
echo ASSETS_PATH = $ASSETS_PATH

echo ...building swf...

cd $SRC_PATH

"$AIR_SDK/bin/amxmlc" -debug -library-path+=assets/swc what_color_is_this.as -output ../bin-debug/$FILENAME.swf

echo ...building apk...

cd $PROJECT_PATH/bin-debug

"$AIR_SDK/bin/adt" -package -target apk-debug -listen -storetype pkcs12 -keystore ../build/cert.p12 -storepass 12345 ../bin-android/$FILENAME.apk ../build/$FILENAME-app.xml $FILENAME.swf assets

echo ...installing apk...

cd $PROJECT_PATH/bin-android

"$ANDROID_SDK/platform_tools/adb" -e install -r $FILENAME.apk

if [ $? == "0" ] 
then
	"$ANDROID_SDK/platform_tools/adb" forward tcp:7936 tcp:7936
	"$AIR_SDK/bin/fdb" -p 7936
	#now open the app on the device, wait for the AIR dialog box, then type "run"
else
	echo install failed.
fi