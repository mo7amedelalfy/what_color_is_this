package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;

	public class PageBaseMediator extends StarlingMediator
	{
		[Inject]
		public var view:PageBase;
		
		[Inject(name="overlayContainer")]
		public var overlayContainer:Sprite;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		[Inject]
		public var cameraModel:CameraModel;
		
		[Inject]
		public var sequenceModel:SequenceModel;
		
		override public function onRegister():void
		{
			trace("pagebase mediator onRegister " + view);
			
			if( ! view.isBeingMediated ) { 
				view.addEventListener(Event.ADDED_TO_STAGE, pageAddedToStageHandler);
			}
			
			view.isBeingMediated = true; 
		}
		
		protected function pageAddedToStageHandler(event:Event = null):void
		{
			//This shit's expensive... Resize only the first time it's added
			if( ! view.reflowed ) { 
				callAppResizedHandler();
			}
			
			view.addEventListener(Event.RESIZE, callAppResizedHandler);
			eventMap.mapListener(eventDispatcher, LayoutEvent.UPDATE_LAYOUT, reflowPage);
		}
		
		protected function callAppResizedHandler():void
		{
			reflowPage();
		}
		
		protected function reflowPage(event:LayoutEvent = null):void
		{
			if( ! view.parent ) return;
			
			view.reflowed = false;
			
			view.reflowVectors(layoutModel, cameraModel);
			view.drawVectors(layoutModel, cameraModel);
			
			view.reflowed = true;
		}
		
		protected function addToOverlay(obj:DisplayObject):void
		{
			overlayContainer.addChild(obj);
		}
		
		protected function removeFromOverlay(obj:DisplayObject):void
		{
			overlayContainer.removeChild(obj);
		}
		
		override public function onRemove():void
		{
			view.removeEventListener(Event.RESIZE, callAppResizedHandler);
			eventMap.unmapListener(eventDispatcher, LayoutEvent.UPDATE_LAYOUT, reflowPage);
			
			//trace("pagebase onRemove");
			
			super.onRemove();
			
			//we have to make sure somehow that overlays don't accidentally trigger pages "successful removal"
			//sequenceModel.lastPageRemovedSuccessfully = true;
		}
	}
}