package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.view.overlay.ShadowBoxView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	public class HideLoadingSpinnerCommand extends Command
	{
		[Inject]
		public var event:Event;
		
		[Inject(name="overlayContainer")]
		public var overlayContainer:Sprite;
		
		[Inject]
		public var shadowBox:ShadowBoxView;
		
		[Inject]
		public var loadingSpinner:TransparentSpinner;
		
		override public function execute():void
		{
			trace("HideLoadingSpinnerCommand via " + event.type);
			
			loadingSpinner.notificationTF.text = '';
			
			if( overlayContainer.contains(shadowBox) ) overlayContainer.removeChild(shadowBox);
			if( overlayContainer.contains(loadingSpinner) ) overlayContainer.removeChild(loadingSpinner);
		}
	}
}