package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	import starling.display.Sprite;

	public class StartupAnimationCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject(name="pageContainer")]
		public var pageContainer:Sprite;
		
		[Inject(name="overlayContainer")]
		public var overlayContainer:Sprite;
		
		[Inject(name="backgroundSprite")]
		public var backgroundSprite:Sprite;
		
		[Inject]
		public var cameraModel:CameraModel;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		[Inject]
		public var sequenceModel:SequenceModel;
		
		override public function execute():void
		{
			trace("StartupAnimationCommand via " + event.type);
			
			contextView.addChild( pageContainer );
			contextView.addChild( overlayContainer );
			
			pageContainer.addChild( backgroundSprite );
			
			//lets trigger a reflow for all the pages so there isn't a lag on button presses
			for each( var PageClass:Class in sequenceModel.pageList ) { 
				var view:PageBase = sequenceModel.getPage(PageClass);
				
				view.reflowVectors(layoutModel, cameraModel);
				view.drawVectors(layoutModel, cameraModel);
				
				view.reflowed = true;
			}
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			eventDispatcher.removeEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
			
			//Wait for initial app resize before navigating.
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
	}
}