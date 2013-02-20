package com.nicotroia.whatcoloristhis.view.pages
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class PageBase extends Sprite
	{
		public var graphic:DisplayObject;
		
		public function PageBase()
		{
			this.alpha = 0.0;
			//stop();
		}
		
		public function show(durationSec:Number = 0.5, delaySec:Number = 0, callBack:Function = null):void
		{
			this.x = 24;
			TweenLite.to(this, durationSec, {alpha:1.0, x:0, delay:delaySec, ease:Circ.easeInOut, onComplete:callBack });
		}
		
		public function hide(durationSec:Number = 0.5, delaySec:Number = 0, callBack:Function = null):void
		{
			//x:-50,
			TweenLite.to(this, durationSec, {alpha:0.0, x:-50, delay:delaySec, ease:Circ.easeInOut, onComplete:callBack });			
		}
	}
}