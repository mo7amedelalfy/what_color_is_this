package com.nicotroia.whatcoloristhis.view.overlays
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;

	public class TransparentSpinner extends Sprite //MovieClip
	{
		public var hasBeenDrawn:Boolean;
		
		private var _vector:TransparentSpinnerVector;
		private var _spinner:MovieClip;
		private var _notification:Image;
		private var _textFormat:TextFormat;
		
		public function TransparentSpinner()
		{
			_vector = new TransparentSpinnerVector();
			_textFormat = new TextFormat();
			
			super();
		}
		
		public function setTextFormat(layoutModel:LayoutModel):void
		{
			_textFormat.font = layoutModel.infoDispBold.fontName;
			_textFormat.size = 34 * layoutModel.scale * Starling.contentScaleFactor;
			//_textFormat.color = 0xffffff;
		}
		
		public function changeText(text:String, layoutModel:LayoutModel):void
		{
			_vector.notificationTF.text = text;
		}
		
		public function draw(layoutModel:LayoutModel):void
		{
			_vector.notificationTF.width = layoutModel.appWidth - (50 * layoutModel.scale) * Starling.contentScaleFactor;
			_vector.notificationTF.scaleY = _vector.notificationTF.scaleX; //(20 * layoutModel.scale) * Starling.contentScaleFactor;
			_vector.notificationTF.height += (20 * layoutModel.scale) * Starling.contentScaleFactor;
			_vector.notificationTF.x = ((layoutModel.appWidth - _vector.notificationTF.width) * 0.5) * Starling.contentScaleFactor;
			_vector.notificationTF.y = (layoutModel.appHeight * 0.5) - ((120 * layoutModel.scale)) * Starling.contentScaleFactor;
			
			setTextFormat(layoutModel);
			drawText(layoutModel);
			drawSpinner(layoutModel);
			
			//Settings
			
			hasBeenDrawn = true;
		}
		
		private function drawText(layoutModel:LayoutModel):void
		{
			removeDrawnVector(_notification);
			
			_textFormat.color = (( layoutModel.shadowBoxColor >= layoutModel.lightThreshold ) ? 0x2b2b2b : 0xffffff); 
			
			_vector.notificationTF.setTextFormat(_textFormat);
			
			_notification = createImageFromDisplayObject(_vector.notificationTF);
			addChild(_notification);
		}
		
		private function drawSpinner(layoutModel:LayoutModel):void
		{
			var textureName:String;
			
			if( Assets.roundedScaleFactor == 2 ) { 
				if( layoutModel.shadowBoxColor >= layoutModel.lightThreshold ) textureName = "spinner_dark_large";
				else textureName = "spinner_light_large";
			}
			else { 
				if( layoutModel.shadowBoxColor >= layoutModel.lightThreshold ) textureName = "spinner_dark_small";
				else textureName = "spinner_light_small";
			}
				
			if( _spinner ) { 
				Starling.juggler.remove(_spinner);
				removeDrawnVector(_spinner);
			}
			
			_spinner = new MovieClip(Assets.getSpinnerAtlas().getTextures(textureName), 30);
			_spinner.x = (layoutModel.appWidth * 0.5) - ((_spinner.width/Starling.contentScaleFactor) * 0.5);
			_spinner.y = (layoutModel.appHeight * 0.5) - ((_spinner.height/Starling.contentScaleFactor) * 0.5);
			
			Starling.juggler.add(_spinner);
			
			addChild(_spinner);
		}
		
		protected function createImageFromDisplayObject(target:flash.display.DisplayObject):Image
		{
			var bmd:BitmapData = drawVector(target);
			
			var image:Image = Image.fromBitmap(new Bitmap(bmd), true, Starling.contentScaleFactor); //Assets.scaleFactor);
			image.x = target.x;
			image.y = target.y;
			
			return image;
		}
		
		protected function drawVector(target:flash.display.DisplayObject):BitmapData
		{
			var bounds:Rectangle = target.getBounds(Starling.current.nativeStage);
			var bmd:BitmapData = new BitmapData(bounds.width + 4, bounds.height + 4, true, 0);
			
			bmd.drawWithQuality(target, 
				new Matrix(target.transform.matrix.a, 0, 0, target.transform.matrix.d, 2, 2),
				null, null, null, true, StageQuality.HIGH);
			
			return bmd;
		}
		
		protected function removeDrawnVector(target:DisplayObject):void
		{
			if( target ) { 
				//trace(" removed " + target);
				if( target.parent ) target.parent.removeChild(target);
				target.dispose();
			}
		}
	}
}