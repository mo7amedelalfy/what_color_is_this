package com.nicotroia.whatcoloristhis.controller.commands
{
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;

	public class HideDisplayListLoadingSpinnerCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var stage:Stage;
		
		override public function execute():void
		{
			trace("HideDisplayListLoadingSpinnerCommand via " + event.type);
			
			while(stage.numChildren){
				stage.removeChildAt(0);
			}
		}
	}
}