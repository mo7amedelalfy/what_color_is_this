package com.nicotroia.whatcoloristhis.view.overlays
{
	import starling.display.Sprite;

	public class ShadowBoxView extends Sprite
	{
		public function ShadowBoxView(width:Number, height:Number)
		{	
			redraw(width, height);
		}
		
		public function redraw(width:Number, height:Number):void
		{
			//use quad...
			
			/*
			graphics.clear();
			
			graphics.beginFill(0x333333, 0.7); 
			graphics.drawRect(0,0, width, height);
			graphics.endFill();
			
			this.x = 0; 
			this.y = 0; 
			this.buttonMode = true;
			this.useHandCursor = false;
			this.mouseChildren = false;
			*/
		}
	}
}