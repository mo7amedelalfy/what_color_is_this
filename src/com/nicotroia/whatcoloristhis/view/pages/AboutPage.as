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
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class AboutPage extends PageBase
	{
		public var backButton:Button;
		
		public function AboutPage()
		{
			vectorPage = new AboutPageVector();
			
			super();
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			trace("about page reflowing vectors");
			
			vectorPage.x = 0;
			vectorPage.y = 0;
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void
		{	
			trace("about page drawing vectors");
			
			//Remove first
			//removeDrawnVector( backButton );
			removeDrawnVector( _background );
			
			//Create
			_background = drawBackgroundQuad();
			backButton = new Button();
			
			//Add
			addChildAt(_background, 0);
			//addChild( _header );
			//addChild( backButton );
			
			//Settings
			backButton.label = "Back";
		}
	}
}