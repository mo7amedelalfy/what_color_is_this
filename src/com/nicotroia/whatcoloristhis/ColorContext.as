package com.nicotroia.whatcoloristhis
{
	import com.distriqt.extension.applicationrater.ApplicationRater;
	import com.distriqt.extension.applicationrater.events.ApplicationRaterEvent;
	import com.nicotroia.whatcoloristhis.controller.commands.AddTextToLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.GotoPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.HideDisplayListLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.HideLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ImageSelectFailedCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ImageSelectedCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.InitApplicationRaterCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.LayoutPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.LoadSettingsCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.SaveFavoritesCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.SaveSettingsCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.SendErrorsToServerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ShowDisplayListLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ShowLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.StartupAnimationCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.WriteErrorToFileCommand;
	import com.nicotroia.whatcoloristhis.controller.events.CameraEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LayoutEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.ColorModel;
	import com.nicotroia.whatcoloristhis.model.ErrorModel;
	import com.nicotroia.whatcoloristhis.model.FavoritesModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	import com.nicotroia.whatcoloristhis.model.SettingsModel;
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
	import com.nicotroia.whatcoloristhis.view.overlays.TransparentSpinner;
	import com.nicotroia.whatcoloristhis.view.overlays.TransparentSpinnerMediator;
	import com.nicotroia.whatcoloristhis.view.pages.AboutPage;
	import com.nicotroia.whatcoloristhis.view.pages.AboutPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.AreaSelectPage;
	import com.nicotroia.whatcoloristhis.view.pages.AreaSelectPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.ConfirmColorPage;
	import com.nicotroia.whatcoloristhis.view.pages.ConfirmColorPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.FavoritesPage;
	import com.nicotroia.whatcoloristhis.view.pages.FavoritesPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	import com.nicotroia.whatcoloristhis.view.pages.PageBaseMediator;
	import com.nicotroia.whatcoloristhis.view.pages.ResultPage;
	import com.nicotroia.whatcoloristhis.view.pages.ResultPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.SettingsPage;
	import com.nicotroia.whatcoloristhis.view.pages.SettingsPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.SuggestionPage;
	import com.nicotroia.whatcoloristhis.view.pages.SuggestionPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.WelcomePage;
	import com.nicotroia.whatcoloristhis.view.pages.WelcomePageMediator;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
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
		public var shadowBox:ShadowBoxView;
		public var loadingSpinner:TransparentSpinner;
		public var loadingSpinnerVector:TransparentSpinnerVector;
		public var colorSpectrum:Bitmap;
		
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
			injector.mapSingleton(SettingsModel);
			injector.mapSingleton(ColorModel);
			injector.mapSingleton(FavoritesModel);
			injector.mapSingleton(ErrorModel);
			injector.mapValue(DisplayObjectContainer, contextView, "contextView");
			
			
			//graphics
			injector.mapValue(Stage, Starling.current.nativeStage);
			
			pageContainer = new Sprite();
			injector.mapValue(Sprite, pageContainer, "pageContainer");
			
			overlayContainer = new Sprite();
			injector.mapValue(Sprite, overlayContainer, "overlayContainer");
			
			backgroundSprite = new Sprite();
			injector.mapValue(Sprite, backgroundSprite, "backgroundSprite");
			
			shadowBox = new ShadowBoxView(contextView.stage.stageWidth, contextView.stage.stageHeight);
			injector.mapValue(ShadowBoxView, shadowBox);
			
			loadingSpinner = new TransparentSpinner();
			injector.mapValue(TransparentSpinner, loadingSpinner);
			
			loadingSpinnerVector = new TransparentSpinnerVector();
			injector.mapValue(TransparentSpinnerVector, loadingSpinnerVector);
			
			colorSpectrum = new Assets.SpectrumChart() as Bitmap;
			injector.mapValue(Bitmap, colorSpectrum, "colorSpectrum");
			
			
			//startup chain
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadSettingsCommand, ContextEvent);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupAnimationCommand, ContextEvent);
			//commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, InitApplicationRaterCommand, ContextEvent);
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, SendErrorsToServerCommand, ContextEvent); //hopefully crash errors will be recorded and sent on the following startup
			
			//events
			commandMap.mapEvent(LayoutEvent.RESIZE, LayoutPageCommand, LayoutEvent);
			commandMap.mapEvent(LayoutEvent.ORIENTATION_CHANGE, LayoutPageCommand, LayoutEvent);
			commandMap.mapEvent(NavigationEvent.NAVIGATE_TO_PAGE, GotoPageCommand, NavigationEvent);
			commandMap.mapEvent(CameraEvent.CAMERA_IMAGE_TAKEN, ImageSelectedCommand, CameraEvent);
			commandMap.mapEvent(CameraEvent.CAMERA_IMAGE_FAILED, ImageSelectFailedCommand, CameraEvent);
			commandMap.mapEvent(CameraEvent.CAMERA_ROLL_IMAGE_SELECTED, ImageSelectedCommand, CameraEvent);
			commandMap.mapEvent(CameraEvent.CAMERA_ROLL_IMAGE_FAILED, ImageSelectFailedCommand, CameraEvent);
			commandMap.mapEvent(LoadingEvent.PAGE_LOADING, ShowLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(LoadingEvent.CAMERA_LOADING, ShowDisplayListLoadingSpinnerCommand, LoadingEvent);
			//commandMap.mapEvent(LoadingEvent.CAMERA_LOADING, ShowLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(LoadingEvent.CAMERA_ROLL_LOADING, ShowDisplayListLoadingSpinnerCommand, LoadingEvent);
			//commandMap.mapEvent(LoadingEvent.CAMERA_ROLL_LOADING, ShowLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(LoadingEvent.COUNTING_PIXELS, ShowLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(LoadingEvent.COLOR_RESULT_LOADING, ShowLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(LoadingEvent.LOADING_FINISHED, HideLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(LoadingEvent.LOADING_FINISHED, HideDisplayListLoadingSpinnerCommand, LoadingEvent);
			commandMap.mapEvent(NotificationEvent.ADD_TEXT_TO_LOADING_SPINNER, AddTextToLoadingSpinnerCommand, NotificationEvent);
			commandMap.mapEvent(NavigationEvent.SETTINGS_PAGE_CONFIRMED, SaveSettingsCommand, NavigationEvent);
			commandMap.mapEvent(NavigationEvent.FAVORITE_COLOR_CONFIRMED, SaveFavoritesCommand, NavigationEvent);
			commandMap.mapEvent(NotificationEvent.UNCAUGHT_ERROR_OCCURRED, WriteErrorToFileCommand, NotificationEvent);
			commandMap.mapEvent(NotificationEvent.UNCAUGHT_ERROR_OCCURRED, SendErrorsToServerCommand, NotificationEvent);
			
			
			//pages
			//If you'd like mediators to be created automatically, 
			//but not to be removed when the view leaves the stage, 
			//set autoRemove to false, but be sure to remove the mediator when you no longer need it.
			mediatorMap.mapView(PageBase, PageBaseMediator, null, true, false);
			mediatorMap.mapView(HeaderOverlay, HeaderOverlayMediator, [PageBase, HeaderOverlay], true, false);
			mediatorMap.mapView(WelcomePage, WelcomePageMediator, [PageBase, WelcomePage], true, false);
			mediatorMap.mapView(SettingsPage, SettingsPageMediator, [PageBase, SettingsPage], true, false);
			mediatorMap.mapView(AboutPage, AboutPageMediator, [PageBase, AboutPage], true, false);
			mediatorMap.mapView(AreaSelectPage, AreaSelectPageMediator, [PageBase, AreaSelectPage], true, false);
			mediatorMap.mapView(ConfirmColorPage, ConfirmColorPageMediator, [PageBase, ConfirmColorPage], true, false);
			mediatorMap.mapView(ResultPage, ResultPageMediator, [PageBase, ResultPage], true, false);
			mediatorMap.mapView(SuggestionPage, SuggestionPageMediator, [PageBase, SuggestionPage], true, false);
			mediatorMap.mapView(FavoritesPage, FavoritesPageMediator, [PageBase, FavoritesPage], true, false);
			
			
			//buttons
			mediatorMap.mapView(ButtonBase, ButtonBaseMediator);
			mediatorMap.mapView(ShadowBoxView, ShadowBoxMediator);
			mediatorMap.mapView(TransparentSpinner, TransparentSpinnerMediator);
			
			
			//other
			contextView.stage.addEventListener(Event.RESIZE, appResizeHandler);
			Starling.current.nativeStage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler);
			
			
			//finally
			//super.startup();
			appResizeHandler(new ResizeEvent(ResizeEvent.RESIZE, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight)); //hmm
		}
		
		public function handleGlobalError(message:String):void
		{
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.UNCAUGHT_ERROR_OCCURRED, message));
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