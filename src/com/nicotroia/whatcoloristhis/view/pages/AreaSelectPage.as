package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.StageOrientation;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class AreaSelectPage extends PageBase
	{
		public var image:Image;
		public var target:Image;
		public var imageBitmap:Bitmap;
		public var backButton:feathers.controls.Button;
		public var acceptButton:starling.display.Button;
		public var cancelButton:starling.display.Button;
		
		private var _actionBar:Image;
		
		public function AreaSelectPage()
		{
			vectorPage = new AreaSelectPageVector();
			
			super();
		}
		
		public function drawCapturedImage(layoutModel:LayoutModel, cameraModel:CameraModel):void
		{
			//var isPortrait:Boolean = (cameraModel.photoData.height / cameraModel.photoData.width) > 1.0;
			var maxLength:int = Math.min(layoutModel.appWidth - 28, layoutModel.appHeight - layoutModel.navBarHeight - 28);
			var scale:Number = maxLength / cameraModel.photoData.width;
			var matrix:Matrix = new Matrix();
			
			matrix.scale(scale, scale);
			
			var smallBMD:BitmapData = new BitmapData(cameraModel.photoData.width * scale, cameraModel.photoData.height * scale, true);
			smallBMD.drawWithQuality(cameraModel.photoData, matrix, null, null, null, true, StageQuality.HIGH);
			imageBitmap = new Bitmap(smallBMD, "auto", true);
			
			removeDrawnVector( image );
			
			image = Image.fromBitmap(imageBitmap, true, Starling.contentScaleFactor);
			image.x = (layoutModel.appWidth * 0.5) - (image.width * 0.5);
			image.y = layoutModel.navBarHeight + (((layoutModel.appHeight - layoutModel.navBarHeight - vectorPage.actionBar.height) * 0.5) - (image.height * 0.5));
			
			addChild( image );
			addChild( target );
			addChild( _actionBar );
			addChild( acceptButton );
			addChild( cancelButton );
		}
		
		public function drawScaledImage():BitmapData
		{
			//trace(imageBitmap.width, imageBitmap.height, imageBitmap.transform.matrix.a, imageBitmap.transform.matrix.d);
			
			var bitmapData:BitmapData = new BitmapData(image.width, image.height, true, 0);
			bitmapData.drawWithQuality(imageBitmap, image.transformationMatrix); //imageBitmap.transform.matrix); 
			
			//trace(bitmapData.width, bitmapData.height, image.transformationMatrix.a, image.transformationMatrix.d);
			
			return bitmapData;
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			trace("area select page reflowing vectors");
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			trace("area select page resized");
			
			vectorPage.actionBar.gotoAndStop(1);
			vectorPage.actionBar.height = (114 * layoutModel.scale) * Starling.contentScaleFactor;
			vectorPage.actionBar.width = (layoutModel.appWidth + 4) * Starling.contentScaleFactor;
			vectorPage.actionBar.x = -2;
			vectorPage.actionBar.y = layoutModel.appHeight - (114 * layoutModel.scale);
			
			vectorPage.cancelButton.height = vectorPage.actionBar.height * 0.70;
			vectorPage.cancelButton.scaleX = vectorPage.cancelButton.scaleY;
			vectorPage.cancelButton.x = (layoutModel.appWidth * 0.20) - (vectorPage.cancelButton.width * 0.5);
			vectorPage.cancelButton.y = vectorPage.actionBar.y + ((vectorPage.actionBar.height - vectorPage.cancelButton.height) * 0.5);
			
			vectorPage.acceptButton.height = vectorPage.actionBar.height * 0.70;
			vectorPage.acceptButton.scaleX = vectorPage.acceptButton.scaleY;
			vectorPage.acceptButton.x = (layoutModel.appWidth * 0.80) - (vectorPage.acceptButton.width * 0.5);
			vectorPage.acceptButton.y = vectorPage.actionBar.y + ((vectorPage.actionBar.height - vectorPage.acceptButton.height) * 0.5);
			
			vectorPage.target.width = (layoutModel.appHeight - layoutModel.navBarHeight) * 0.21;
			vectorPage.target.scaleY = vectorPage.target.scaleX;
			vectorPage.target.x = (layoutModel.appWidth * 0.5) - (vectorPage.target.width * 0.5);
			vectorPage.target.y = layoutModel.navBarHeight + (((layoutModel.appHeight - layoutModel.navBarHeight - vectorPage.actionBar.height) * 0.5) - (vectorPage.target.height * 0.5));	
		}
		
		override public function drawVectors(layoutModel:LayoutModel = null, cameraModel:CameraModel = null):void
		{
			trace("area select page drawing vectors");
			
			//Remove first
			removeDrawnVector( _background );
			removeDrawnVector( target );
			removeDrawnVector( _actionBar );
			removeDrawnVector( acceptButton );
			removeDrawnVector( cancelButton );
			
			_background = drawBackgroundQuad();
			backButton = new feathers.controls.Button();
			target = createImageFromDisplayObject( vectorPage.target );
			_actionBar = createImageFromDisplayObject(vectorPage.actionBar);
			acceptButton = createButtonFromMovieClip(vectorPage.acceptButton);
			cancelButton = createButtonFromMovieClip(vectorPage.cancelButton);
			
			//Now add
			addChildAt( _background, 0 );
			addChild( target );
			addChild( _actionBar );
			addChild( acceptButton );
			addChild( cancelButton );
			
			//Settings
			backButton.label = "Cancel";
			target.touchable = false;
		}
	}
}