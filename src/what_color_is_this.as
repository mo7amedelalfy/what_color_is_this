package
{
	import com.nicotroia.whatcoloristhis.ColorContext;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	[SWF(width="480", height="300", frameRate="24")]
	public class what_color_is_this extends Sprite
	{
		private var _context:ColorContext;
		//private var _colorManager:ColorManager;
		
		public function what_color_is_this()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 30;
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			trace("hello world");
			
			_context = new ColorContext(this);
			
			/*			
			_colorManager = new ColorManager();
			
			var cameraOption:PushButton = new PushButton(this, 50, 50, "Camera", cameraOptionClickHandler);
			var cameraRollOption:PushButton = new PushButton(this, 150, 50, "Camera Roll", cameraRollOptionClickHandler);
			
			addChild(cameraOption);
			addChild(cameraRollOption);
			*/
		}
		/*
		private function cameraOptionClickHandler(event:MouseEvent):void
		{
			_colorManager.initCamera();
		}
		
		private function cameraRollOptionClickHandler(event:MouseEvent):void
		{
			_colorManager.eventDispatcher.addEventListener(ImageEvent.CAMERA_ROLL_IMAGE_SELECTED, cameraRollImageSelectedHandler);
			_colorManager.initCameraRoll();
		}
		
		protected function cameraRollImageSelectedHandler(event:ImageEvent):void
		{
			trace(event.bitmap);
			addChild(event.bitmap);
		}
		*/
	}
}