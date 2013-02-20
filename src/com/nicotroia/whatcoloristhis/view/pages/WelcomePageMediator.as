package com.nicotroia.whatcoloristhis.view.pages
{
	public class WelcomePageMediator extends PageBaseMediator
	{
		[Inject]
		public var welcomePage:WelcomePage;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			rearrange();
			
		}
		
		private function rearrange():void
		{
			trace(welcomePage.topNavBar);
			trace(welcomePage.topNavBar);
			//welcomePage.topNavBar.width = contextView.stage.stageWidth;
			//welcomePage.topNavBar.height = 50;
			
			//welcomePage.topNavBar.text = "Welcome!!!!";
		}
	}
}