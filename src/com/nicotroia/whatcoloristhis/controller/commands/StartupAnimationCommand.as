package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;

	public class StartupAnimationCommand extends Command
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
		public var layoutModel:LayoutModel;
		
		override public function execute():void
		{
			trace("StartupAnimationCommand via " + event.type);
			
			contextView.addChild( pageContainer );
			contextView.addChild( overlayContainer );
			
			pageContainer.addChild( backgroundSprite );
			
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