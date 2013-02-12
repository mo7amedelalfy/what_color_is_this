package
{
	import com.bit101.components.PushButton;
	import com.nicotroia.whatcoloristhis.ColorManager;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	[SWF(width="480", height="300", frameRate="24")]
	public class what_color_is_this extends Sprite
	{
		private var _colorManager:ColorManager;
		
		public function what_color_is_this()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			trace("hello world");
			
			_colorManager = new ColorManager();
			
			var cameraOption:PushButton = new PushButton(this, 50, 50, "Camera", cameraOptionClickHandler);
			var cameraRollOption:PushButton = new PushButton(this, 150, 50, "Camera Roll", cameraRollOptionClickHandler);
			
			addChild(cameraOption);
			addChild(cameraRollOption);
		}
		
		private function cameraOptionClickHandler(event:MouseEvent):void
		{
			_colorManager.initCamera();
		}
		
		private function cameraRollOptionClickHandler(event:MouseEvent):void
		{
			_colorManager.initCameraRoll();
		}
		
	}
}