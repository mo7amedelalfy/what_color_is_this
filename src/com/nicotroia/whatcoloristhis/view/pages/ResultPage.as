package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.controller.utils.ColorHelper;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.ColorModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SettingsModel;
	import com.nicotroia.whatcoloristhis.view.feathers.ResultListItemRenderer;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
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
		public var suggestButton:Button;
		public var favoriteButton:Button;
		
		private var _pageContainer:ScrollContainer;
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
		private var _invisPaddingBottom:Quad;
		
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
			removeDrawnVector( _targetCopy );
			removeDrawnVector( _colorSwatch );
			removeDrawnVector( _thisThingTFImage );
			removeDrawnVector( _colorNameTFImage );
			removeDrawnVector( _colorInfoTFImage );
			removeDrawnVector( _extraResultsTitleImage );
			
			//_pageContainer = new ScrollContainer();
			
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
			removeDrawnVector( _background );
			removeDrawnVector( backButton );
			removeDrawnVector( doneButton );
			removeDrawnVector( suggestButton );
			removeDrawnVector( favoriteButton );
			removeDrawnVector( _resultList );
			removeDrawnVector( _pageContainer );
			removeDrawnVector( _invisPaddingBottom );
			
			
			//Create
			
			_background = drawBackgroundQuad();
			backButton = new Button();
			doneButton = new Button();
			suggestButton = new Button();
			favoriteButton = new Button();
			_resultList = new List();
			_pageContainer = new ScrollContainer();
			_invisPaddingBottom = new Quad(100, 100, 0xf5f5f5);
			
			//Add
			addChildAt(_background, 0);
			addChild( _pageContainer );
			
			_pageContainer.addChild(_invisPaddingBottom);
			_pageContainer.addChild(_resultList);
			_pageContainer.addChild(suggestButton);
			_pageContainer.addChild(favoriteButton);
			
			
			//Settings
			backButton.label = "Back";
			doneButton.label = "Done";
			suggestButton.label = "Suggest a Name";
			favoriteButton.label = "Add to Favorites";
			//doesn't work?
			//suggestButton.defaultLabelProperties.textFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
			//suggestButton.defaultLabelProperties.textFormat.align = TextFormatAlign.CENTER;
			
			
			//Page Container
			_pageContainer.x = 0;
			_pageContainer.y = (layoutModel.navBarHeight/Starling.contentScaleFactor);
			_pageContainer.width = layoutModel.appWidth;
			_pageContainer.height = layoutModel.appHeight - _pageContainer.y;
			
			_pageContainer.scrollerProperties.clipContent = true;
			_pageContainer.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			_pageContainer.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			_pageContainer.scrollerProperties.hasElasticEdges = true;
			
			//How to add a layout (for padding) that does not position its children?
			//We are using an _invisPaddingBottom Quad to push the page down. Sad, yes.
			//var layout:VerticalLayout = new VerticalLayout();
			//layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			//layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			//layout.paddingBottom = 100;
			//_pageContainer.layout = layout;
			
			
			//Result List
			_resultList.x = 0;
			_resultList.width = layoutModel.appWidth;
			
			_listCollection = new ListCollection();
			
			_resultList.dataProvider = _listCollection;
			
			_resultList.scrollerProperties.clipContent = false;
			_resultList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			//_resultList.scrollerProperties.hasElasticEdges = true;
			
			var resultListLayout:VerticalLayout = new VerticalLayout();
			resultListLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			resultListLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			//resultListLayout.typicalItemHeight = 188*layoutModel.scale*Starling.contentScaleFactor;
			_resultList.layout = resultListLayout;
			
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
		
		public function drawResults(layoutModel:LayoutModel, cameraModel:CameraModel, settingsModel:SettingsModel):void
		{
			trace("draw results");
			
			setTextFormat(layoutModel);
			
			var padding:Number = 24 * layoutModel.scale;
			
			trace("draw winning color 0x" + cameraModel.chosenWinnerHex);
			
			removeDrawnVector( _targetCopy );
			removeDrawnVector( _colorSwatch );
			removeDrawnVector( _thisThingTFImage );
			removeDrawnVector( _colorNameTFImage );
			removeDrawnVector( _colorInfoTFImage );
			removeDrawnVector( _extraResultsTitleImage );
			
			
			
			//TargetCopy
			var swatchSize:Number = layoutModel.appWidth * 0.2;
			
			if( cameraModel.targetedPixels ) { 
				var bitmap:Bitmap = new Bitmap(cameraModel.targetedPixels, "auto", true);
				bitmap.width = swatchSize;
				bitmap.scaleY = bitmap.scaleX;
				_targetCopy = createImageFromDisplayObject( bitmap );
			}
			
			_colorSwatch = new Quad(swatchSize, swatchSize, uint("0x"+cameraModel.chosenWinnerHex));
			
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
			vectorPage.thisThingTF.y = (padding * 0.5);
			
			vectorPage.colorNameTF.x = 0;
			vectorPage.colorNameTF.y = vectorPage.thisThingTF.y + vectorPage.thisThingTF.textHeight + (padding * 0.5);
			
			vectorPage.colorInfoTF.x = 0;
			vectorPage.colorInfoTF.y = vectorPage.colorNameTF.y + vectorPage.colorNameTF.textHeight + (padding * 0.5);
			
			if( cameraModel.targetedPixels ) { 
				_colorSwatch.x = (layoutModel.appWidth * 0.5) - swatchSize - 7;
				_colorSwatch.y = vectorPage.colorInfoTF.y + vectorPage.colorInfoTF.textHeight + padding;
				
				_targetCopy.x = (layoutModel.appWidth * 0.5) + 7;
				_targetCopy.y = _colorSwatch.y - 2; 
			}
			else { 
				_colorSwatch.x = (layoutModel.appWidth * 0.5) - (swatchSize * 0.5);
				_colorSwatch.y = vectorPage.colorInfoTF.y + vectorPage.colorInfoTF.textHeight + padding;
				
			}
			
			vectorPage.extraResultsTitle.x = 0;
			vectorPage.extraResultsTitle.y = _colorSwatch.y + swatchSize + padding + (padding * 0.5);
			
			vectorPage.extraResultsTitle.bar.x = -2;
			vectorPage.extraResultsTitle.bar.y = 0;
			
			vectorPage.extraResultsTitle.labelTF.x = 0;
			vectorPage.extraResultsTitle.labelTF.y = (10 * layoutModel.scale) * Starling.contentScaleFactor;
			
			_resultList.y = vectorPage.extraResultsTitle.y + vectorPage.extraResultsTitle.bar.height;
			//_resultList.height = layoutModel.appHeight - _resultList.y;
			//_resultList.validate();
			
			//trace("targetCopy.y: " + _targetCopy.y + ", thisThingTF.y: " + vectorPage.thisThingTF.y + ", colorNameTF.y: " + vectorPage.colorNameTF.y + ", resultList.y: " + _resultList.y);
			
			//Text images
			_thisThingTFImage = createImageFromDisplayObject( vectorPage.thisThingTF );
			_colorNameTFImage = createImageFromDisplayObject( vectorPage.colorNameTF );
			_colorInfoTFImage = createImageFromDisplayObject( vectorPage.colorInfoTF );
			_extraResultsTitleImage = createImageFromDisplayObject( vectorPage.extraResultsTitle );
			if( settingsModel.howManyResultsAreThere() == 0 ) _extraResultsTitleImage.visible = false;
			
			
			positionBottom(layoutModel, settingsModel);
			
			
			_pageContainer.verticalScrollPosition = 0;
			
			
			//Add
			_pageContainer.addChild( _thisThingTFImage );
			_pageContainer.addChild( _colorNameTFImage );
			_pageContainer.addChild( _colorInfoTFImage );
			if( cameraModel.targetedPixels ) _pageContainer.addChild( _targetCopy );
			_pageContainer.addChild( _colorSwatch );
			_pageContainer.addChild( _extraResultsTitleImage );
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
			removeDrawnVector( _pageContainer );
			
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
			//vectorPage.thisThingTF.setTextFormat(_thisThingTextFormat);
			
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
			
			
			favoriteButton.x = 28 * layoutModel.scale;
			favoriteButton.y = _targetCopy.y + swatchSize + (28 * layoutModel.scale);
			
			//trace("targetCopy.y: " + _targetCopy.y + ", thisThingTF.y: " + vectorPage.thisThingTF.y + ", colorNameTF.y: " + vectorPage.colorNameTF.y + ", resultList.y: " + _resultList.y);
			
			//Text images
			_thisThingTFImage = createImageFromDisplayObject( vectorPage.thisThingTF );
			_colorNameTFImage = createImageFromDisplayObject( vectorPage.colorNameTF );
			_colorInfoTFImage = createImageFromDisplayObject( vectorPage.colorInfoTF );
			
			
			_pageContainer.verticalScrollPosition = 0;
			
			_pageContainer.addChild(_thisThingTFImage);
			_pageContainer.addChild(_colorNameTFImage);
			_pageContainer.addChild(_colorInfoTFImage);
			_pageContainer.addChild(_targetCopy);
			_pageContainer.addChild(_colorSwatch);
			addChildAt(_background, 0);
		}
		
		public function addResultToList($colorType:String, $colorName:String, $closestMatchHex:String):void
		{
			_listCollection.push({colorType:$colorType, colorName:$colorName, closestMatchHex:$closestMatchHex});
			_resultList.dataProvider = _listCollection;
			_resultList.validate();
		}
		
		public function positionBottom(layoutModel:LayoutModel, settingsModel:SettingsModel):void
		{
			var padding:Number = 24 * layoutModel.scale;
			
			//why do we need to manually invalidate the list???
			_resultList.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
			_resultList.validate();
			//trace("result list height: " + _resultList.height);
			var bottomStartY:Number = (_resultList.height/Starling.contentScaleFactor) + (28 * layoutModel.scale);
			//var bottomStartY:Number = (188 * settingsModel.howManyResultsAreThere() * layoutModel.scale * Starling.contentScaleFactor) + padding;
			
			favoriteButton.x = 28 * layoutModel.scale;
			favoriteButton.y = _resultList.y + bottomStartY;
			
			suggestButton.x = 28 * layoutModel.scale;
			suggestButton.y = favoriteButton.y + favoriteButton.height + (28 * layoutModel.scale);
			
			_invisPaddingBottom.x = 0;
			_invisPaddingBottom.y = suggestButton.y + suggestButton.height + padding;
			
			_pageContainer.addChildAt( _invisPaddingBottom, 0 );
			
			/*
			favoriteButton.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
			suggestButton.invalidate(FeathersControl.INVALIDATION_FLAG_LAYOUT);
			favoriteButton.validate();
			suggestButton.validate();
			*/
			
			addChildAt(_background, 0);
		}
		
		public function changeNameToSuggestion(colorModel:ColorModel):void
		{
			if( ! colorModel.suggestedName ) return;
			
			vectorPage.colorNameTF.text = colorModel.suggestedName;
			vectorPage.colorNameTF.setTextFormat(_colorNameTextFormat);
			
			hideSuggestButton();
			
			removeDrawnVector( _colorNameTFImage );
			_colorNameTFImage = createImageFromDisplayObject( vectorPage.colorNameTF );
			_pageContainer.addChild( _colorNameTFImage );
			
			//done.
			colorModel.resetSuggestion();
		}
		
		public function hideSuggestButton():void
		{
			if( suggestButton ) { 
				suggestButton.isEnabled = false;
				suggestButton.visible = false;
			}
		}
		
		public function showSuggestButton():void
		{
			if( suggestButton ) { 
				suggestButton.isEnabled = true;
				suggestButton.visible = true;
			}
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