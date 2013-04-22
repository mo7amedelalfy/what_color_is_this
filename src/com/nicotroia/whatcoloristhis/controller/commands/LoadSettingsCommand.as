package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.model.SettingsModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;

	public class LoadSettingsCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var settingsModel:SettingsModel;
		
		override public function execute():void
		{
			trace("LoadSettingsCommand via " + event.type);
			
			var array:Array = settingsModel.readSettings();
			
			if( array != null ) { 
				Settings.fetchCrayolaResults = array[0];
				Settings.fetchPantoneResults = array[1];
				Settings.fetchNtcResults = array[2];
				Settings.colorChoicesGivenToUser = array[3];
			}
		}
	}
}