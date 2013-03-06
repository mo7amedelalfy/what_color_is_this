package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	
	import org.robotlegs.mvcs.Command;

	public class LayoutPageCommand extends Command
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function execute():void
		{
			trace("LayoutPageCommand via " + event.type);
			
			if( event.type == Event.RESIZE ) { 
				layoutModel.layoutApp(contextView.stage.orientation, contextView.stage.fullScreenWidth, contextView.stage.fullScreenHeight);
				//layoutModel.appWidth = contextView.stage.fullScreenWidth; //contextView.stage.stageWidth;
				//layoutModel.appHeight = contextView.stage.fullScreenHeight; //stageHeight;
			}
			else if( event.type == StageOrientationEvent.ORIENTATION_CHANGE ) { 
				layoutModel.layoutApp(contextView.stage.orientation, contextView.stage.fullScreenWidth, contextView.stage.fullScreenHeight);
				//layoutModel.orientation = contextView.stage.orientation;
				//layoutModel.appWidth = contextView.stage.fullScreenWidth; //contextView.stage.stageWidth;
				//layoutModel.appHeight = contextView.stage.fullScreenHeight; //stageHeight;
			}
			
		}
	}
}