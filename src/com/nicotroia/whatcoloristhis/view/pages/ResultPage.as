package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageOrientation;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class ResultPage extends PageBase
	{
		public var doneButton:feathers.controls.Button;
		//public var thisThingTF:TextField;
		//public var colorNameTF:TextField;
		//public var closestMatchHexTF:TextField;
		
		private var _targetCopy:Image;
		private var _winningColorShape:Quad;
		private var _thisThingTF:Image;
		private var _colorNameTF:Image;
		private var _closestMatchHexTF:Image;
		
		public function ResultPage()
		{
			vectorPage = new ResultPageVector();
			
			super();
		}
		
		public function reset():void
		{
			removeDrawnVector( _thisThingTF );
			removeDrawnVector( _colorNameTF );
			removeDrawnVector( _closestMatchHexTF );
			removeDrawnVector( _winningColorShape );
			removeDrawnVector( _targetCopy );
		}
		
		public function drawWinningColor(layoutModel:LayoutModel, cameraModel:CameraModel):void
		{
			trace("draw winning color 0x" + cameraModel.chosenWinnerHex);
			
			removeDrawnVector( _winningColorShape );
			removeDrawnVector( _targetCopy );
			
			_winningColorShape = new Quad(layoutModel.appWidth, layoutModel.appHeight, uint("0x" + cameraModel.closestMatchHex)); //winnerHex));
			
			var bitmap:Bitmap = new Bitmap(cameraModel.targetedPixels, "auto", true);
			bitmap.width = layoutModel.appWidth * 0.25;
			bitmap.scaleY = bitmap.scaleX;
			
			_targetCopy = createImageFromDisplayObject( bitmap );
			
			addChildAt(_winningColorShape, 0);
			addChild(_targetCopy);
			
			_targetCopy.x = 14;
			_targetCopy.y = layoutModel.appHeight - _targetCopy.height - 14;
		}
		
		public function drawResultTexts():void
		{
			removeDrawnVector( _thisThingTF );
			removeDrawnVector( _colorNameTF );
			removeDrawnVector( _closestMatchHexTF );
			
			_thisThingTF = createImageFromDisplayObject( vectorPage.thisThingTF );
			_colorNameTF = createImageFromDisplayObject( vectorPage.colorNameTF );
			_closestMatchHexTF = createImageFromDisplayObject( vectorPage.closestMatchHexTF );
			
			addChild(_thisThingTF);
			addChild(_colorNameTF);
			addChild(_closestMatchHexTF);
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			trace("result page reflowing vectors");
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			///*
			vectorPage.thisThingTF.width = layoutModel.appWidth;
			vectorPage.thisThingTF.x = 0;
			vectorPage.thisThingTF.y = layoutModel.appHeight * 0.3;
			
			vectorPage.colorNameTF.width = layoutModel.appWidth;
			vectorPage.colorNameTF.x = 0;
			vectorPage.colorNameTF.y = vectorPage.thisThingTF.y + vectorPage.thisThingTF.textHeight + 24;
			vectorPage.colorNameTF.autoSize = TextFieldAutoSize.CENTER;
			
			vectorPage.closestMatchHexTF.width = layoutModel.appWidth;
			vectorPage.closestMatchHexTF.x = 0;
			vectorPage.closestMatchHexTF.y = vectorPage.colorNameTF.y + vectorPage.colorNameTF.textHeight + 14;
			//*/
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void
		{
			trace("result page drawing vectors");
			
			//Remove first
			removeDrawnVector( doneButton );
			
			//Create
			doneButton = new feathers.controls.Button();
			
			//Now add
			//addChild(_header);
			
			//Settings
			doneButton.label = "Done";
		}
	}
}