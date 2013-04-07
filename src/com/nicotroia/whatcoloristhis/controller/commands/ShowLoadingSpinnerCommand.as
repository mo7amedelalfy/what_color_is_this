package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.view.overlays.ShadowBoxView;
	import com.nicotroia.whatcoloristhis.view.overlays.TransparentSpinner;
	
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
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		private var _hideSpinner:Boolean;
		
		override public function execute():void
		{
			trace("ShowLoadingSpinnerCommand via " + event.type);
			
			var color:uint = Assets.getRandomColor();
			
			layoutModel.shadowBoxColor = color;
			
			shadowBox.draw(layoutModel.appWidth, layoutModel.appHeight, color);
			loadingSpinner.draw(layoutModel);
			
			if( ! overlayContainer.contains( shadowBox ) ) overlayContainer.addChildAt( shadowBox, 0 );
			if( ! overlayContainer.contains( loadingSpinner ) ) overlayContainer.addChildAt( loadingSpinner, 1 );
		}
	}
}