package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	public class AddTextToLoadingSpinnerCommand extends StarlingCommand
	{
		[Inject]
		public var notificationEvent:NotificationEvent;
		
		[Inject]
		public var loadingSpinner:TransparentSpinner;
		
		override public function execute():void
		{
			if( notificationEvent.text ) { 
				loadingSpinner.notificationTF.text = notificationEvent.text;
			}
		}
	}
}