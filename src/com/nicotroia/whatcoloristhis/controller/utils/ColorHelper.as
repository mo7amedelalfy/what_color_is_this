package com.nicotroia.whatcoloristhis.controller.utils
{
	import flash.utils.Dictionary;
	
	public class ColorHelper
	{
		public static var RED:String = "r";
		public static var GREEN:String = "g";
		public static var BLUE:String = "b";
		
		public static var rgb:Dictionary = new Dictionary();
		public static var palatte:Vector.<uint> = new <uint>[0xf02973, 0x0099ff, 0x333333, 0x2b2b2b, 0x444444, 0x60cccc, 0xffffcc, 0xf0f0f0];
		
		public static function colorBounds(color:uint):uint { return (color > 255) ? 255 : color; }
		
		public static function getRandomColorInPalatte():uint {
			return palatte[ Math.floor(Math.random()*palatte.length) ];
		}
		
		public static function getRandomColorInRange(color:uint, range:Number = 50):uint
		{
			var rgb:Dictionary = getRGB(color);
			var scale:int = (Math.random()*(range*2))-range;
			var newColor:uint = (checkBounds(rgb["r"] + scale) << 16) | (checkBounds(rgb["g"] + scale) << 8) | (checkBounds(rgb["b"] + scale));
			
			return newColor;
		}
		
		public static function applyAlpha(color:uint, alpha:Number = 1.0, background:uint = 0xffffff):uint 
		{ 
			if( alpha < 0.0 ) return 0;
			
			var r:uint = colorBounds( uint(((color & 0xff0000) >> 16) * alpha) );
			var g:uint = colorBounds( uint(((color & 0x00ff00) >> 8) * alpha) );
			var b:uint = colorBounds( uint((color & 0x0000ff) * alpha) );
			
			return (r<<16|g<<8|b);
		}
		
		public static function incrementChannel(color:uint, channel:String, i:int):uint
		{
			rgb = getRGB(color);
			
			rgb[channel] += i;
			if( rgb[channel] < 0 ) { rgb[channel] = 0; }
			if( rgb[channel] > 255 ) { rgb[channel] = 255; } 
			
			return combineChannels( rgb['r'], rgb['g'], rgb['b'] );
		}
		
		public static function combineChannels(r:uint, g:uint, b:uint):uint
		{
			return ((r<<16)|(g<<8))|(b);
		}
		
		public static function getRGB(color:uint):Dictionary
		{
			rgb["r"] = (color & 0xFF0000) >> 16;
			rgb["g"] = (color & 0x00FF00) >> 8;
			rgb["b"] = (color & 0x0000FF);
			
			return rgb;
		}
		
		private static function checkBounds(color:int):uint
		{
			if(color > 255) return 255;
			if(color < 0) return 0;
			return color;
		}
	}
}