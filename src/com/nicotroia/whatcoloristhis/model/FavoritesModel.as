package com.nicotroia.whatcoloristhis.model
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.robotlegs.mvcs.Actor;

	public class FavoritesModel extends Actor
	{
		public var file:File;
		public var fileStream:FileStream;
		
		private var _favorites:Array = [];
		
		public function FavoritesModel()
		{
			file = File.applicationStorageDirectory.resolvePath("Favorites.json");
			
			fileStream = new FileStream();
			
			//addFavorite("0099ff");
			//writeFavorites();
			
			readFavorites();
			
			trace("Favorites Model init");
		}
		
		public function get favorites():Array
		{
			if( ! _favorites ) { 
				readFavorites();
			}
			
			return _favorites;
		}
		
		public function readFavorites():Array
		{
			if( file.exists ) { 
				fileStream.open(file, FileMode.READ);
				
				var contents:String = fileStream.readMultiByte(fileStream.bytesAvailable, "utf-8");
				fileStream.close();
				
				var array:Array = JSON.parse(contents) as Array;
				
				this._favorites = array;
				
				return array;
			}
			
			return null;
		}
		
		public function addFavorite(hex:String):void
		{
			if( _favorites.indexOf(hex) == -1 ) { 
				_favorites.push(hex);
			}
		}
		
		public function removeFavorite(hex:String):void
		{
			var index:int = _favorites.indexOf(hex);
			
			if( index > -1 ) { 
				_favorites.splice( index, 1 );
			}
		}
		
		public function isFavorite(hex:String):Boolean
		{
			if( _favorites.indexOf(hex) > -1 ) { 
				return true;
			}
			
			return false;
		}
		
		public function writeFavorites():void
		{
			var json:String = JSON.stringify(this._favorites);
			
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(json);
			fileStream.close();
		}
	}
}