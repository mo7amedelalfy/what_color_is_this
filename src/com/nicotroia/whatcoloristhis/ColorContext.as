package com.nicotroia.whatcoloristhis
{
	import com.nicotroia.whatcoloristhis.controller.commands.AddTextToLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.GotoPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.HideLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ImageSelectFailedCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ImageSelectedCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.LayoutPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ShowLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.StartupAnimationCommand;
	import com.nicotroia.whatcoloristhis.controller.events.CameraEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	import com.nicotroia.whatcoloristhis.view.buttons.AboutPageButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.AcceptButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBase;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBaseMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.CancelButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.NavBarMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.TakePhotoButtonMediator;
	import com.nicotroia.whatcoloristhis.view.overlays.HeaderOverlay;
	import com.nicotroia.whatcoloristhis.view.overlays.HeaderOverlayMediator;
	import com.nicotroia.whatcoloristhis.view.overlays.ShadowBoxMediator;
	import com.nicotroia.whatcoloristhis.view.overlays.ShadowBoxView;
	import com.nicotroia.whatcoloristhis.view.overlays.TransparentSpinnerMediator;
	import com.nicotroia.whatcoloristhis.view.pages.AboutPage;
	import com.nicotroia.whatcoloristhis.view.pages.AboutPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.AreaSelectPage;
	import com.nicotroia.whatcoloristhis.view.pages.AreaSelectPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.ConfirmColorPage;
	import com.nicotroia.whatcoloristhis.view.pages.ConfirmColorPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	import com.nicotroia.whatcoloristhis.view.pages.PageBaseMediator;
	import com.nicotroia.whatcoloristhis.view.pages.ResultPage;
	import com.nicotroia.whatcoloristhis.view.pages.ResultPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.SettingsPage;
	import com.nicotroia.whatcoloristhis.view.pages.SettingsPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.WelcomePage;
	import com.nicotroia.whatcoloristhis.view.pages.WelcomePageMediator;
	
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.StarlingContext;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.utils.RectangleUtil;

	public class ColorContext extends StarlingContext
	{
		public var pageContainer:Sprite;
		public var overlayContainer:Sprite;
		public var backgroundSprite:Sprite;
		public var loadingSpinner:TransparentSpinner;
		public var shadowBox:ShadowBoxView;
		
		private var _init:Boolean;
		
		public function ColorContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			//models
			injector.mapSingleton(SequenceModel);
			injector.mapSingleton(CameraModel);
			injector.mapSingleton(LayoutModel);
			injector.mapValue(DisplayObjectContainer, contextView, "contextView");
			
			
			//graphics
			pageContainer = new Sprite();
			injector.mapValue(Sprite, pageContainer, "pageContainer");
			
			overlayContainer = new Sprite();
			injector.mapValue(Sprite, overlayContainer, "overlayContainer");
			
			backgroundSprite = new Sprite();
			injector.mapValue(Sprite, backgroundSprite, "backgroundSprite");
			
			loadingSpinner = new TransparentSpinner();
			injector.mapValue(TransparentSpinner, loadingSpinner);
			
			shadowBox = new ShadowBoxView(contextView.stage.stageWidth, contextView.stage.stageHeight);
			injector.mapValue(ShadowBoxView, shadowBox);
			
			
			//startup chain
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupAnimationCommand, ContextEvent);
			
			
			//events
			commandMap.mapEvent(LayoutEvent.RESIZE, LayoutPageCommand, LayoutEvent);
			commandMap.mapEvent(LayoutEvent.ORIENTATION_CHANGE, LayoutPageCommand, LayoutEvent);
			commandMap.mapEvent(NavigationEvent.NAVIGATE_TO_PAGE, GotoPageCommand, NavigationEvent);
			commandMap.mapEvent(CameraEvent.CAMERA_IMAGE_TAKEN, ImageSelectedCommand, CameraEvent);
			commandMap.mapEvent(CameraEvent.CAMERA_ROLL_IMAGE_SELECTED, ImageSelectedCommand, CameraEvent);
			commandMap.mapEvent(CameraEvent.CAMERA_IMAGE_FAILED, ImageSelectFailedCommand, CameraEvent);
			commandMap.mapEvent(CameraEvent.CAMERA_ROLL_IMAGE_FAILED, ImageSelectedCommand, CameraEvent);
			commandMap.mapEvent(LoadingEvent.COLOR_RESULT_LOADING, ShowLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(LoadingEvent.LOADING_FINISHED, HideLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, AddTextToLoadingSpinnerCommand, NotificationEvent);
			
			
			//pages
			mediatorMap.mapView(PageBase, PageBaseMediator);
			mediatorMap.mapView(HeaderOverlay, HeaderOverlayMediator, [PageBase, HeaderOverlay]);
			mediatorMap.mapView(WelcomePage, WelcomePageMediator, [PageBase, WelcomePage]);
			mediatorMap.mapView(SettingsPage, SettingsPageMediator, [PageBase, SettingsPage]);
			mediatorMap.mapView(AboutPage, AboutPageMediator, [PageBase, AboutPage]);
			mediatorMap.mapView(AreaSelectPage, AreaSelectPageMediator, [PageBase, AreaSelectPage]);
			mediatorMap.mapView(ConfirmColorPage, ConfirmColorPageMediator, [PageBase, ConfirmColorPage]);
			mediatorMap.mapView(ResultPage, ResultPageMediator, [PageBase, ResultPage]);
			
			
			//buttons
			mediatorMap.mapView(ButtonBase, ButtonBaseMediator);
			//mediatorMap.mapView(NavBar, NavBarMediator, [ButtonBase, NavBar]);
			//mediatorMap.mapView(BackButton, BackButtonMediator, [ButtonBase, BackButton]);
			//mediatorMap.mapView(TakePhotoButton, TakePhotoButtonMediator, [ButtonBase, TakePhotoButton]);
			//mediatorMap.mapView(AboutPageButton, AboutPageButtonMediator, [ButtonBase, AboutPageButton]);
			//mediatorMap.mapView(AcceptButton, AcceptButtonMediator, [ButtonBase, AcceptButton]);
			//mediatorMap.mapView(CancelButton, CancelButtonMediator, [ButtonBase, CancelButton]);
			mediatorMap.mapView(ShadowBoxView, ShadowBoxMediator);
			mediatorMap.mapView(TransparentSpinner, TransparentSpinnerMediator);
			
			
			//other
			contextView.stage.addEventListener(Event.RESIZE, appResizeHandler);
			Starling.current.nativeStage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler);
			
			
			//finally
			//super.startup();
			
			
			appResizeHandler(new ResizeEvent(ResizeEvent.RESIZE, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight)); //hmm
		}
		
		protected function appResizeHandler(event:ResizeEvent = null):void
		{
			trace("RESIZE. " + event.width, event.height); 
			
			contextView.stage.stageWidth = event.width;
			contextView.stage.stageHeight = event.height;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, event.width, event.height), 
				new Rectangle(0, 0, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight), 
				"showAll");
			
			Starling.current.viewPort = viewPort;
			
			if( ! _init ) { 
				_init = true;
				
				//finally
				super.startup();
				
				eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.RESIZE));
			}
		}
		
		protected function orientationChangeHandler(event:StageOrientationEvent):void
		{
			trace("ORIENTATION CHANGE. " + event.beforeOrientation + " to " + event.afterOrientation);
			
			eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.ORIENTATION_CHANGE)); //, false, {"beforeOrientation":event.beforeOrientation, "afterOrientation":event.afterOrientation}));
		}
	}
}