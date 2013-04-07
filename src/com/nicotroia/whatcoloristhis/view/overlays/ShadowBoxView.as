package com.nicotroia.whatcoloristhis.view.overlays
{
	import starling.display.Quad;
	import starling.display.Sprite;

	public class ShadowBoxView extends Sprite
	{
		public function ShadowBoxView(width:Number, height:Number)
		{	
			
		}
		
		public function draw(width:Number, height:Number, color:uint):void
		{
			var quad:Quad = new Quad(width, height, color); //0x333333);
			
			addChild(quad);
		}
	}
}