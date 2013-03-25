package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.events.StageOrientationEvent;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	import starling.core.Starling;

	public class LayoutPageCommand extends StarlingCommand
	{
		[Inject]
		public var event:LayoutEvent;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function execute():void
		{
			trace("LayoutPageCommand via " + event.type);
			
			//trace(contextView.stage.stageWidth, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.fullScreenWidth);
			
			if( event.type == LayoutEvent.RESIZE ) { 
				
			}
			else if( event.type == LayoutEvent.ORIENTATION_CHANGE ) { 
				
			}
			
			layoutModel.layoutApp(Starling.current.nativeStage.orientation, contextView.stage.stageWidth, contextView.stage.stageHeight);
			//layoutModel.layoutApp(Starling.current.nativeStage.orientation, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
		}
	}
}