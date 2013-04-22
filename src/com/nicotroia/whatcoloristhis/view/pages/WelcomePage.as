package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.display.Scale9Image;
	import feathers.layout.LayoutBoundsResult;
	import feathers.textures.Scale9Textures;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.StageOrientation;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class WelcomePage extends PageBase
	{
		public var settingsButton:starling.display.Button;
		public var aboutPageButton:starling.display.Button;
		public var takePhotoButton:starling.display.Button;
		public var choosePhotoButton:starling.display.Button;
		public var colorSpectrumButton:starling.display.Button;
		
		private var _actionBar:Image;
		private var _spectrumIcon:Image;
		private var _welcomeTextImage:Image;
		private var _welcomeTextFormat:TextFormat;
		private var _directionsTextImage:Image;
		private var _directionsTextFormat:TextFormat;
		private var _arrowsImage:Image;
		
		public function WelcomePage()
		{
			vectorPage = new WelcomePageVector();
			_welcomeTextFormat = new TextFormat();
			_directionsTextFormat = new TextFormat();
			
			super();
		}
		
		private function setTextFormat(layoutModel:LayoutModel):void
		{
			_welcomeTextFormat.font = layoutModel.infoDispMedium.fontName;
			_welcomeTextFormat.size = 42 * layoutModel.scale;
			_welcomeTextFormat.align = TextFormatAlign.CENTER;
			_welcomeTextFormat.color = 0x333333;
			
			_directionsTextFormat.font = layoutModel.infoDispMedium.fontName;
			_directionsTextFormat.size = 34 * layoutModel.scale;
			_directionsTextFormat.align = TextFormatAlign.CENTER;
			//_directionsTextFormat.color = 0x444444; //lots of colors used...
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			setTextFormat(layoutModel);
			
			trace("welcome page reflowing vectors");
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			vectorPage.actionBar.gotoAndStop(1);
			vectorPage.actionBar.width = (layoutModel.appWidth + 4) * Starling.contentScaleFactor; 
			vectorPage.actionBar.height = (114 * layoutModel.scale) * Starling.contentScaleFactor; 
			vectorPage.actionBar.x = -2;
			vectorPage.actionBar.y = layoutModel.appHeight - (114 * layoutModel.scale);
			
			vectorPage.takePhotoButton.width = (200 * layoutModel.scale) * Starling.contentScaleFactor; 
			vectorPage.takePhotoButton.scaleY = vectorPage.takePhotoButton.scaleX;
			vectorPage.takePhotoButton.x = (layoutModel.appWidth * 0.5) - ((vectorPage.takePhotoButton.width/Starling.contentScaleFactor) * 0.5);
			vectorPage.takePhotoButton.y = layoutModel.appHeight - (vectorPage.takePhotoButton.height/Starling.contentScaleFactor) - 10;
			
			vectorPage.aboutPageButton.height = (layoutModel.navBarHeight/Starling.contentScaleFactor) * 0.7;
			vectorPage.aboutPageButton.scaleX = vectorPage.aboutPageButton.scaleY;
			//vectorPage.aboutPageButton.x = 14;
			//vectorPage.aboutPageButton.y = vectorPage.actionBar.y + (((vectorPage.actionBar.height/Starling.contentScaleFactor) - (vectorPage.aboutPageButton.height/Starling.contentScaleFactor)) * 0.5);
			
			vectorPage.settingsButton.height = (layoutModel.navBarHeight/Starling.contentScaleFactor) * 0.6;
			vectorPage.settingsButton.scaleX = vectorPage.settingsButton.scaleY;
			
			vectorPage.spectrumIcon.height = vectorPage.actionBar.height * 0.6;
			vectorPage.spectrumIcon.scaleX = vectorPage.spectrumIcon.scaleY;
			vectorPage.spectrumIcon.x = 24 * layoutModel.scale;
			vectorPage.spectrumIcon.y = vectorPage.actionBar.y + ((vectorPage.actionBar.height - vectorPage.spectrumIcon.height) * 0.5);
			
			vectorPage.choosePhotoButton.height = vectorPage.actionBar.height * 0.6;
			vectorPage.choosePhotoButton.scaleX = vectorPage.choosePhotoButton.scaleY;
			vectorPage.choosePhotoButton.x = layoutModel.appWidth - vectorPage.choosePhotoButton.width - (24 * layoutModel.scale);
			vectorPage.choosePhotoButton.y = vectorPage.actionBar.y + ((vectorPage.actionBar.height - vectorPage.choosePhotoButton.height) * 0.5);
		
			vectorPage.welcomeTF.width = layoutModel.appWidth;
			vectorPage.welcomeTF.height = 55 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.welcomeTF.x = 0;
			vectorPage.welcomeTF.y = (layoutModel.navBarHeight/Starling.contentScaleFactor) + (48 * layoutModel.scale);
			vectorPage.welcomeTF.text = "Welcome";
			vectorPage.welcomeTF.setTextFormat(_welcomeTextFormat);
			
			vectorPage.directionsTF.x = 24 * layoutModel.scale;
			vectorPage.directionsTF.y = vectorPage.welcomeTF.y + vectorPage.welcomeTF.height + (24 * layoutModel.scale);
			vectorPage.directionsTF.width = layoutModel.appWidth - (48 * layoutModel.scale);
			vectorPage.directionsTF.height = layoutModel.appHeight - vectorPage.directionsTF.y;
			var colorSpectrumText:String = "<font color='#ff3333'>c</font><font color='#FF7F00'>o</font><font color='#FFCC00'>l</font><font color='#44aa44'>o</font><font color='#0000FF'>r</font> <font color='#4B0082'>s</font><font color='#8F00FF'>p</font><font color='#ff3333'>e</font><font color='#FF7F00'>c</font><font color='#FFCC00'>t</font><font color='#44aa44'>r</font><font color='#0000FF'>u</font><font color='#4B0082'>m</font>";
			vectorPage.directionsTF.htmlText = "To start, you can <font color='#0099ff'>take a photo</font> or select an existing one from an <font color='#5E68E7'>album</font>.\n\rIf you're looking for a specific color, play with the " + colorSpectrumText + ".";
			vectorPage.directionsTF.setTextFormat(_directionsTextFormat);
			
			vectorPage.arrows.width = layoutModel.appWidth * 0.8;
			vectorPage.arrows.scaleY = vectorPage.arrows.scaleX;
			vectorPage.arrows.x = layoutModel.appWidth * 0.1;
			vectorPage.arrows.y = vectorPage.actionBar.y - vectorPage.arrows.height - (7 * layoutModel.scale);
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void 
		{ 
			trace("welcome page drawing vectors");
			
			//Remove first
			removeDrawnVector( _background );
			removeDrawnVector( _welcomeTextImage );
			removeDrawnVector( _directionsTextImage );
			removeDrawnVector( _arrowsImage );
			removeDrawnVector( _actionBar );
			removeDrawnVector( aboutPageButton );
			removeDrawnVector( takePhotoButton );
			removeDrawnVector( choosePhotoButton );
			removeDrawnVector( settingsButton );
			removeDrawnVector( colorSpectrumButton );
			
			//Make things
			_background = drawBackgroundQuad();
			aboutPageButton = createButtonFromMovieClip( vectorPage.aboutPageButton );
			_actionBar = createImageFromDisplayObject( vectorPage.actionBar );
			takePhotoButton = createButtonFromMovieClip( vectorPage.takePhotoButton );
			choosePhotoButton = createButtonFromMovieClip( vectorPage.choosePhotoButton );
			settingsButton = createButtonFromMovieClip( vectorPage.settingsButton );
			_spectrumIcon = createImageFromDisplayObject( vectorPage.spectrumIcon );
			colorSpectrumButton = createButtonFromMovieClip( vectorPage.spectrumIcon ); 
			_arrowsImage = createImageFromDisplayObject( vectorPage.arrows);
			_welcomeTextImage = createImageFromDisplayObject( vectorPage.welcomeTF );
			_directionsTextImage = createImageFromDisplayObject( vectorPage.directionsTF );
			
			
			//Add
			addChildAt( _background, 0 );
			addChild( _welcomeTextImage );
			addChild( _directionsTextImage );
			//addChild( _arrowsImage );
			addChild( _actionBar );
			addChild( takePhotoButton );
			addChild( choosePhotoButton );
			addChild( colorSpectrumButton );
			
			//Settings
		}
	}
}