package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.CameraEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import org.robotlegs.mvcs.Command;

	public class ImageSelectFailedCommand extends Command
	{
		[Inject]
		public var event:CameraEvent;
		
		override public function execute():void
		{
			trace("ImageSelectFailedCommand via " + event.type);
			
			//what else?
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
	}
}