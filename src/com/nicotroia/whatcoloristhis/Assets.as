package com.nicotroia.whatcoloristhis
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets
	{
		//public static var scaleFactor:Number = 1;
		
		[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/atlas.png")]
		public static const AtlasTexture:Class;
		
		[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/atlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXML:Class;
		
		[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/screaming-goat.jpg")]
		public static const ScreamingGoat:Class;
		
		private static var _textures:Dictionary = new Dictionary();
		private static var _atlas:TextureAtlas;
		
		public static function getTexture(name:String):Texture
		{
			if( _textures[name] == undefined ) { 
				var bitmap:Bitmap = new Assets[name]();
				_textures[name] = Texture.fromBitmap(bitmap, true, false, Starling.contentScaleFactor);
			}
			
			return _textures[name];
		}
		
		public static function getAtlas():TextureAtlas
		{
			if( _atlas == null ) { 
				var texture:Texture = getTexture("AtlasTexture");
				var xml:XML = XML(new AtlasXML());
				
				_atlas = new TextureAtlas(texture, xml);
			}
			
			return _atlas;
		}
	}
}