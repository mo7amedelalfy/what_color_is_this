package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.model.ErrorModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;

	public class SendErrorsToServerCommand extends StarlingCommand
	{
		[Inject]
		public var event:Event;
		
		[Inject]
		public var errorModel:ErrorModel;
		
		override public function execute():void
		{
			if( errorModel.errors.length ) { 
				trace("SendErrorsToServerCommand via " + event.type);
				
				//concatenate all errors to one string...
				errorModel.sendErrorsToServer( errorModel.errors.toString(), function(success:Boolean):void { 
					if( success ) { 
						errorModel.resetErrors();
					}
				}); 
			}
		}
	}
}