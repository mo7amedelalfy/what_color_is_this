package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.controller.utils.ResultLoader;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class ResultPageMediator extends PageBaseMediator
	{
		[Inject]
		public var resultPage:ResultPage;
		
		override protected function pageAddedToStageHandler(event:starling.events.Event=null):void
		{
			resultPage.reset();
			
			super.pageAddedToStageHandler(event);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Results"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, resultPage.backButton));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_RIGHT, null, resultPage.doneButton));
			
			//eventMap.mapStarlingListener(resultPage, starling.events.Event.TRIGGERED, resultPageTriggeredHandler);
			resultPage.backButton.addEventListener(starling.events.Event.TRIGGERED, backButtonTriggeredHandler);
			resultPage.doneButton.addEventListener(starling.events.Event.TRIGGERED, doneButtonTriggeredHandler);
			
			fetchResults();	
		}
		
		private function fetchResults():void
		{
			//this will be removed once first result comes
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, "Fetching result..."));
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.COLOR_RESULT_LOADING));
			
			//We should combine these separate table results into ONE data set
			
			//always get the simple result
			var simpleResultLoader:ResultLoader = new ResultLoader(ResultLoader.SIMPLE, cameraModel.chosenWinnerHex, resultSuccessHandler, resultErrorHandler);
			
			if( Settings.fetchNtcResults ) { 
				var ntcResultLoader:ResultLoader = new ResultLoader(ResultLoader.NAME_THAT_COLOR, cameraModel.chosenWinnerHex, resultSuccessHandler, resultErrorHandler);
			}
			
			if( Settings.fetchCrayolaResults ) { 
				var crayolaResultLoader:ResultLoader = new ResultLoader(ResultLoader.CRAYOLA, cameraModel.chosenWinnerHex, resultSuccessHandler, resultErrorHandler);
			}
			
			if( Settings.fetchPantoneResults ) { 
				var pantoneResultLoader:ResultLoader = new ResultLoader(ResultLoader.PANTONE, cameraModel.chosenWinnerHex, resultSuccessHandler, resultErrorHandler);
			}
		}
		
		public function resultSuccessHandler(result:Object, loader:ResultLoader):void
		{
			if( loader ) { 
				loader = null;
			}
			
			if( result.result_type == ResultLoader.SIMPLE ) { 
				resultPage.vectorPage.colorNameTF.text = result.color_name; 
				resultPage.drawResults(layoutModel, cameraModel);
				
				eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
				
				return;
			}
			
			if( result ) { 
				resultPage.addResultToList(result.result_type, result.color_name, result.closest_match);
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
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_ConfirmColor, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		private function doneButtonTriggeredHandler(event:starling.events.Event):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Welcome, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		override public function onRemove():void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			//eventMap.unmapStarlingListener(resultPage, starling.events.Event.TRIGGERED, resultPageTriggeredHandler);
			resultPage.backButton.removeEventListener(starling.events.Event.TRIGGERED, backButtonTriggeredHandler);
			resultPage.doneButton.removeEventListener(starling.events.Event.TRIGGERED, doneButtonTriggeredHandler);
			
			resultPage.reset();
			
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