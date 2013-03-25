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
	import flash.display.StageOrientation;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class WelcomePage extends PageBase
	{
		public var settingsButton:feathers.controls.Button;
		public var aboutPageButton:starling.display.Button;
		public var takePhotoButton:starling.display.Button;
		
		private var _actionBar:Image;
		private var _settingsIcon:Image;
		
		public function WelcomePage()
		{
			vectorPage = new WelcomePageVector();
			settingsButton = new feathers.controls.Button();
			//settingsButton.defaultIcon = new Image( Assets.getAtlas().getTexture("button_up") );
			settingsButton.horizontalAlign = feathers.controls.Button.HORIZONTAL_ALIGN_CENTER;
			settingsButton.verticalAlign = feathers.controls.Button.VERTICAL_ALIGN_MIDDLE;
			settingsButton.iconPosition = feathers.controls.Button.ICON_POSITION_TOP;
			settingsButton.gap = 10;
			
			super();
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			trace("welcome page reflowing vectors");
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			vectorPage.directionsTF.x = 14;
			vectorPage.directionsTF.y = layoutModel.navBarHeight + 14;
			
			vectorPage.actionBar.gotoAndStop(1);
			vectorPage.actionBar.width = (layoutModel.appWidth + 4) * Starling.contentScaleFactor; 
			vectorPage.actionBar.height = (114 * layoutModel.scale) * Starling.contentScaleFactor; 
			vectorPage.actionBar.x = -2;
			vectorPage.actionBar.y = layoutModel.appHeight - (114 * layoutModel.scale);
			
			vectorPage.takePhotoButton.width = (200 * layoutModel.scale) * Starling.contentScaleFactor; 
			vectorPage.takePhotoButton.scaleY = vectorPage.takePhotoButton.scaleX;
			vectorPage.takePhotoButton.x = (layoutModel.appWidth * 0.5) - ((vectorPage.takePhotoButton.width/Starling.contentScaleFactor) * 0.5);
			vectorPage.takePhotoButton.y = layoutModel.appHeight - (vectorPage.takePhotoButton.height/Starling.contentScaleFactor) - 10;
			
			vectorPage.aboutPageButton.height = (vectorPage.actionBar.height/Starling.contentScaleFactor) * 0.7;
			vectorPage.aboutPageButton.scaleX = vectorPage.aboutPageButton.scaleY;
			vectorPage.aboutPageButton.x = 14;
			vectorPage.aboutPageButton.y = vectorPage.actionBar.y + (((vectorPage.actionBar.height/Starling.contentScaleFactor) - (vectorPage.aboutPageButton.height/Starling.contentScaleFactor)) * 0.5);
			
			vectorPage.directionsTF.width = layoutModel.appWidth - 28;
			vectorPage.directionsTF.height = layoutModel.appHeight - vectorPage.directionsTF.y - 14;
			
			vectorPage.settingsIcon.width = (26 * layoutModel.scale) * Starling.contentScaleFactor;
			vectorPage.settingsIcon.scaleY = vectorPage.settingsIcon.scaleX;
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void 
		{ 
			trace("welcome page drawing vectors");
			
			//Remove first
			removeDrawnVector( _actionBar );
			removeDrawnVector( aboutPageButton );
			removeDrawnVector( takePhotoButton );
			
			//Make things
			aboutPageButton = createButtonFromMovieClip( vectorPage.aboutPageButton );
			takePhotoButton = createButtonFromMovieClip( vectorPage.takePhotoButton );
			_settingsIcon = createImageFromDisplayObject( vectorPage.settingsIcon );
			_actionBar = createImageFromDisplayObject( vectorPage.actionBar );
			
			//Add
			addChild( _actionBar );
			addChild( aboutPageButton );
			addChild( takePhotoButton );
			
			//Settings
			settingsButton.defaultIcon = _settingsIcon;
		}
	}
}