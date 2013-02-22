package com.nicotroia.whatcoloristhis.view.buttons
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.text.TextFormat;

	public class NavBarMediator extends ButtonBaseMediator
	{
		[Inject]
		public var navBar:NavBar;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		private var _textFormat:TextFormat;
		
		override public function onRegister():void
		{
			_textFormat = new TextFormat();
			
			navBar.useHandCursor = false;
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
			eventDispatcher.addEventListener(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, changeNavBarTitleHandler);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			trace("navBar resizing");
			
			trace(layoutModel.orientation);
			
			navBar.graphic.width = contextView.stage.stageWidth + 1;
			navBar.graphic.x = 0;
			navBar.graphic.y = 0;
			
			navBar.titleTF.x = 7;
			
			_textFormat.bold = true;
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || 
				layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				navBar.graphic.height = 54;
				navBar.titleTF.y = 11;
				
				_textFormat.size = 21;
			}
			else { 
				navBar.graphic.height = 64;
				navBar.titleTF.y = 16;
				
				_textFormat.size = 24;
			}
						
			navBar.titleTF.width = navBar.graphic.width - 14;
			
			navBar.titleTF.setTextFormat(_textFormat);
		}
		
		private function changeNavBarTitleHandler(event:NotificationEvent):void
		{
			navBar.titleTF.htmlText = event.text;
			navBar.titleTF.setTextFormat(_textFormat);
		}
	}
}