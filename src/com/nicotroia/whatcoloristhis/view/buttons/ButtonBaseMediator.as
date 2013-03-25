package com.nicotroia.whatcoloristhis.view.buttons
{
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.events.Event;
	
	public class ButtonBaseMediator extends StarlingMediator
	{
		[Inject]
		public var view:ButtonBase;
		
		override public function onRegister():void
		{			
			appResizedHandler(null);
		}
		
		protected function appResizedHandler(event:Event = null):void
		{
			//override
		}
	}
}