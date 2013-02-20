package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
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
		
		override public function execute():void
		{
			trace("StartupAnimationCommand via " + event.type);
			
			contextView.addChild( pageContainer );
			contextView.addChild( overlayContainer );
			
			pageContainer.addChild(backgroundSprite);
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome));
		}
	}
}