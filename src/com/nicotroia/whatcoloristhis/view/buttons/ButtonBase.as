package com.nicotroia.whatcoloristhis.view.buttons
{
	import starling.display.Button;
	import starling.textures.Texture;
	
	public class ButtonBase extends Button
	{
		public function ButtonBase(upState:Texture, downState:Texture)
		{
			super(upState, "", downState);
		}
	}
}