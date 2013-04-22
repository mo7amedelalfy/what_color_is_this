package com.nicotroia.whatcoloristhis.controller.utils
{
	
	public class ColorHelper
	{
		public static var RED:String = "r";
		public static var GREEN:String = "g";
		public static var BLUE:String = "b";
		
		public static var rgb:Object = {};
		public static var palatte:Vector.<uint> = new <uint>[0xf02973, 0x0099ff, 0x333333, 0x2b2b2b, 0x444444, 0x60cccc, 0xffffcc, 0xf0f0f0];
		
		public static function colorBounds(color:uint):uint { return (color > 255) ? 255 : color; }
		
		public static function getRandomColorInPalatte():uint {
			return palatte[ Math.floor(Math.random()*palatte.length) ];
		}
		
		public static function getRandomColorInRange(color:uint, range:Number = 50):uint
		{
			var rgb:Object = getRGB(color);
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
		
		public static function getRGB(color:uint):Object
		{
			rgb["r"] = (color & 0xFF0000) >> 16;
			rgb["g"] = (color & 0x00FF00) >> 8;
			rgb["b"] = (color & 0x0000FF);
			
			return rgb;
		}
		
		public static function getARGB(color:uint):Object
		{
			rgb["a"] = (color & 0xFF000000) >> 24;
			rgb["r"] = (color & 0x00FF0000) >> 16;
			rgb["g"] = (color & 0x0000FF00) >> 8;
			rgb["b"] = (color & 0x000000FF);
			
			return rgb;
		}
		
		public static function colorToHex24String(color:uint):String
		{
			var str:String = color.toString(16);
			if( str.length == 8 ) str = str.substr(2); //remove transparency
			
			return str;
			
			//omg slow...
			var r:String = getRed(color).toString(16).toUpperCase();
			var g:String = getGreen(color).toString(16).toUpperCase();
			var b:String = getBlue(color).toString(16).toUpperCase();
			var zero:String = "0";
			
			if( r.length == 1 ) r = zero.concat(r);
			if( g.length == 1 ) g = zero.concat(g);
			if( b.length == 1 ) b = zero.concat(b);
			
			return r+g+b;
		}
		
		public static function colorToHex32String(color:uint):String
		{
			var str:String = color.toString(16);
			
			while( str.length < 8 ) { 
				str = "0" + str;
			}
			
			return str;
		}
		
		private static function checkBounds(color:int):uint
		{
			if(color > 255) return 255;
			if(color < 0) return 0;
			return color;
		}
		
		private static function getRed(c:uint):uint { return (( c >> 16 ) & 0xFF); }
		private static function getGreen(c:uint):uint { return ( (c >> 8) & 0xFF ); }
		private static function getBlue(c:uint):uint { return ( c & 0xFF ); }
	}
}