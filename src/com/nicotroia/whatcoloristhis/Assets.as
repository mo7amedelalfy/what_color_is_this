package com.nicotroia.whatcoloristhis
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		public static var roundedScaleFactor:Number = 1;
		public static var lastRandomColor:uint;
		
		//[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/atlas.png")]
		//public static const AtlasTexture:Class;
		
		//[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/atlas.xml", mimeType="application/octet-stream")]
		//public static const AtlasXML:Class;
		
		[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/spinner.png")]
		public static const SpinnerTexture:Class;
		
		[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/spinner.xml", mimeType="application/octet-stream")]
		public static const SpinnerXML:Class;
		
		[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/spectrum_chart.jpg")]
		public static const SpectrumChart:Class;
		
		//private static var _atlas:TextureAtlas;
		private static var _spinnerAtlas:TextureAtlas;
		private static var _textures:Dictionary = new Dictionary();
		private static var _colors:Vector.<uint>;
		private static var _lightColors:Vector.<uint>;
		
		public static function getTexture(name:String):Texture
		{
			if( _textures[name] == undefined ) { 
				var bitmap:Bitmap = new Assets[name]();
				_textures[name] = Texture.fromBitmap(bitmap, true, false, Starling.contentScaleFactor);
			}
			
			return _textures[name];
		}
		/*
		public static function getAtlas():TextureAtlas
		{
			if( _atlas == null ) { 
				var texture:Texture = getTexture("AtlasTexture");
				var xml:XML = XML(new AtlasXML());
				
				_atlas = new TextureAtlas(texture, xml);
			}
			
			return _atlas;
		}*/
		
		public static function getSpinnerAtlas():TextureAtlas
		{
			if( _spinnerAtlas == null ) { 
				var texture:Texture = getTexture("SpinnerTexture");
				var xml:XML = XML(new SpinnerXML());
				
				_spinnerAtlas = new TextureAtlas(texture, xml);
			}
			
			return _spinnerAtlas;
		}
		
		public static function starlingDisplayObjectToBitmap(disp:DisplayObject, scl:Number=1.0):BitmapData
		{
			var rc:Rectangle = new Rectangle();
			disp.getBounds(disp, rc);
			
			var stage:Stage = Starling.current.stage;
			var rs:RenderSupport = new RenderSupport();
			
			rs.clear();
			rs.scaleMatrix(scl, scl);
			rs.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
			rs.translateMatrix(-rc.x, -rc.y); // move to 0,0
			disp.render(rs, 1.0);
			rs.finishQuadBatch();
			
			var outBmp:BitmapData = new BitmapData(rc.width*scl, rc.height*scl, true);
			Starling.context.drawToBitmapData(outBmp);
			
			return outBmp;
		}
		
		public static function getRandomColor():uint
		{
			if( ! _colors ) { 
				_colors = new <uint>[0xffffcc, 0x0099ff, 0xf02973];
			}
			
			lastRandomColor = _colors[Math.floor(Math.random() * _colors.length)];
			
			return lastRandomColor;
		}
		
		public static function getRandomLightColor():uint
		{
			if( ! _lightColors ) { 
				_lightColors = new <uint>[0xffffcc, 0xa3f0d6, 0x8ba2d6];
			}
			
			lastRandomColor = _lightColors[Math.floor(Math.random() * _lightColors.length)];
			
			return lastRandomColor;
		}
		
		public static function createRandomColorShape(width:Number, height:Number):Shape
		{
			var shape:Shape = new Shape();
			
			//have this color picked from an array
			shape.graphics.beginFill(getRandomColor(), 1.0);
			shape.graphics.drawRect(0, 0, width, height);
			
			return shape;
		}
	}
}