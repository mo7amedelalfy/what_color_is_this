package
{
	import com.mrdoob.stats.Stats;
	import com.nicotroia.whatcoloristhis.Application;
	import com.nicotroia.whatcoloristhis.Assets;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	
	[SWF(frameRate="60", width="320", height="480", backgroundColor="0xffffff")]
	public class what_color_is_this extends Sprite
	{
		private var _stats:Stats;
		private var _starling:Starling;
		private var _startupBackground:Shape;
		private var _startupImage:StartupImage;
		
		public function what_color_is_this()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			trace("hello world");
			
			addEventListener(flash.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, addedToStageHandler);
			
			_stats = new Stats();
			_stats.y = 100;
			addChild(_stats);
			
			//I have no idea what these numbers are for, but the app will scale to the full width/height
			var stageWidth:int = 320; 
			var stageHeight:int = 480; 
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true; // useful on mobile devices
			Starling.handleLostContext = true; //I was getting errors without this. //!iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				"showAll");
			
			//This scaleFactor is for when you have two asset sizes, "standard" and "HD"
			//In this app we scale and draw vectors, so we can use the precise Starling scaleFactor
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			Assets.roundedScaleFactor = scaleFactor;
			
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			// This is especially useful on iOS, where "Default.png" (or a variant) is displayed
			// during Startup. You can create an absolute seamless startup that way.
			// 
			// These are the only embedded graphics in this app. We can't load them from disk,
			// because that can only be done asynchronously (resulting in a short flicker).
			// 
			// Note that we cannot embed "Default.png" (or its siblings), because any embedded
			// files will vanish from the application package, and those are picked up by the OS!
			
			//Beautiful startup greeting
			
			_startupBackground = Assets.createRandomColorShape(stage.fullScreenWidth, stage.fullScreenHeight);
			_startupImage = new StartupImage();
			
			var greetings:Vector.<String> = new <String>["Hello", "Ciao", "Hej", "Hallo", "Hola", "Shalom", "Bonjour", "Namaste"];
			var tf:TextField = _startupImage.greetingTF;
			var textFormat:TextFormat = tf.defaultTextFormat;
			tf.width = stage.fullScreenWidth;
			tf.height = stage.fullScreenHeight * 0.5;
			tf.text = greetings[Math.floor(Math.random() * greetings.length)];
			
			if( Assets.lastRandomColor >= 0xffff00 ) textFormat.color = 0x2b2b2b;
			else textFormat.color = 0xffffff;
			
			textFormat.size = 32 * scaleFactor;
			textFormat.align = TextFormatAlign.CENTER;
			
			tf.setTextFormat(textFormat);
			tf.x = 0;
			tf.y = (stage.fullScreenHeight * 0.5) - (tf.textHeight * 0.5) - (14 * scaleFactor);
			
			addChild(_startupBackground);
			addChild(_startupImage);
			
			
			// launch Starling
			
			_starling = new Starling(Application, stage, viewPort);
			_starling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			_starling.stage.stageHeight = stageHeight; // <- same size on all devices!
			_starling.simulateMultitouch  = false;
			_starling.enableErrorChecking = false;
			
			trace("stage: " + stage.stageWidth, ",", stage.stageHeight);
			trace("screen: " + stage.fullScreenWidth, ",", stage.fullScreenHeight);
			trace("viewPort: " + viewPort);
			trace("scaleFactor: " + _starling.contentScaleFactor);
			
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				removeChild(_startupBackground);
				removeChild(_startupImage);
				
				_starling.start();
			});
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(); });
		}
	}
}