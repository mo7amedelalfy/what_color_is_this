package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.Settings;
	
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.robotlegs.mvcs.Actor;

	public class SettingsModel extends Actor
	{
		public var file:File;
		public var fileStream:FileStream;

		private var _settings:Array = [];
		
		public function SettingsModel()
		{
			file = File.applicationStorageDirectory.resolvePath("Settings.json");
			
			fileStream = new FileStream();
		}
		
		public function readSettings():Array
		{
			if( file.exists ) { 
				fileStream.open(file, FileMode.READ);
				
				var contents:String = fileStream.readMultiByte(fileStream.bytesAvailable, "utf-8");
				fileStream.close();
				
				var array:Array = JSON.parse(contents) as Array;
				
				return array;
			}
			
			return null;
		}
		
		public function writeSettings():void
		{
			_settings[0] = getAppVersion(); //Settings.userHasSettingsForVersion;
			_settings[1] = Settings.fetchCrayolaResults;
			_settings[2] = Settings.fetchPantoneResults;
			_settings[3] = Settings.fetchNtcResults;
			_settings[4] = Settings.colorChoicesGivenToUser;
			
			var json:String = JSON.stringify(_settings);
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(json);
			fileStream.close();
		}
		
		public function howManyResultsAreThere():uint
		{
			var num:uint = 0;
			
			if( Settings.fetchCrayolaResults ) num++;
			if( Settings.fetchNtcResults ) num++;
			if( Settings.fetchPantoneResults ) num++;
			
			return num;
		}
		
		public function getAppVersion():String {
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			var appVersion:String = appXml.ns::versionNumber[0];
			
			return appVersion;
		}
	}
}