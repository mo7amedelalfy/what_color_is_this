package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	
	import flash.display.StageOrientation;
	
	import org.robotlegs.mvcs.Actor;

	public class LayoutModel extends Actor
	{
		//public var navBarHeight:Number = 55;
		//public var actionBarHeight:Number = 55;
		
		private var _orientation:String;
		
		public function LayoutModel()
		{
			_orientation = StageOrientation.UNKNOWN;
		}
		
		public function get orientation():String { return _orientation; }
		
		public function set orientation( _o:String ):void 
		{ 		
			//Using a new Event stops multiple Event.RESIZE calls from forcing pages to resize for no reason
			trace("changing " + _orientation + " orientation to " + _o);
			
			//trace( (_orientation !== _o) );
			
			if( _orientation !== _o ) 
			{ 	
				/*
				switch( _orientation ) { 
					case StageOrientation.DEFAULT : 
						navBarHeight = 65;
						actionBarHeight = 65;
						break;
					case StageOrientation.ROTATED_LEFT : 
						navBarHeight = 55;
						actionBarHeight = 65;
						break;
					case StageOrientation.ROTATED_RIGHT : 
						navBarHeight = 55;
						actionBarHeight = 65;
						break;
					case StageOrientation.UPSIDE_DOWN : 
						navBarHeight = 65;
						actionBarHeight = 65;
						break;
					case StageOrientation.UNKNOWN : 
						navBarHeight = 0;
						actionBarHeight = 0;
						break;
					default : 
						break;
				}
				*/
				
				trace("OK! Not the same.");
				
				_orientation = _o; 
				
				eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.UPDATE_LAYOUT));
			}
		}
	}
}