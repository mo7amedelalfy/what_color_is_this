package com.nicotroia.whatcoloristhis
{
	public class Settings
	{
		public static var userHasSettingsForVersion:String; //Used to reset the ApplicationRater state on new release builds
		public static var fetchCrayolaResults:Boolean = true;
		public static var fetchPantoneResults:Boolean = true;
		public static var fetchNtcResults:Boolean = true;
		
		private static var _colorChoicesGivenToUser:uint = 10;
		
		public static function get colorChoicesGivenToUser():uint { return _colorChoicesGivenToUser; }
		public static function set colorChoicesGivenToUser(val:uint):void { 
			if( val <= 5 ) { 
				_colorChoicesGivenToUser = 5;
			}
			else if( val >= 50 ) { 
				_colorChoicesGivenToUser = 50;
			}
			else { 
				_colorChoicesGivenToUser = val;
			}
		}
	}
}