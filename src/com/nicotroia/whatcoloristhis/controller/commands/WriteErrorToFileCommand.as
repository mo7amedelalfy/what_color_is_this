package com.nicotroia.whatcoloristhis.controller.commands
{
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.ErrorModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	public class WriteErrorToFileCommand extends StarlingCommand
	{
		[Inject]
		public var event:NotificationEvent;
		
		[Inject]
		public var errorModel:ErrorModel;
		
		override public function execute():void
		{
			trace("WriteErrorToFileCommand via " + event.type);
			
			errorModel.addError( event.text );
			errorModel.writeErrors();
		}
	}
}