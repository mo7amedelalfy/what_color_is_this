package com.nicotroia.whatcoloristhis.view.pages
{
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
	import feathers.layout.VerticalLayout;
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
		
		private var _thisThingImage:Image;
		private var _thisThingTextFormat:TextFormat;
		private var _winnerHexImage:Image;
		private var _winnerHexTextFormat:TextFormat;
		private var _resultList:List;
		private var _listCollection:ListCollection;
		private var _targetCopy:Image;
		
		public function ResultPage()
		{
			vectorPage = new ResultPageVector();
			
			super();
		}
		
		public function setTextFormat(layoutModel:LayoutModel):void
		{
			_thisThingTextFormat = new TextFormat(layoutModel.infoDispBold.fontName, (42 * layoutModel.scale), 0xffffff);
			_winnerHexTextFormat = new TextFormat(layoutModel.infoDispBold.fontName, (58 * layoutModel.scale), 0xffffff);
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
			vectorPage.thisThingTF.height = (50 * layoutModel.scale) * Starling.contentScaleFactor;
			
			vectorPage.colorNameTF.width = layoutModel.appWidth;
			vectorPage.colorNameTF.height = (50 * layoutModel.scale) * Starling.contentScaleFactor;
			
			//vectorPage.closestMatchHexTF.width = layoutModel.appWidth;
			//vectorPage.closestMatchHexTF.x = 0;
			//vectorPage.closestMatchHexTF.y = vectorPage.colorNameTF.y + vectorPage.colorNameTF.textHeight + 14;
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
			_resultList.y = layoutModel.appHeight * 0.5;
			_resultList.width = layoutModel.appWidth;
			_resultList.height = layoutModel.appHeight - _resultList.y; // * 0.5;
			
			_listCollection = new ListCollection();
			
			_resultList.dataProvider = _listCollection;
			_resultList.isSelectable = false;
			
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.gap = 1;
			_resultList.layout = verticalLayout;
			
			_resultList.scrollerProperties.hasElasticEdges = true;
			
			_resultList.itemRendererProperties.labelField = "colorType";
			
			_resultList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:ResultListItemRenderer = new ResultListItemRenderer();
				
				renderer.stateToSkinFunction = function(target:Button, state:Object, oldSkin:DisplayObject = null):DisplayObject { 
					var quad:Quad = new Quad(target.width, target.height);
					
					//render different state colors if it becomes selectable...
					quad.color = 0xe0e0e0;
						
					return quad;
				};
				
				renderer.defaultLabelProperties.textFormat = new TextFormat(layoutModel.infoDispBold.fontName, 30 * layoutModel.scale, 0x2b2b2b);
				
				renderer.titleFunction = function( item:Object ):String { 
					return item.colorName;
				};
				
				renderer.descriptionFunction = function( item:Object ):String { 
					return "Type: " + item.colorType +"\n"+ "Hex: " + item.closestMatchHex;
				};
				
				renderer.iconFunction = function( item:Object ):DisplayObject { 
					return new Quad((200 * layoutModel.scale) * Starling.contentScaleFactor, (200 * layoutModel.scale) * Starling.contentScaleFactor, uint("0x"+item.closestMatchHex));
				};
				
				return renderer;
			};
			
			_resultList.itemRendererProperties.paddingTop =
				_resultList.itemRendererProperties.paddingRight =
				_resultList.itemRendererProperties.paddingBottom =
				_resultList.itemRendererProperties.paddingLeft = 10;
			_resultList.itemRendererProperties.gap = 10;
		}
		
		public function drawResults(layoutModel:LayoutModel, cameraModel:CameraModel):void
		{
			var padding:Number = (24 * layoutModel.scale);
			
			trace("draw winning color 0x" + cameraModel.chosenWinnerHex);
			
			removeDrawnVector( _background );
			removeDrawnVector( _targetCopy );
			removeDrawnVector( _thisThingImage );
			removeDrawnVector( _winnerHexImage );
			
			_background = drawBackgroundQuad(uint("0x"+cameraModel.chosenWinnerHex));
			
			//TargetCopy
			var bitmap:Bitmap = new Bitmap(cameraModel.targetedPixels, "auto", true);
			bitmap.width = layoutModel.appWidth * 0.25;
			bitmap.scaleY = bitmap.scaleX;
			
			_targetCopy = createImageFromDisplayObject( bitmap );
			_targetCopy.x = (layoutModel.appWidth * 0.5) - (_targetCopy.width * 0.5);
			_targetCopy.y = (layoutModel.navBarHeight/Starling.contentScaleFactor) + padding;
			
			
			//add text to TFs
			var fontColor:uint = ((uint("0x" + cameraModel.chosenWinnerHex) >= 0x808080) ? 0x2b2b2b : 0xffffff);
			
			vectorPage.thisThingTF.text = getRandomComment();
			vectorPage.colorNameTF.text = "0x" + cameraModel.chosenWinnerHex;
			_thisThingTextFormat.color = fontColor;
			_thisThingTextFormat.align = TextFormatAlign.CENTER;
			vectorPage.thisThingTF.setTextFormat(_thisThingTextFormat);
			_winnerHexTextFormat.color = fontColor;
			_winnerHexTextFormat.align = TextFormatAlign.CENTER;
			vectorPage.colorNameTF.setTextFormat(_winnerHexTextFormat);
			
			//Position
			vectorPage.thisThingTF.x = 0;
			vectorPage.thisThingTF.y = _targetCopy.y + _targetCopy.height + padding;
			vectorPage.colorNameTF.x = 0;
			vectorPage.colorNameTF.y = vectorPage.thisThingTF.y + vectorPage.thisThingTF.textHeight + padding;
			
			_resultList.y = vectorPage.colorNameTF.y + vectorPage.colorNameTF.textHeight + padding;
			_resultList.height = layoutModel.appHeight - _resultList.y;
			_resultList.validate();
			
			//trace("targetCopy.y: " + _targetCopy.y + ", thisThingTF.y: " + vectorPage.thisThingTF.y + ", colorNameTF.y: " + vectorPage.colorNameTF.y + ", resultList.y: " + _resultList.y);
			
			//Text images
			_thisThingImage = createImageFromDisplayObject( vectorPage.thisThingTF );
			_winnerHexImage = createImageFromDisplayObject( vectorPage.colorNameTF );
			
			//Add
			addChildAt(_background, 0);
			addChild(_thisThingImage);
			addChild(_winnerHexImage);
			addChild(_targetCopy);
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