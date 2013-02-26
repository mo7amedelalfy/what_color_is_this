package com.nicotroia.whatcoloristhis.view.buttons
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.text.TextFormat;

	public class NavBarMediator extends ButtonBaseMediator
	{
		[Inject]
		public var navBar:NavBar;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		[Inject]
		public var sequenceModel:SequenceModel;
		
		private var _textFormat:TextFormat;
		
		override public function onRegister():void
		{
			_textFormat = new TextFormat();
			
			navBar.useHandCursor = false;
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
			eventDispatcher.addEventListener(NavigationEvent.NAVIGATE_TO_PAGE, pageChangeHandler); 
			eventDispatcher.addEventListener(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, changeNavBarTitleHandler);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			trace("navBar resizing. height= " + layoutModel.navBarHeight);
			
			navBar.graphic.width = contextView.stage.stageWidth + 1;
			navBar.graphic.x = 0;
			navBar.graphic.y = 0;
			
			navBar.titleTF.x = 7;
			
			_textFormat.bold = true;
			
			if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
				//Hide the navBar only on the welcome page if rotated.
				
				if( sequenceModel.currentPage is WelcomePage ) { 
					hideNavBar();
				}
				else { 
					_textFormat.size = 21;
				}
			}
			else { 
				showNavBar();
				
				_textFormat.size = 24;
			}
			
			navBar.graphic.height = layoutModel.navBarHeight; 
			
			navBar.titleTF.width = navBar.graphic.width - 14;
			navBar.titleTF.y = (layoutModel.navBarHeight * 0.5) - (navBar.titleTF.height * 0.5);
			
			navBar.titleTF.setTextFormat(_textFormat);
		}
		
		private function pageChangeHandler(event:NavigationEvent):void
		{
			//Make sure to show the navBar on all pages except WelcomePage if rotated.
			
			if( sequenceModel.currentPage is WelcomePage ) { 
				if( layoutModel.orientation == StageOrientation.ROTATED_LEFT || layoutModel.orientation == StageOrientation.ROTATED_RIGHT ) { 
					hideNavBar();
				}
			}
			else { 
				showNavBar();
			}
		}
		
		private function changeNavBarTitleHandler(event:NotificationEvent):void
		{
			navBar.titleTF.htmlText = event.text;
			navBar.titleTF.setTextFormat(_textFormat);
		}
		
		private function hideNavBar():void
		{
			navBar.graphic.visible = false;				
			navBar.titleTF.visible = false;
		}
		
		private function showNavBar():void
		{
			navBar.graphic.visible = true;				
			navBar.titleTF.visible = true;
		}
	}
}