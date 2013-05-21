package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.distriqt.extension.applicationrater.ApplicationRater;
	import com.distriqt.extension.applicationrater.events.ApplicationRaterEvent;
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.model.SettingsModel;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import org.robotlegs.mvcs.StarlingCommand;

	public class InitApplicationRaterCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var settingsModel:SettingsModel;
		override public function execute():void
		{
			trace("InitApplicationRaterCommand via " + event.type);
			
			try { 
				if( ApplicationRater.isSupported ) { 
					ApplicationRater.init( "fb145a7fd100652abf8c0216ba51a51f68a245c6oigy/TmV2UMBOnvU7/x0S362/YKzCNAY4kxPNQD26MdOe2+wCjEEzVa6tXbmchuErPWY4LfomlDJVJSqDESq0Q==" );
					
					trace( "ApplicationRater Supported: " + String(ApplicationRater.isSupported) );
					trace( "ApplicationRater Version: " + ApplicationRater.service.version );
					trace( "ApplicationRater State: " + ApplicationRater.service.state );
					
					//Will reset the state and application launch date because this is a new version of this app
					if( ! Settings.userHasSettingsForVersion || Settings.userHasSettingsForVersion != settingsModel.getAppVersion() ) { 
						trace( "New Application build! Resetting state." );
						ApplicationRater.service.reset(true); 
					}
					
					ApplicationRater.service.setSignificantEventsUntilPrompt(5); //Number of significant events (results completed)
					ApplicationRater.service.setLaunchesUntilPrompt(-1); //Don't remind user on app launch 
					ApplicationRater.service.setTimeBeforeReminding(3); //3 days to wait after user selected "remind me later"
					ApplicationRater.service.setDialogMessage("I would realllly like to hear your feedback! Please rate this app, even if it's just to say, 'good', 'bad' or 'meh'. Tell me how I could make this app better!");
					
					ApplicationRater.service.addEventListener( ApplicationRaterEvent.DIALOG_DISPLAYED, applicationRater_dialogDisplayedHandler, false, 0, true );
					ApplicationRater.service.addEventListener( ApplicationRaterEvent.DIALOG_CANCELLED, applicationRater_dialogCancelledHandler, false, 0, true );
					ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_RATE, applicationRater_selectedRateHandler, false, 0, true );
					ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_LATER, applicationRater_selectedLaterHandler, false, 0, true );
					ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_DECLINE, applicationRater_selectedDeclineHandler, false, 0, true );
					
					var appId:String;
					if( Capabilities.manufacturer.toString().toLowerCase().indexOf("android") > -1 ) { 
						//Android adds "air" package
						appId = "air." + NativeApplication.nativeApplication.applicationID;
					}
					else { 
						//Apple ID in your iTunes Connect application page
						appId = "638700067";
					}
					
					ApplicationRater.service.setApplicationId( appId );
					
					ApplicationRater.service.applicationLaunched();
					
					//ApplicationRater.service.showRateDialog();
				}
			}
			catch( error:Error ) 
			{
				trace("ApplicationRater Init Error: " + error.message);
			}
		}
		
		private function applicationRater_dialogDisplayedHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		private function applicationRater_dialogCancelledHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		private function applicationRater_selectedRateHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		private function applicationRater_selectedLaterHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		private function applicationRater_selectedDeclineHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
	}
}