package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.display.Screen;
	import flash.events.StageOrientationEvent;
	import flash.system.Capabilities;
	
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
			
			///*
			if( Capabilities.version.substr(0,3).toUpperCase() == "AND" ) { 
				layoutModel.changeAppLayout(Starling.current.nativeStage.orientation, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
			}
			else { 
				layoutModel.changeAppLayout(Starling.current.nativeStage.orientation, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight);
			}
			//*/
			
			//layoutModel.changeAppLayout(Starling.current.nativeStage.orientation, Screen.mainScreen.visibleBounds.width, Screen.mainScreen.visibleBounds.height);
		}
	}
}