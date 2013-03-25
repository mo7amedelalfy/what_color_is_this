package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.view.overlays.ShadowBoxView;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	import starling.display.Sprite;
	
	public class ShowLoadingSpinnerCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var shadowBox:ShadowBoxView;
		
		[Inject]
		public var loadingSpinner:TransparentSpinner;
		
		[Inject(name="overlayContainer")]
		public var overlayContainer:Sprite;
		
		private var _hideSpinner:Boolean;
		
		override public function execute():void
		{
			trace("ShowLoadingSpinnerCommand via " + event.type);
			
			shadowBox.redraw(contextView.stage.stageWidth, contextView.stage.stageHeight);
						
			loadingSpinner.x = (contextView.stage.stageWidth * 0.5) - (loadingSpinner.spinner.width * 0.5); 
			loadingSpinner.y = (contextView.stage.stageHeight * 0.5) - (loadingSpinner.spinner.height * 0.5); 
			
			//if( ! overlayContainer.contains( shadowBox ) ) overlayContainer.addChildAt( shadowBox, 0 );
			//if( ! overlayContainer.contains( loadingSpinner ) ) overlayContainer.addChildAt( loadingSpinner, 1 );
		}
	}
}