package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.view.overlays.ShadowBoxView;
	import com.nicotroia.whatcoloristhis.view.overlays.TransparentSpinner;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	import starling.display.Sprite;
	
	public class HideLoadingSpinnerCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject(name="overlayContainer")]
		public var overlayContainer:Sprite;
		
		[Inject]
		public var shadowBox:ShadowBoxView;
		
		[Inject]
		public var loadingSpinner:TransparentSpinner;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function execute():void
		{
			trace("HideLoadingSpinnerCommand via " + event.type);
			
			//setTimeout( function():void { 
				
			loadingSpinner.changeText("", layoutModel);
			
			if( overlayContainer.contains(shadowBox) ) overlayContainer.removeChild(shadowBox);
			if( overlayContainer.contains(loadingSpinner) ) overlayContainer.removeChild(loadingSpinner);
			
			//}, 2000);
		}
	}
}