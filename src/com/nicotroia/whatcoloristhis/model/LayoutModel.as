package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	
	import flash.display.StageOrientation;
	
	import org.robotlegs.mvcs.Actor;

	public class LayoutModel extends Actor
	{
		public var navBarHeight:Number = 64;
		
		private var _orientation:String;
		
		public function LayoutModel()
		{
			_orientation = StageOrientation.UNKNOWN;
		}
		
		public function get orientation():String { return _orientation; }
		
		public function set orientation( _o:String ):void 
		{ 		
			//Using a new Event stops multiple Event.RESIZE calls from forcing pages to resize for no reason
			
			if( _orientation !== _o ) 
			{ 	
				trace("Orientation change: " + _orientation + " to " + _o);
				
				switch( _o ) { 
					case StageOrientation.DEFAULT : 
						navBarHeight = 85;
						break;
					case StageOrientation.ROTATED_LEFT : 
						navBarHeight = 65;
						break;
					case StageOrientation.ROTATED_RIGHT : 
						navBarHeight = 65;
						break;
					case StageOrientation.UPSIDE_DOWN : 
						navBarHeight = 85;
						break;
					case StageOrientation.UNKNOWN : 
						navBarHeight = 0;
						break;
					default : 
						break;
				}
				
				_orientation = _o; 
				
				eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.UPDATE_LAYOUT));
			}
		}
	}
}