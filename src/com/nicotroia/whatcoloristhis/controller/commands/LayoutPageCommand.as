package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;

	public class LayoutPageCommand extends Command
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function execute():void
		{
			//trace("LayoutPageCommand via " + event.type);
			
			layoutModel.orientation = contextView.stage.orientation;
		}
	}
}