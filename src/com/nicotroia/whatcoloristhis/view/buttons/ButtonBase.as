package com.nicotroia.whatcoloristhis.view.buttons
{
	import flash.display.MovieClip;

	public class ButtonBase extends MovieClip
	{
		public var isEnabled:Boolean = true;
		
		public function ButtonBase()
		{
			super();
			
			enable();
		}
		
		public function upState():void 
		{
			this.gotoAndStop(1);
			//trace("up");
		}
		
		public function overState():void 
		{
			this.gotoAndStop(2);
			//trace("over");
		}
		
		public function downState():void
		{
			this.gotoAndStop(3);
			//trace("down");
		}
		
		public function enable():void
		{
			this.alpha = 1.0;
			this.gotoAndStop(1);
			this.buttonMode = true;
			this.mouseEnabled = true;
			this.mouseChildren = false;
			this.isEnabled = true;
			//trace("enable");
		}
		
		public function disable( lowerAlpha:Boolean = true ):void
		{
			if( lowerAlpha ) this.alpha = 0.5;
			if( this.totalFrames == 4 ) this.gotoAndStop(4);
			this.buttonMode = false;
			this.mouseEnabled = false;
			this.isEnabled = false;
			//trace("disable");
		}
	}
}