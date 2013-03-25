package
{
	import com.mrdoob.stats.Stats;
	import com.nicotroia.whatcoloristhis.Application;
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.ColorContext;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	
	[SWF(frameRate="60", width="320", height="480", backgroundColor="0xffffff")]
	public class what_color_is_this extends Sprite
	{
		// Startup image for SD screens
		[Embed(source="/Users/nicotroia/PROJECTS/starling_robotlegs/src/assets/graphics/startup.jpg")]
		private static var Background:Class;
		
		// Startup image for HD screens
		[Embed(source="/Users/nicotroia/PROJECTS/starling_robotlegs/src/assets/graphics/startupHD.jpg")]
		private static var BackgroundHD:Class;
		
		//private var _context:ColorContext;
		private var _stats:Stats;
		private var _starling:Starling;
		
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
			
			var stageWidth:int = 320; //640; //320;
			var stageHeight:int = 480; //960; //480;
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = true; //!iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				"showAll");
			
			// create the AssetManager, which handles all required assets for this resolution
			
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			//var appDir:File = File.applicationDirectory;
			//var assets:AssetManager = new AssetManager(scaleFactor);
			
			//assets.verbose = Capabilities.isDebugger;
			/*assets.enqueue(
			appDir.resolvePath("audio"),
			appDir.resolvePath(formatString("fonts/{0}x", scaleFactor)),
			appDir.resolvePath(formatString("textures/{0}x", scaleFactor))
			);*/
			
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
			
			var background:Bitmap = scaleFactor == 1 ? new Background() : new BackgroundHD();
			Background = BackgroundHD = null; // no longer needed!
			
			background.x = viewPort.x;
			background.y = viewPort.y;
			background.width  = viewPort.width;
			background.height = viewPort.height;
			background.smoothing = true;
			addChild(background);
			
			// launch Starling
			
			_starling = new Starling(Application, stage, viewPort);
			_starling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			_starling.stage.stageHeight = stageHeight; // <- same size on all devices!
			_starling.simulateMultitouch  = false;
			_starling.enableErrorChecking = false;
			
			trace("stage: " + stage.stageWidth, ",", stage.stageHeight);
			trace("screen: " + stage.fullScreenWidth, ",", stage.fullScreenHeight);
			trace("viewPort: " + viewPort);
			trace("starlingScaleFactor: " + _starling.contentScaleFactor, "scaleFactor: " + scaleFactor);
			
			//Assets.scaleFactor = scaleFactor; //_starling.contentScaleFactor;
			
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				removeChild(background);
				
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