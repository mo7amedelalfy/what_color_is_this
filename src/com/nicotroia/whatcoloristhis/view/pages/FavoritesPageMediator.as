package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.FavoritesModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import flash.utils.setTimeout;
	
	import starling.events.Event;

	public class FavoritesPageMediator extends PageBaseMediator
	{
		[Inject]
		public var favoritesPage:FavoritesPage;
		
		[Inject]
		public var favoritesModel:FavoritesModel;
		
		override protected function pageAddedToStageHandler(event:Event=null):void
		{
			super.pageAddedToStageHandler(event);
			
			favoritesPage.reset();
			favoritesPage.displayFavorites(favoritesModel);
			
			addAccessoryButtonListeners();
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Your Favorites"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, favoritesPage.backButton));
			
			favoritesPage.favoritesList.addEventListener(Event.CHANGE, favoriteSelectedHandler);
			//favoritesPage.favoritesList.addEventListener(Event.TRIGGERED, favoriteListTriggeredHandler);
			
			favoritesPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
		}
		
		private function addAccessoryButtonListeners():void
		{
			for each( var accessoryDeleteButton:Button in favoritesPage.accessoryDeleteButtons ) { 
				accessoryDeleteButton.addEventListener(Event.TRIGGERED, accessoryDeleteButtonTriggeredHandler);
			}
		}
		
		private function accessoryDeleteButtonTriggeredHandler(event:Event):void
		{
			var button:Button = Button(event.target);
			button.isSelected = true;
			button.validate();
			
			try { 
				var item:Object = DefaultListItemRenderer(button.parent).data;
				
				button.removeEventListener(Event.TRIGGERED, accessoryDeleteButtonTriggeredHandler);
				
				trace("Removing " + item);
				
				favoritesModel.removeFavorite( item.hex );
				favoritesModel.writeFavorites();
				
				favoritesPage.displayFavorites(favoritesModel);
				//favoritesPage.removeFavoriteFromList( item );
				
				removeAccessoryButtonListeners();
				addAccessoryButtonListeners();
			}
			catch( error:Error ) { 
				trace("Remove Failed! " + error.errorID + " " + error.message);
			}
		}
		
		private function favoriteSelectedHandler(event:Event):void
		{
			if( ! sequenceModel.isTransitioning ) { 
				trace("selected: 0x" + favoritesPage.favoritesList.selectedItem.hex );
				
				//give this hex to results page somehow.
				cameraModel.chosenWinnerHex = favoritesPage.favoritesList.selectedItem.hex;
				
				setTimeout( function():void { 
					eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result));
				},1);
			}
			else { 
				//Clicked too early. Reset list, otherwise the item will select but page wont navigate
				List(event.target).selectedItem = null;
				List(event.target).validate();
			}
		}
		
		private function backButtonTriggeredHandler(event:Event):void
		{
			//favoritesModel.saveFavorites();
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
		}	
		
		override public function onRemove():void
		{
			favoritesPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			favoritesPage.favoritesList.removeEventListener(Event.CHANGE, favoriteSelectedHandler);
			//favoritesPage.favoritesList.removeEventListener(Event.TRIGGERED, favoriteListTriggeredHandler);
			
			removeAccessoryButtonListeners();
			
			super.onRemove();
		}
		
		private function removeAccessoryButtonListeners():void
		{
			for each( var accessoryDeleteButton:Button in favoritesPage.accessoryDeleteButtons ) { 
				accessoryDeleteButton.removeEventListener(Event.TRIGGERED, accessoryDeleteButtonTriggeredHandler);
			}
		}
		
	}
}