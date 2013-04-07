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
		
		override public function onRegister():void
		{
			resultPage.setTextFormat(layoutModel);
			resultPage.reset();
			
			super.onRegister();
			
			resultPage.drawResults(layoutModel, cameraModel);
			
			//Add the hex...
			//resultPage.addResultToList("Hex", "0x"+cameraModel.chosenWinnerHex, cameraModel.chosenWinnerHex);
			
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Results"));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, resultPage.backButton));
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_RIGHT, null, resultPage.doneButton));
			
			eventMap.mapStarlingListener(resultPage, starling.events.Event.TRIGGERED, resultPageTriggeredHandler);
			resultPage.backButton.addEventListener(starling.events.Event.TRIGGERED, backButtonTriggeredHandler);
			resultPage.doneButton.addEventListener(starling.events.Event.TRIGGERED, doneButtonTriggeredHandler);
			
			fetchResults();
		}
		
		private function fetchResults():void
		{
			//this will be removed once first result comes
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, "Fetching result..."));
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.COLOR_RESULT_LOADING));
			
			if( Settings.fetchCrayolaResults ) { 
				var crayolaResultLoader:ResultLoader = new ResultLoader(ResultLoader.CRAYOLA, cameraModel.chosenWinnerHex, resultHandler);
			}
			
			if( Settings.fetchPantoneResults ) { 
				var pantoneResultLoader:ResultLoader = new ResultLoader(ResultLoader.PANTONE, cameraModel.chosenWinnerHex, resultHandler);
			}
		}
		
		public function resultHandler(result:Object, loader:ResultLoader):void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			if( loader ) { 
				loader = null;
			}
			
			if( result ) { 
				resultPage.addResultToList(result.result_type, result.color_name, result.closest_match);
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
		
		private function resultPageTriggeredHandler(event:starling.events.Event):void
		{
			var button:DisplayObject = event.target as DisplayObject;
			
		}
		
		override public function onRemove():void
		{
			eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
			
			eventMap.unmapStarlingListener(resultPage, starling.events.Event.TRIGGERED, resultPageTriggeredHandler);
			resultPage.backButton.removeEventListener(starling.events.Event.TRIGGERED, backButtonTriggeredHandler);
			resultPage.doneButton.removeEventListener(starling.events.Event.TRIGGERED, doneButtonTriggeredHandler);
			
			resultPage.reset();
			
			super.onRemove();
			
			trace("result page removing.");
			
			//if( resultPage.contains(_winningColorShape) ) resultPage.removeChild(_winningColorShape);
			//if( resultPage.contains(_targetCopy) ) resultPage.removeChild(_targetCopy);
			
			//_closestMatch = '';
			//_targetCopy = null;
			//_winningColorShape = null;
		}
	}
}