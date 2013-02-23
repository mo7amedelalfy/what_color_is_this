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
			
			var photoButtonWidth:Number;
			var targetSize:Number;
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				welcomePage.actionBar.height = contextView.stage.stageHeight + 1;
				welcomePage.actionBar.width = 65;
				welcomePage.actionBar.x = contextView.stage.stageWidth - welcomePage.actionBar.width;
				welcomePage.actionBar.y = 0;
				
				targetSize = (contextView.stage.stageHeight - welcomePage.actionBar.width) * 0.42;
				photoButtonWidth = (contextView.stage.stageHeight * 0.3);
				
				welcomePage.takePhotoButton.width = photoButtonWidth;
				welcomePage.takePhotoButton.scaleY = welcomePage.takePhotoButton.scaleX;
				welcomePage.takePhotoButton.x = contextView.stage.stageWidth - welcomePage.takePhotoButton.width - 10;
				welcomePage.takePhotoButton.y = (contextView.stage.stageHeight * 0.5) - (welcomePage.takePhotoButton.height * 0.5);
				
				welcomePage.target.width = targetSize;
				welcomePage.target.scaleY = welcomePage.target.scaleX;
				welcomePage.target.x = ((contextView.stage.stageWidth - welcomePage.actionBar.width) * 0.5) - (welcomePage.target.width * 0.5);
				welcomePage.target.y = (contextView.stage.stageHeight * 0.5) - (welcomePage.target.height * 0.5);
				
				welcomePage.aboutPageButton.x = welcomePage.actionBar.x + 14;
				welcomePage.aboutPageButton.y = 14;	
			}
			else { 
				welcomePage.actionBar.height = 65;
				welcomePage.actionBar.width = contextView.stage.stageWidth + 1;
				welcomePage.actionBar.x = 0;
				welcomePage.actionBar.y = contextView.stage.stageHeight - welcomePage.actionBar.height;
				
				targetSize = (contextView.stage.stageWidth - welcomePage.actionBar.height - layoutModel.navBarHeight) * 0.42;
				photoButtonWidth = (contextView.stage.stageWidth * 0.3);
				
				welcomePage.takePhotoButton.width = photoButtonWidth;
				welcomePage.takePhotoButton.scaleY = welcomePage.takePhotoButton.scaleX;
				welcomePage.takePhotoButton.x = (contextView.stage.stageWidth * 0.5) - (welcomePage.takePhotoButton.width * 0.5);
				welcomePage.takePhotoButton.y = contextView.stage.stageHeight - welcomePage.takePhotoButton.height - 10;
				
				welcomePage.target.width = targetSize;
				welcomePage.target.scaleY = welcomePage.target.scaleX;
				welcomePage.target.x = (contextView.stage.stageWidth * 0.5) - (welcomePage.target.width * 0.5);
				welcomePage.target.y = layoutModel.navBarHeight + (((contextView.stage.stageHeight - welcomePage.actionBar.height - layoutModel.navBarHeight) * 0.5) - (welcomePage.target.height * 0.5));
				
				welcomePage.aboutPageButton.x = 14;
				welcomePage.aboutPageButton.y = welcomePage.actionBar.y + 14;
			}
			
		}
		
	}
}