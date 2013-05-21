package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.model.FavoritesModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;

	public class SaveFavoritesCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var favoritesModel:FavoritesModel;
		
		override public function execute():void
		{
			trace("SaveFavoritesCommand via " + event.type);
			
			favoritesModel.writeFavorites();
		}
	}
}