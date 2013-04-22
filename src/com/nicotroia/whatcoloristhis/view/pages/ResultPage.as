package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.controller.utils.ColorHelper;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.view.feathers.ResultListItemRenderer;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageOrientation;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	
	public class ResultPage extends PageBase
	{
		public var backButton:Button;
		public var doneButton:Button;
		
		private var _thisThingTFImage:Image;
		private var _thisThingTextFormat:TextFormat;
		private var _colorNameTFImage:Image;
		private var _colorNameTextFormat:TextFormat;
		private var _colorInfoTFImage:Image;
		private var _colorInfoTextFormat:TextFormat;
		private var _extraResultsTitleImage:Image;
		private var _extraResultsTextFormat:TextFormat;
		private var _resultList:List;
		private var _listCollection:ListCollection;
		private var _colorSwatch:Quad;
		private var _targetCopy:Image;
		
		public function ResultPage()
		{
			vectorPage = new ResultPageVector();
			
			_thisThingTextFormat = new TextFormat();
			_colorNameTextFormat = new TextFormat();
			_colorInfoTextFormat = new TextFormat();
			_extraResultsTextFormat = new TextFormat();
			
			super();
		}
		
		public function setTextFormat(layoutModel:LayoutModel):void
		{
			_thisThingTextFormat.font = layoutModel.infoDispMedium.fontName;
			_thisThingTextFormat.size = (42 * layoutModel.scale);
			
			_colorNameTextFormat.font = layoutModel.infoDispBold.fontName;
			_colorNameTextFormat.size = (58 * layoutModel.scale);
			
			_colorInfoTextFormat.size = (34 * layoutModel.scale);
			
			_extraResultsTextFormat.font = layoutModel.infoDispMedium.fontName;
			_extraResultsTextFormat.size = (34 * layoutModel.scale);
		}
		
		public function reset():void
		{
			removeDrawnVector( _background );
			removeDrawnVector( _targetCopy );
			_listCollection = new ListCollection();
			if( _resultList ) { 
				_resultList.dataProvider = _listCollection;
				_resultList.validate();
			}
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			trace("result page reflowing vectors");
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			vectorPage.thisThingTF.width = layoutModel.appWidth;
			vectorPage.thisThingTF.height = 40 * layoutModel.scale * Starling.contentScaleFactor;
			
			vectorPage.colorNameTF.width = layoutModel.appWidth;
			vectorPage.colorNameTF.height = 55 * layoutModel.scale * Starling.contentScaleFactor;
			
			vectorPage.colorInfoTF.width = layoutModel.appWidth;
			vectorPage.colorInfoTF.height = 40 * layoutModel.scale * Starling.contentScaleFactor;
			
			vectorPage.extraResultsTitle.bar.width = layoutModel.appWidth + 4;
			vectorPage.extraResultsTitle.bar.height = 50 * layoutModel.scale * Starling.contentScaleFactor;
			
			vectorPage.extraResultsTitle.labelTF.width = layoutModel.appWidth;
			vectorPage.extraResultsTitle.labelTF.height = 50 * layoutModel.scale * Starling.contentScaleFactor;
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void
		{
			trace("result page drawing vectors");
			
			//Remove 
			removeDrawnVector( backButton );
			removeDrawnVector( doneButton );
			removeDrawnVector( _resultList );
			
			
			//Create
			
			backButton = new Button();
			doneButton = new Button();
			_resultList = new List();
			
			
			//Add
			addChild(_resultList);
			
			
			//Settings
			backButton.label = "Back";
			doneButton.label = "Done";
			
			
			//Result List
			_resultList.x = 0;
			_resultList.width = layoutModel.appWidth;
			
			_listCollection = new ListCollection();
			
			_resultList.dataProvider = _listCollection;
			
			_resultList.scrollerProperties.hasElasticEdges = true;
			
			_resultList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:ResultListItemRenderer = new ResultListItemRenderer();
				
				renderer.iconFunction = function( item:Object ):DisplayObject { 
					return new Quad((140 * layoutModel.scale) * Starling.contentScaleFactor, (140 * layoutModel.scale) * Starling.contentScaleFactor, uint("0x"+item.closestMatchHex));
				};
				
				renderer.titleFunction = function( item:Object ):String { 
					return item.colorName;
				};
				
				renderer.descriptionFunction = function( item:Object ):String { 
					return "Hex: 0x" + item.closestMatchHex + "\nSource: " + item.colorType;
				};
				
				renderer.isEnabled = false;
				
				return renderer;
			};
			
			_resultList.itemRendererProperties.paddingTop = _resultList.itemRendererProperties.paddingBottom = 12 * Assets.roundedScaleFactor;
			_resultList.itemRendererProperties.paddingRight = _resultList.itemRendererProperties.paddingLeft = 12 * Assets.roundedScaleFactor;
			_resultList.itemRendererProperties.gap = 14 * Assets.roundedScaleFactor;
			
			_resultList.isSelectable = false;
		}
		
		public function drawResults(layoutModel:LayoutModel, cameraModel:CameraModel):void
		{
			setTextFormat(layoutModel);
			
			var padding:Number = (24 * layoutModel.scale);
			
			trace("draw winning color 0x" + cameraModel.chosenWinnerHex);
			
			removeDrawnVector( _background );
			removeDrawnVector( _targetCopy );
			removeDrawnVector( _colorSwatch );
			removeDrawnVector( _thisThingTFImage );
			removeDrawnVector( _colorNameTFImage );
			removeDrawnVector( _colorInfoTFImage );
			removeDrawnVector( _extraResultsTitleImage );
			
			_background = drawBackgroundQuad();
			
			//TargetCopy
			var swatchSize:Number = layoutModel.appWidth * 0.2;
			var bitmap:Bitmap = new Bitmap(cameraModel.targetedPixels, "auto", true);
			bitmap.width = swatchSize;
			bitmap.scaleY = bitmap.scaleX;
			
			_targetCopy = createImageFromDisplayObject( bitmap );
			
			_colorSwatch = new Quad(bitmap.width, bitmap.height, uint("0x"+cameraModel.chosenWinnerHex));
			
			//add text to TFs
			var fontColor:uint = 0x333333; 
			
			vectorPage.thisThingTF.text = getRandomComment();
			_thisThingTextFormat.color = fontColor;
			_thisThingTextFormat.align = TextFormatAlign.CENTER;
			vectorPage.thisThingTF.setTextFormat(_thisThingTextFormat);
			
			_colorNameTextFormat.color = fontColor;
			_colorNameTextFormat.align = TextFormatAlign.CENTER;
			vectorPage.colorNameTF.setTextFormat(_colorNameTextFormat);
			
			var rgb:Object = ColorHelper.getRGB(uint("0x"+cameraModel.chosenWinnerHex));
			vectorPage.colorInfoTF.text = "Hex: 0x" + cameraModel.chosenWinnerHex + ", R: "+rgb.r +", G: "+ rgb.g +", B: "+ rgb.b;
			_colorInfoTextFormat.color = fontColor;
			_colorInfoTextFormat.align = TextFormatAlign.CENTER;
			vectorPage.colorInfoTF.setTextFormat(_colorInfoTextFormat);
			
			vectorPage.extraResultsTitle.labelTF.text = "Similar Results";
			vectorPage.extraResultsTitle.labelTF.setTextFormat(_extraResultsTextFormat);
			
			//Position
			vectorPage.thisThingTF.x = 0;
			vectorPage.thisThingTF.y = (layoutModel.navBarHeight/Starling.contentScaleFactor) + (padding * 0.5);
			
			vectorPage.colorNameTF.x = 0;
			vectorPage.colorNameTF.y = vectorPage.thisThingTF.y + vectorPage.thisThingTF.textHeight + (padding * 0.5);
			
			vectorPage.colorInfoTF.x = 0;
			vectorPage.colorInfoTF.y = vectorPage.colorNameTF.y + vectorPage.colorNameTF.textHeight + (padding * 0.5);
			
			_colorSwatch.x = (layoutModel.appWidth * 0.5) - swatchSize - 7;
			_colorSwatch.y = vectorPage.colorInfoTF.y + vectorPage.colorInfoTF.textHeight + padding;
			
			_targetCopy.x = (layoutModel.appWidth * 0.5) + 7;
			_targetCopy.y = _colorSwatch.y - 2; 
			
			vectorPage.extraResultsTitle.x = 0;
			vectorPage.extraResultsTitle.y = _targetCopy.y + swatchSize + padding + (padding * 0.5);
			
			vectorPage.extraResultsTitle.bar.x = -2;
			vectorPage.extraResultsTitle.bar.y = 0;
			
			vectorPage.extraResultsTitle.labelTF.x = 0;
			vectorPage.extraResultsTitle.labelTF.y = (10 * layoutModel.scale) * Starling.contentScaleFactor;
			
			_resultList.y = vectorPage.extraResultsTitle.y + vectorPage.extraResultsTitle.bar.height;
			_resultList.height = layoutModel.appHeight - _resultList.y;
			_resultList.validate();
			
			//trace("targetCopy.y: " + _targetCopy.y + ", thisThingTF.y: " + vectorPage.thisThingTF.y + ", colorNameTF.y: " + vectorPage.colorNameTF.y + ", resultList.y: " + _resultList.y);
			
			//Text images
			_thisThingTFImage = createImageFromDisplayObject( vectorPage.thisThingTF );
			_colorNameTFImage = createImageFromDisplayObject( vectorPage.colorNameTF );
			_colorInfoTFImage = createImageFromDisplayObject( vectorPage.colorInfoTF );
			_extraResultsTitleImage = createImageFromDisplayObject( vectorPage.extraResultsTitle );
			
			
			//Add
			addChildAt(_background, 0);
			addChild(_thisThingTFImage);
			addChild(_colorNameTFImage);
			addChild(_colorInfoTFImage);
			addChild(_targetCopy);
			addChild(_colorSwatch);
			addChild(_extraResultsTitleImage);
		}
		
		public function drawOnlyTheColorDetails(layoutModel:LayoutModel, cameraModel:CameraModel):void
		{
			trace("drawing only the color details because there is no internet connection :(");
			
			removeDrawnVector( _background );
			removeDrawnVector( _targetCopy );
			removeDrawnVector( _colorSwatch );
			removeDrawnVector( _thisThingTFImage );
			removeDrawnVector( _colorNameTFImage );
			removeDrawnVector( _colorInfoTFImage );
			
			
			_background = drawBackgroundQuad();
			
			//TargetCopy
			var swatchSize:Number = layoutModel.appWidth * 0.2;
			var bitmap:Bitmap = new Bitmap(cameraModel.targetedPixels, "auto", true);
			bitmap.width = swatchSize;
			bitmap.scaleY = bitmap.scaleX;
			
			_targetCopy = createImageFromDisplayObject( bitmap );
			
			_colorSwatch = new Quad(bitmap.width, bitmap.height, uint("0x"+cameraModel.chosenWinnerHex));
			
			
			//add text to TFs
			var fontColor:uint = 0x333333; 
			var padding:Number = (24 * layoutModel.scale);
			
			vectorPage.thisThingTF.text = getRandomComment();
			_thisThingTextFormat.color = fontColor;
			_thisThingTextFormat.align = TextFormatAlign.CENTER;
			vectorPage.thisThingTF.setTextFormat(_thisThingTextFormat);
			
			vectorPage.colorNameTF.text = "0x" + cameraModel.chosenWinnerHex;
			_colorNameTextFormat.color = fontColor;
			_colorNameTextFormat.align = TextFormatAlign.CENTER;
			vectorPage.colorNameTF.setTextFormat(_colorNameTextFormat);
			
			var rgb:Object = ColorHelper.getRGB(uint("0x"+cameraModel.chosenWinnerHex));
			vectorPage.colorInfoTF.text = "R: "+rgb.r +", G: "+ rgb.g +", B: "+ rgb.b;
			_colorInfoTextFormat.color = fontColor;
			_colorInfoTextFormat.align = TextFormatAlign.CENTER;
			vectorPage.colorInfoTF.setTextFormat(_colorInfoTextFormat);
			
			
			//Position
			vectorPage.thisThingTF.x = 0;
			vectorPage.thisThingTF.y = (layoutModel.navBarHeight/Starling.contentScaleFactor) + (padding * 0.5);
			
			vectorPage.colorNameTF.x = 0;
			vectorPage.colorNameTF.y = vectorPage.thisThingTF.y + vectorPage.thisThingTF.textHeight + (padding * 0.5);
			
			vectorPage.colorInfoTF.x = 0;
			vectorPage.colorInfoTF.y = vectorPage.colorNameTF.y + vectorPage.colorNameTF.textHeight + (padding * 0.5);
			
			_colorSwatch.x = (layoutModel.appWidth * 0.5) - swatchSize - 7;
			_colorSwatch.y = vectorPage.colorInfoTF.y + vectorPage.colorInfoTF.textHeight + padding;
			
			_targetCopy.x = (layoutModel.appWidth * 0.5) + 7;
			_targetCopy.y = _colorSwatch.y - 2; 
			
			//trace("targetCopy.y: " + _targetCopy.y + ", thisThingTF.y: " + vectorPage.thisThingTF.y + ", colorNameTF.y: " + vectorPage.colorNameTF.y + ", resultList.y: " + _resultList.y);
			
			//Text images
			_thisThingTFImage = createImageFromDisplayObject( vectorPage.thisThingTF );
			_colorNameTFImage = createImageFromDisplayObject( vectorPage.colorNameTF );
			_colorInfoTFImage = createImageFromDisplayObject( vectorPage.colorInfoTF );
			
			
			addChildAt(_background, 0);
			addChild(_thisThingTFImage);
			addChild(_colorNameTFImage);
			addChild(_colorInfoTFImage);
			addChild(_targetCopy);
			addChild(_colorSwatch);
		}
		
		public function addResultToList($colorType:String, $colorName:String, $closestMatchHex:String):void
		{
			_listCollection.push({colorType:$colorType, colorName:$colorName, closestMatchHex:$closestMatchHex});
			_resultList.dataProvider = _listCollection;
		}
		
		private function getRandomComment():String
		{
			var arr:Vector.<String> = new <String>[
				"That's",
				"That is",
				"That thing's",
				"That thing is",
				"This is", 
				"This thing is", 
				"This is definitely",
				"Haha, this is",
				"Lol, that's"
			];
			
			return arr[uint(Math.random() * arr.length)];
		}
	}
}