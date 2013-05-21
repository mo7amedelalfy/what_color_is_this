package com.nicotroia.whatcoloristhis.view.pages
{
	import com.distriqt.extension.applicationrater.ApplicationRater;
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.controller.utils.ResultLoader;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.ColorModel;
	import com.nicotroia.whatcoloristhis.model.FavoritesModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	import com.nicotroia.whatcoloristhis.model.SettingsModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class ResultPageMediator extends PageBaseMediator
	{
		[Inject]
		public var resultPage:ResultPage;
		
		[Inject]
		public var colorModel:ColorModel;
		
		[Inject]
		public var settingsModel:SettingsModel;
		
		[Inject]
		public var favoritesModel:FavoritesModel;
		
		override protected function pageAddedToStageHandler(event:starling.events.Event=null):void
		{
			super.pageAddedToStageHandler(event);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Results"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, resultPage.backButton));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_RIGHT, null, resultPage.doneButton));
			
			resultPage.favoriteButton.isEnabled = true;
			resultPage.favoriteButton.isSelected = false;
			
			if( favoritesModel.isFavorite( cameraModel.chosenWinnerHex ) ) { 
				resultPage.favoriteButton.isSelected = true;
			}
			
			//eventMap.mapStarlingListener(resultPage, starling.events.Event.TRIGGERED, resultPageTriggeredHandler);
			resultPage.backButton.addEventListener(starling.events.Event.TRIGGERED, backButtonTriggeredHandler);
			resultPage.doneButton.addEventListener(starling.events.Event.TRIGGERED, doneButtonTriggeredHandler);
			resultPage.favoriteButton.addEventListener(starling.events.Event.TRIGGERED, favoriteButtonTriggeredHandler);
			resultPage.suggestButton.addEventListener(starling.events.Event.TRIGGERED, suggestButtonTriggeredHandler);
			
			//if not returning back from suggestion page
			if( sequenceModel.lastPageClass !== SequenceModel.PAGE_Suggest ) { 
				resultPage.reset();
				
				resultPage.showSuggestButton();
				
				fetchResults();	
			}
			else { 
				if( colorModel.suggestedName ) { 
					resultPage.changeNameToSuggestion(colorModel);
				}
			}
		}
		
		private function favoriteButtonTriggeredHandler(event:starling.events.Event):void
		{
			if( ! resultPage.favoriteButton.isSelected ) { 
				trace("favorite: 0x" + cameraModel.chosenWinnerHex );
				
				favoritesModel.addFavorite( cameraModel.chosenWinnerHex );
				favoritesModel.writeFavorites();
				
				resultPage.favoriteButton.isSelected = true;
			}
		}
		
		private function suggestButtonTriggeredHandler(event:starling.events.Event):void
		{
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Suggest));
		}
		
		private function fetchResults():void
		{
			//this will be removed once first result comes
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, "Fetching result..."));
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.COLOR_RESULT_LOADING));
			
			colorModel.whatColorIsThis(cameraModel.chosenWinnerHex, resultSuccessHandler, resultErrorHandler);
		}
		
		public function resultSuccessHandler(result:Object, loader:ResultLoader):void
		{
			if( loader ) { 
				//does this reference actually set the object?
				loader = null;
			}
			
			if( result.result_type == ResultLoader.SIMPLE ) { 
				cameraModel.simpleResult = result;
				
				resultPage.vectorPage.colorNameTF.text = result.color_name; 
				resultPage.drawResults(layoutModel, cameraModel, settingsModel);
				
				eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
				
				return;
			}
			else { 
				resultPage.addResultToList(result.result_type, result.color_name, result.closest_match);
				setTimeout( function():void { 
					resultPage.positionBottom(layoutModel, settingsModel);
				}, 1);
			}
		}
		
		public function resultErrorHandler(loader:ResultLoader):void
		{
			if( loader.resultType == ResultLoader.SIMPLE ) { 
				//display a simple thing with no results
				trace("no internet?!?!?!?!?!");
				resultPage.drawOnlyTheColorDetails(layoutModel, cameraModel);
				
				eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			}
			
			if( loader ) { 
				loader = null;
			}
		}
		
		private function backButtonTriggeredHandler(event:starling.events.Event):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			if( sequenceModel.lastPageClass == SequenceModel.PAGE_Suggest ) { 
				//we don't really know whether to go back to favorites or confirm page...
				
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
			}
			else { 
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, sequenceModel.lastPageClass, null, NavigationEvent.NAVIGATE_LEFT));
			}
		}
		
		private function doneButtonTriggeredHandler(event:starling.events.Event):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
			
			//App rater
			try
			{
				trace("this was a significant event.");
				ApplicationRater.service.userDidSignificantEvent();
			}
			catch (e:Error)
			{
				trace( "AppRater ERROR:: "+e.message );
			}
		}
		
		override public function onRemove():void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			//eventMap.unmapStarlingListener(resultPage, starling.events.Event.TRIGGERED, resultPageTriggeredHandler);
			resultPage.backButton.removeEventListener(starling.events.Event.TRIGGERED, backButtonTriggeredHandler);
			resultPage.doneButton.removeEventListener(starling.events.Event.TRIGGERED, doneButtonTriggeredHandler);
			resultPage.suggestButton.removeEventListener(starling.events.Event.TRIGGERED, suggestButtonTriggeredHandler);
			
			//resultPage.reset();
			
			trace("result page removing.");
			
			super.onRemove();
			
			//if( resultPage.contains(_winningColorShape) ) resultPage.removeChild(_winningColorShape);
			//if( resultPage.contains(_targetCopy) ) resultPage.removeChild(_targetCopy);
			
			//_closestMatch = '';
			//_targetCopy = null;
			//_winningColorShape = null;
		}
		
	}
}