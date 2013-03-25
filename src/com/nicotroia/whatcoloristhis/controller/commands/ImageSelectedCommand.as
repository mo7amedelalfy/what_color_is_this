package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.CameraEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import org.robotlegs.mvcs.StarlingCommand;

	public class ImageSelectedCommand extends StarlingCommand
	{
		[Inject]
		public var event:CameraEvent;
		
		override public function execute():void
		{
			trace("ImageSelectedEvent via " + event.type);
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_AreaSelect));
		}
	}
}