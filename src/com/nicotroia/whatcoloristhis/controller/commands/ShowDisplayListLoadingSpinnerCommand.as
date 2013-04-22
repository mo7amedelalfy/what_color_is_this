package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.Assets;
	
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	public class ShowDisplayListLoadingSpinnerCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var stage:Stage;
		
		[Inject]
		public var spinnerVector:TransparentSpinnerVector;
		
		override public function execute():void
		{
			trace("ShowDisplayListLoadingSpinnerCommand via " + event.type);
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(Assets.getRandomLightColor(), 1.0);
			shape.graphics.drawRect(0,0, stage.fullScreenWidth, stage.fullScreenHeight);
			shape.graphics.endFill();
			
			spinnerVector.x = 0;
			spinnerVector.y = 0;
			
			spinnerVector.spinner.width = uint(stage.fullScreenWidth * 0.15);
			spinnerVector.spinner.scaleY = spinnerVector.spinner.scaleX;
			spinnerVector.spinner.x = (stage.fullScreenWidth * 0.5) - (spinnerVector.spinner.width * 0.5);
			spinnerVector.spinner.y = (stage.fullScreenHeight * 0.5) - (spinnerVector.spinner.height * 0.5);
			
			var colorTransform:ColorTransform = new ColorTransform(0,0,0,1, 21, 21, 21, 0);
			spinnerVector.spinner.transform.colorTransform = colorTransform;
			
			//spinnerVector.notificationTF.text = "Returning back from Camera...";
			
			stage.addChild(shape);
			stage.addChild(spinnerVector);
		}
	}
}