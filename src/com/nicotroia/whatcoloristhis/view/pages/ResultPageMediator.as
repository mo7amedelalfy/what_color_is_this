package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.display.Shape;
	import flash.display.StageOrientation;

	public class ResultPageMediator extends PageBaseMediator
	{
		[Inject]
		public var resultPage:ResultPage;
		
		[Inject]
		public var cameraModel:CameraModel;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		private var _winningColor:Shape;
		
		override public function onRegister():void
		{
			_winningColor = new Shape();
			
			super.onRegister();
			
			resultPage.colorNameTF.text = "0x" + cameraModel.winner;
			
			resultPage.addChildAt(_winningColor, 0);
			
			appResizedHandler(null);
		}
		
		override protected function appResizedHandler(event:LayoutEvent):void
		{
			trace("result page resized");
			
			resultPage.backButton.height = layoutModel.navBarHeight * 0.70;
			resultPage.backButton.scaleX = resultPage.backButton.scaleY;
			resultPage.backButton.x = 14;
			resultPage.backButton.y = (layoutModel.navBarHeight - resultPage.backButton.height) * 0.5;
			
			resultPage.thisThingTF.width = contextView.stage.stageWidth;
			resultPage.thisThingTF.x = 0;
			resultPage.thisThingTF.y = contextView.stage.stageHeight * 0.3;
			
			resultPage.colorNameTF.width = contextView.stage.stageWidth;
			resultPage.colorNameTF.x = 0;
			resultPage.colorNameTF.y = contextView.stage.stageHeight * 0.5;
			
			colorBackground();
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				
			}
			else { 
				
			}
		}
		
		private function colorBackground():void
		{
			_winningColor.graphics.clear();
			_winningColor.graphics.beginFill( uint("0x"+ cameraModel.winner), 1.0 );
			_winningColor.graphics.drawRect(0, layoutModel.navBarHeight, contextView.stage.stageWidth, contextView.stage.stageHeight - layoutModel.navBarHeight);
			_winningColor.graphics.endFill();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			trace("result page removing.");
			
			if( resultPage.contains(_winningColor) ) resultPage.removeChild(_winningColor);
		}
	}
}