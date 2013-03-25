package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	
	import feathers.system.DeviceCapabilities;
	
	import flash.display.StageOrientation;
	
	import org.robotlegs.mvcs.Actor;
	
	import starling.core.Starling;

	public class LayoutModel extends Actor
	{
		private static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		private static const ORIGINAL_DPI_IPAD_RETINA:int = 264;
		
		public var navBarHeight:Number = 1;
		public var scale:Number = 1;
		public var infoDispBold:InfoDispBold;
		
		private var _orientation:String;
		private var _appWidth:Number;
		private var _appHeight:Number;
		private var _originalDPI:int;
		private var _scaleToDPI:Boolean;
		
		public function LayoutModel()
		{
			infoDispBold = new InfoDispBold();
			_scaleToDPI = true;
			const scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			this._originalDPI = scaledDPI;
			if(this._scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			
			this.scale = scaledDPI / this._originalDPI;
			
			_orientation = StageOrientation.UNKNOWN;
			_appWidth = Starling.current.nativeStage.fullScreenWidth;
			_appHeight = Starling.current.nativeStage.fullScreenHeight;
		}
		
		public function layoutApp($orientation:String, $appWidth:Number, $appHeight:Number):void
		{
			_orientation = $orientation;
			_appWidth = $appWidth;
			_appHeight = $appHeight;
			
			setNewProperties();
			
			eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.UPDATE_LAYOUT));
		}
		
		public function get orientation():String { return _orientation; }
		
		public function set orientation( _o:String ):void 
		{ 		
			//Using a new Event stops multiple Event.RESIZE calls from forcing pages to resize for no reason
			//However, on iOS the proper stageWidth/Height are not reported until the SECOND event...
			
			if( _orientation !== _o ) 
			{ 	
				//trace("Orientation change: " + _orientation + " to " + _o);
				
				setNewProperties();
				
				_orientation = _o; 
				
				eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.UPDATE_LAYOUT));
			}
			
		}
		
		public function get appWidth():Number { return _appWidth; }
		
		public function set appWidth(val:Number):void 
		{ 
			if( _appWidth != val ) { 
				_appWidth = val;
				
				eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.UPDATE_LAYOUT));
			}
		}
		
		public function get appHeight():Number { return _appHeight; }
		
		public function set appHeight(val:Number):void 
		{ 
			if( _appHeight != val ) { 
				_appHeight = val;
				
				eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.UPDATE_LAYOUT));
			}
		}
		
		private function setNewProperties():void
		{
			switch( _orientation ) { 
				case StageOrientation.DEFAULT : 
					navBarHeight = _appHeight * 0.2;
					break;
				case StageOrientation.ROTATED_LEFT : 
					navBarHeight = _appHeight * 0.2;
					break;
				case StageOrientation.ROTATED_RIGHT : 
					navBarHeight = _appHeight * 0.2;
					break;
				case StageOrientation.UPSIDE_DOWN : 
					navBarHeight = _appHeight * 0.2;
					break;
				case StageOrientation.UNKNOWN : 
					navBarHeight = 0;
					break;
				default : 
					break;
			}
		}
	}
}