@echo off

goto init

:init
	set FILENAME=what_color_is_this
	set ANDROID_SDK=C:\Development\Android SDK
	set AIR_SDK=C:\Development\AIR SDK
	set PROJECT_PATH=D:\FlashBuilder\%FILENAME%
	set SRC_PATH=%PROJECT_PATH%\src
	set ASSETS_PATH=%SRC_PATH%\assets
	
	echo  FILENAME == %FILENAME%
	echo  PROJECT_PATH == %PROJECT_PATH%
	echo  SRC_PATH == %SRC_PATH%
	echo  ASSETS_PATH == %ASSETS_PATH%
	
	::if -build flag start from scratch...
	::if -debug flag, make debug build else if -release...
	
	goto build-swf
goto end

:build-swf
	echo.
	echo ...building swf...
	echo.
	
	cd %SRC_PATH%
	
	if not exist %PROJECT_PATH%\bin-debug mkdir %PROJECT_PATH%\bin-debug
	
	call amxmlc -debug -library-path+=assets\swc what_color_is_this.as -output ..\bin-debug\%FILENAME%.swf
	
	if errorlevel 1 (
		echo build failed :(
		
		goto fail
	) else ( 
		echo swf success!
		
		goto build-apk
	)
goto end
	
:build-apk
	echo.
	echo ...building apk...
	echo.
	
	cd %PROJECT_PATH%\bin-debug
	
	if not exist %PROJECT_PATH%\bin-android mkdir %PROJECT_PATH%\bin-android
	
	::-connect -listen
	:: -connect 192.168.0.50
	call "%AIR_SDK%\bin\adt" -package -target apk-debug -listen -storetype pkcs12 -keystore %PROJECT_PATH%\build\cert.p12 -storepass 12345 %PROJECT_PATH%\bin-android\%FILENAME%.apk %PROJECT_PATH%\build\%FILENAME%-app.xml %FILENAME%.swf assets
	
	if errorlevel 1 (
		echo package failed :(
		
		goto fail
	) else ( 
		echo apk success!
		
		goto install-apk
	)
goto end

:install-apk
	echo.
	echo ...installing apk...
	echo.
	
	cd %PROJECT_PATH%\bin-android
	
	::-e emulator -d device -s serial
	::-r reinstall 
	::-t allow test apks
	::call adb -s HT06BHJ02332 install -r %FILENAME%.apk
	call adb -d install -r %FILENAME%.apk
	
	if errorlevel 1 ( 
		echo install failed :(
		
		goto fail
	) else ( 
		echo install success!
		
		call adb forward tcp:7936 tcp:7936
		call fdb -p 7936
		
		::-D debug
		::-n component intent (.AppEntry)
		::call adb -e shell am start -D -n air.com.nicotroia.whatcoloristhis.debug/.AppEntry
		
		::now open the app on the device, wait for the AIR dialog box, then type "run"
		
		goto end
	)
goto end

:fail
PAUSE
goto end

:end
cd %PROJECT_PATH%\build