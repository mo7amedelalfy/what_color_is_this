package com.nicotroia.whatcoloristhis.view.pages
{
	import org.robotlegs.mvcs.Mediator;

	public class PageBaseMediator extends Mediator
	{
		[Inject]
		public var view:PageBase;
		
		override public function onRegister():void
		{
			
		}
	}
}