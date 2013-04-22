package com.nicotroia.whatcoloristhis.view.feathers
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import flash.geom.Point;

	public class SettingsListItemRenderer extends DefaultListItemRenderer
	{
		private static const HELPER_POINT:Point = new Point();
		
		public function SettingsListItemRenderer()
		{
			
		}
		
		override protected function initialize():void
		{
			
		}
		
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = this.owner.width; //this._itemLabel.width;
			}
			
			this.labelTextRenderer.measureText(HELPER_POINT);
			
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = this.paddingTop + this.paddingBottom;
				
				newHeight += HELPER_POINT.y * 2;
			}
			
			return this.setSizeInternal(newWidth, newHeight, false);
		}
	}
}