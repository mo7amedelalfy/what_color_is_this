package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	import starling.display.Image;
	
	public class AboutPage extends PageBase
	{
		public var backButton:Button;
		
		private var _aboutTextImage:Image;
		private var _titleTextFormat:TextFormat;
		private var _subTextFormat:TextFormat;
		
		public function AboutPage()
		{
			vectorPage = new AboutPageVector();
			_titleTextFormat = new TextFormat();
			_subTextFormat = new TextFormat();
			
			super();
		}
		
		protected function setupTextFormats(layoutModel:LayoutModel):void
		{
			_titleTextFormat.font = layoutModel.infoDispBold.fontName;
			_titleTextFormat.size = 32 * layoutModel.scale;
			_titleTextFormat.align = TextFormatAlign.CENTER;
			_titleTextFormat.color = 0x333333;
			
			_subTextFormat.font = layoutModel.infoDispMedium.fontName;
			_subTextFormat.size = 24 * layoutModel.scale;
			_subTextFormat.leading = 12 * layoutModel.scale;
			_subTextFormat.align = TextFormatAlign.CENTER;
			_subTextFormat.color = 0x666666;
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			setupTextFormats( layoutModel );
			
			trace("about page reflowing vectors");
			
			var padding:Number = 24 * layoutModel.scale;
			var subPadding:Number = padding * 0.5; 
			var tfWidth:Number = layoutModel.appWidth - (padding * 2);
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			vectorPage.about.x = 0;
			vectorPage.about.y = 0;
			//vectorPage.about.height = layoutModel.appHeight;
			
			vectorPage.about.nicoTF.x = padding;
			vectorPage.about.nicoTF.y = (layoutModel.navBarHeight/Starling.contentScaleFactor) + padding + padding;
			vectorPage.about.nicoTF.width = tfWidth;
			vectorPage.about.nicoTF.height = 30 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.nicoTF.multiline = false;
			vectorPage.about.nicoTF.wordWrap = false;
			vectorPage.about.nicoTF.setTextFormat( _titleTextFormat );
			
			vectorPage.about.appHomeTF.x = padding;
			vectorPage.about.appHomeTF.y = vectorPage.about.nicoTF.y + vectorPage.about.nicoTF.textHeight + padding + subPadding;
			vectorPage.about.appHomeTF.width = tfWidth;
			vectorPage.about.appHomeTF.height = 30 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.appHomeTF.multiline = false;
			vectorPage.about.appHomeTF.wordWrap = false;
			vectorPage.about.appHomeTF.setTextFormat( _titleTextFormat );
			
			vectorPage.about.appHomeValueTF.x = padding;
			vectorPage.about.appHomeValueTF.y = vectorPage.about.appHomeTF.y + vectorPage.about.appHomeTF.textHeight + subPadding;
			vectorPage.about.appHomeValueTF.width = tfWidth;
			vectorPage.about.appHomeValueTF.height = 30 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.appHomeValueTF.multiline = false;
			vectorPage.about.appHomeValueTF.wordWrap = false;
			vectorPage.about.appHomeValueTF.setTextFormat( _subTextFormat );
			
			vectorPage.about.crayolaTF.x = padding;
			vectorPage.about.crayolaTF.y = vectorPage.about.appHomeValueTF.y + vectorPage.about.appHomeValueTF.textHeight + padding + subPadding;
			vectorPage.about.crayolaTF.width = tfWidth;
			vectorPage.about.crayolaTF.height = 30 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.crayolaTF.multiline = false;
			vectorPage.about.crayolaTF.wordWrap = false;
			vectorPage.about.crayolaTF.setTextFormat( _titleTextFormat );
			
			vectorPage.about.crayolaValueTF.x = padding;
			vectorPage.about.crayolaValueTF.y = vectorPage.about.crayolaTF.y + vectorPage.about.crayolaTF.textHeight + subPadding;
			vectorPage.about.crayolaValueTF.width = tfWidth;
			vectorPage.about.crayolaValueTF.height = 130 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.crayolaValueTF.multiline = true;
			vectorPage.about.crayolaValueTF.wordWrap = false;
			vectorPage.about.crayolaValueTF.setTextFormat( _subTextFormat );
			
			vectorPage.about.pantoneTF.x = padding;
			vectorPage.about.pantoneTF.y = vectorPage.about.crayolaValueTF.y + vectorPage.about.crayolaValueTF.textHeight + padding + subPadding;
			vectorPage.about.pantoneTF.width = tfWidth;
			vectorPage.about.pantoneTF.height = 30 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.pantoneTF.multiline = false;
			vectorPage.about.pantoneTF.wordWrap = false;
			vectorPage.about.pantoneTF.setTextFormat( _titleTextFormat );
			
			vectorPage.about.pantoneValueTF.x = padding;
			vectorPage.about.pantoneValueTF.y = vectorPage.about.pantoneTF.y + vectorPage.about.pantoneTF.textHeight + subPadding;
			vectorPage.about.pantoneValueTF.width = tfWidth;
			vectorPage.about.pantoneValueTF.height = 130 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.pantoneValueTF.multiline = true;
			vectorPage.about.pantoneValueTF.wordWrap = false;
			vectorPage.about.pantoneValueTF.setTextFormat( _subTextFormat );
			
			vectorPage.about.ntcTF.x = padding;
			vectorPage.about.ntcTF.y = vectorPage.about.pantoneValueTF.y + vectorPage.about.pantoneValueTF.textHeight + padding + subPadding;
			vectorPage.about.ntcTF.width = tfWidth;
			vectorPage.about.ntcTF.height = 30 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.ntcTF.multiline = false;
			vectorPage.about.ntcTF.wordWrap = false;
			vectorPage.about.ntcTF.setTextFormat( _titleTextFormat );
			
			vectorPage.about.ntcValueTF.x = padding;
			vectorPage.about.ntcValueTF.y = vectorPage.about.ntcTF.y + vectorPage.about.ntcTF.textHeight + subPadding;
			vectorPage.about.ntcValueTF.width = tfWidth;
			vectorPage.about.ntcValueTF.height = 130 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.about.ntcValueTF.multiline = true;
			vectorPage.about.ntcValueTF.wordWrap = false;
			vectorPage.about.ntcValueTF.setTextFormat( _subTextFormat );
			
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void
		{	
			trace("about page drawing vectors");
			
			//Remove first
			removeDrawnVector( _background );
			removeDrawnVector( _aboutTextImage );
			
			//Create
			_background = drawBackgroundQuad();
			backButton = new Button();
			_aboutTextImage = createImageFromLotsOfText( vectorPage.about );
			
			//Add
			addChildAt(_background, 0);
			addChild( _aboutTextImage );
			
			//Settings
			backButton.label = "Back";
		}
		
		private function createImageFromLotsOfText(target:DisplayObject):Image
		{
			//for some reason the base createImageFromDisplayObject method cuts off the text...
			
			var bounds:Rectangle = target.getBounds(Starling.current.nativeStage);
			bounds.height += 150; 
			
			var bmd:BitmapData = new BitmapData(bounds.width + 4, bounds.height + 4, true, 0);
			
			bmd.drawWithQuality(target, 
				new Matrix(target.transform.matrix.a, 0, 0, target.transform.matrix.d, 2, 2),
				null, null, null, true, StageQuality.HIGH);
			
			var image:Image = Image.fromBitmap(new Bitmap(bmd, PixelSnapping.ALWAYS), true, Starling.contentScaleFactor); 
			image.x = target.x;
			image.y = target.y;
			
			return image;
		}
	}
}