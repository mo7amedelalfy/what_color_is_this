package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.Settings;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.robotlegs.mvcs.Actor;

	public class SettingsModel extends Actor
	{
		public var file:File;
		public var fileStream:FileStream;
		
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
			var settings:Array = [
				Settings.fetchCrayolaResults, 
				Settings.fetchPantoneResults, 
				Settings.fetchNtcResults, 
				Settings.colorChoicesGivenToUser ];
			
			var json:String = JSON.stringify(settings);
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(json);
			fileStream.close();
		}
	}
}