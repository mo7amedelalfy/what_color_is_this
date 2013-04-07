package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.view.overlays.TransparentSpinner;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	public class AddTextToLoadingSpinnerCommand extends StarlingCommand
	{
		[Inject]
		public var notificationEvent:NotificationEvent;
		
		[Inject]
		public var loadingSpinner:TransparentSpinner;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function execute():void
		{
			trace("AddTextToLoadingSpinnerCommand via " + notificationEvent.type, notificationEvent.text);
			
			if( notificationEvent.text ) { 
				loadingSpinner.changeText(notificationEvent.text, layoutModel);
			}
		}
	}
}