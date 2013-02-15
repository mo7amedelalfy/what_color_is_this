package com.nicotroia.whatcoloristhis.controller.commands
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;

	public class ResizeAppCommand extends Command
	{
		[Inject]
		public var event:Event;
		
		[Inject(name="backgroundSprite")]
		public var backgroundSprite:Sprite;
		
		override public function execute():void
		{
			//trace("ResizeAppCommand via " + event.type);
			
			backgroundSprite.graphics.clear();
			backgroundSprite.graphics.beginFill(Math.random() * 0xffffff, 1.0);
			backgroundSprite.graphics.drawRect(0,0,contextView.stage.stageWidth, contextView.stage.stageHeight);
			backgroundSprite.graphics.endFill();
		}
	}
}