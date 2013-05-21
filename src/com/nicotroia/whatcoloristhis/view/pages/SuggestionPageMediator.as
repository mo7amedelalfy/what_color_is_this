package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.ColorModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import feathers.controls.TextInput;
	import feathers.events.FeathersEventType;
	
	import flash.net.URLLoader;
	import flash.utils.setTimeout;
	
	import starling.events.Event;

	public class SuggestionPageMediator extends PageBaseMediator
	{
		[Inject]
		public var suggestionPage:SuggestionPage;
		
		[Inject]
		public var colorModel:ColorModel;

		private var _submit:Boolean;
		
		override protected function pageAddedToStageHandler(event:Event=null):void
		{
			super.pageAddedToStageHandler(event);
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, suggestionPage.backButton));
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "Suggest a Name"));
			
			suggestionPage.backButton.addEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			suggestionPage.submitButton.addEventListener(Event.TRIGGERED, submitButtonTriggeredHandler);
			
			suggestionPage.textInput.addEventListener(Event.CHANGE, textInputChangeHandler);
			suggestionPage.textInput.addEventListener(FeathersEventType.ENTER, textInputEnterHandler);
			suggestionPage.textInput.addEventListener(FeathersEventType.FOCUS_IN, textInputFocusInHandler);
			suggestionPage.textInput.addEventListener(FeathersEventType.FOCUS_OUT, textInputFocusOutHandler);
			
			_submit = false;
			suggestionPage.reset();
		}
		
		private function textInputFocusOutHandler(event:Event):void
		{
			trace("focus out");
		}
		
		private function textInputFocusInHandler(event:Event):void
		{
			trace("focus in");
			
			if( suggestionPage.textInput.text == "Suggestion" ) { 
				suggestionPage.textInput.text = '';
				suggestionPage.textInput.validate();
			}
			
		}
		
		private function textInputChangeHandler(event:Event):void
		{
			trace("change: " + TextInput(event.currentTarget).text);
		}
		
		private function backButtonTriggeredHandler(event:Event):void
		{
			colorModel.resetSuggestion();
			
			eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result, null, NavigationEvent.NAVIGATE_LEFT));
		}
		
		private function submitButtonTriggeredHandler():void
		{
			trace("submit");
			
			sendSuggestion();
		}
		
		private function textInputEnterHandler(event:Event):void
		{
			trace("enter");
			
			sendSuggestion();
		}
		
		private function sendSuggestion():void
		{
			if( ! _submit ) { 
				suggestionPage.backButton.isEnabled = false;
				suggestionPage.backButton.isSelected = true;
				//suggestionPage.textInput.isEnabled = false; //this makes the skin change...
				suggestionPage.submitButton.isEnabled = false;
				suggestionPage.submitButton.isSelected = true;
				
				suggestionPage.backButton.validate();
				suggestionPage.submitButton.validate();
				
				_submit = true;
				
				var suggestion:String = suggestionPage.textInput.text;
				
				//sanitize and strip suggestion
				
				colorModel.suggestedName = suggestion;
				
				colorModel.giveSimpleColorsASuggestion( cameraModel.chosenWinnerHex, cameraModel.simpleResult.closest_match, suggestion, sendSuggestionSuccessHandler, sendSuggestionErrorHandler);
			}
		}
		
		private function sendSuggestionSuccessHandler():void
		{
			trace("suggestion success");
			
			//make something say "Sent!"
			
			setTimeout( function():void { 
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result, null, NavigationEvent.NAVIGATE_LEFT));
			}, 2000);
		}
		
		private function sendSuggestionErrorHandler():void
		{
			trace("suggestion error");
			
			colorModel.resetSuggestion();
			
			//make something say "Error sorry"
			
			setTimeout( function():void { 
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Result, null, NavigationEvent.NAVIGATE_LEFT));
			}, 2000);
		}
		
		override public function onRemove():void
		{
			suggestionPage.backButton.removeEventListener(Event.TRIGGERED, backButtonTriggeredHandler);
			suggestionPage.submitButton.removeEventListener(Event.TRIGGERED, submitButtonTriggeredHandler);
			
			suggestionPage.textInput.removeEventListener(Event.CHANGE, textInputChangeHandler);
			suggestionPage.textInput.removeEventListener(FeathersEventType.ENTER, textInputEnterHandler);
			suggestionPage.textInput.removeEventListener(FeathersEventType.FOCUS_IN, textInputFocusInHandler);
			suggestionPage.textInput.removeEventListener(FeathersEventType.FOCUS_OUT, textInputFocusOutHandler);
			
			super.onRemove();
		}
	}
}