package com.nicotroia.whatcoloristhis.view.buttons
{
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	
	import flash.display.StageOrientation;
	import flash.text.TextFormat;

	public class TopNavBarMediator extends ButtonBaseMediator
	{
		[Inject]
		public var topNavBar:TopNavBar;
		
		private var _textFormat:TextFormat;
		
		override public function onRegister():void
		{
			_textFormat = new TextFormat();
			
			topNavBar.useHandCursor = false;
			
			eventDispatcher.addEventListener(NotificationEvent.APP_RESIZED, appResizedHandler);
			eventDispatcher.addEventListener(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, changeNavBarTitleHandler);
		}
		
		private function appResizedHandler(event:NotificationEvent):void
		{
			topNavBar.topNavBarGraphic.width = contextView.stage.stageWidth;
			
			topNavBar.titleTF.x = 7;
			
			_textFormat.bold = true;
			
			if( contextView.stage.orientation == StageOrientation.ROTATED_LEFT || 
				contextView.stage.orientation == StageOrientation.ROTATED_RIGHT ) { 
				topNavBar.topNavBarGraphic.height = 42;
				topNavBar.titleTF.y = 9;
				
				_textFormat.size = 18;
			}
			else { 
				topNavBar.topNavBarGraphic.height = 50;
				topNavBar.titleTF.y = 11;
				
				_textFormat.size = 21;
			}
						
			topNavBar.titleTF.width = topNavBar.topNavBarGraphic.width - 14;
			
			topNavBar.titleTF.setTextFormat(_textFormat);
		}
		
		private function changeNavBarTitleHandler(event:NotificationEvent):void
		{
			topNavBar.titleTF.htmlText = event.text;
			topNavBar.titleTF.setTextFormat(_textFormat);
		}
	}
}