package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.display.StageOrientation;

	public class WelcomePageMediator extends PageBaseMediator
	{
		[Inject]
		public var welcomePage:WelcomePage;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "What Color <i>Is</i> This?"));
		}
		
		override protected function appResizedHandler(event:LayoutEvent):void
		{
			trace("welcome page resized");
			
			trace(layoutModel.orientation);
			
			welcomePage.actionBar.width = contextView.stage.stageWidth + 1;
			welcomePage.actionBar.x = 0;
			
			var targetSize:Number;
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || 
				layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				welcomePage.actionBar.height = 55;
				targetSize = (contextView.stage.stageHeight * 0.3);
			}
			else { 
				welcomePage.actionBar.height = 65;
				targetSize = (contextView.stage.stageWidth * 0.3);
			}
			
			welcomePage.actionBar.y = contextView.stage.stageHeight - welcomePage.actionBar.height;
			
			welcomePage.takePhotoButton.smoothing = true;
			welcomePage.takePhotoButton.width = welcomePage.takePhotoButton.height = targetSize;
			
			welcomePage.takePhotoButton.x = (contextView.stage.stageWidth * 0.5) - (welcomePage.takePhotoButton.width * 0.5);
			welcomePage.takePhotoButton.y = contextView.stage.stageHeight - welcomePage.takePhotoButton.height - 10;
			//welcomePage.takePhotoButton
		}
	}
}