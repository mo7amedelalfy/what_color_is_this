@echo off

goto init

:init
	set ANDROID_SDK=C:\Development\Android SDK
	set AIR_SDK=C:\Development\AIR SDK
	set PROJECT_PATH=F:\actionscript\what_color_is_this
	set SRC_PATH=%PROJECT_PATH%\src
	set ASSETS_PATH=%SRC_PATH%\assets
	set FILENAME=what_color_is_this
	
	echo  PROJECT_PATH == %PROJECT_PATH%
	echo  SRC_PATH == %SRC_PATH%
	echo  ASSETS_PATH == %ASSETS_PATH%
	echo  FILENAME == %FILENAME%
	
	goto build-swf
goto end

:build-swf
	echo.
	echo ...building swf...
	echo.
	
	cd %SRC_PATH%
	
	call amxmlc -debug -library-path+=assets\swc\MinimalComps_0_9_10.swc what_color_is_this.as -output ..\bin-debug\%FILENAME%.swf
	
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
	
	::-connect -listen
	:: -connect 192.168.0.50
	call adt -package -target apk-debug -connect -storetype pkcs12 -keystore ..\build\cert.p12 -storepass 12345 ..\bin-android\%FILENAME%.apk ..\build\%FILENAME%-app.xml %FILENAME%.swf 
	
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
	
	cd ../bin-android
	
	::-e emulator -d device
	::-r reinstall 
	::-t allow test apks
	call adb -d install -r %FILENAME%.apk
	
	if errorlevel 1 ( 
		echo install failed :(
		
		goto fail
	) else ( 
		echo install success!
		
		::-D debug
		::-n component intent (.AppEntry)
		::call adb -e shell am start -D -n air.com.nicotroia.whatcoloristhis.debug/.AppEntry
		
		goto end
	)
goto end

:fail
PAUSE
goto end

:end
cd %PROJECT_PATH%