package com.nicotroia.whatcoloristhis
{
	import com.nicotroia.whatcoloristhis.controller.commands.AddTextToLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.GotoPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.HideLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ImageSelectFailedCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ImageSelectedCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.LayoutPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ResizeAppCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ShowLoadingSpinnerCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.StartupAnimationCommand;
	import com.nicotroia.whatcoloristhis.controller.events.CameraEvent;
	import com.nicotroia.whatcoloristhis.controller.events.LoadingEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	import com.nicotroia.whatcoloristhis.view.buttons.AboutPageButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.AcceptButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.BackButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBase;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBaseMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.CancelButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.NavBarMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.TakePhotoButtonMediator;
	import com.nicotroia.whatcoloristhis.view.overlay.ShadowBoxMediator;
	import com.nicotroia.whatcoloristhis.view.overlay.ShadowBoxView;
	import com.nicotroia.whatcoloristhis.view.overlay.TransparentSpinnerMediator;
	import com.nicotroia.whatcoloristhis.view.pages.AboutPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.AreaSelectPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	import com.nicotroia.whatcoloristhis.view.pages.PageBaseMediator;
	import com.nicotroia.whatcoloristhis.view.pages.ResultPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.WelcomePageMediator;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	public class ColorContext extends Context
	{
		public var pageContainer:Sprite;
		public var overlayContainer:Sprite;
		public var backgroundSprite:Sprite;
		public var loadingSpinner:TransparentSpinner;
		public var shadowBox:ShadowBoxView;
		
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
			commandMap.mapEvent(Event.RESIZE, LayoutPageCommand, Event);
			commandMap.mapEvent(StageOrientationEvent.ORIENTATION_CHANGE, LayoutPageCommand, StageOrientationEvent);
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
			mediatorMap.mapView(WelcomePage, WelcomePageMediator, [PageBase, WelcomePage]);
			mediatorMap.mapView(AboutPage, AboutPageMediator, [PageBase, AboutPage]);
			mediatorMap.mapView(AreaSelectPage, AreaSelectPageMediator, [PageBase, AreaSelectPage]);
			mediatorMap.mapView(ResultPage, ResultPageMediator, [PageBase, ResultPage]);
			
			
			//buttons
			mediatorMap.mapView(ButtonBase, ButtonBaseMediator);
			mediatorMap.mapView(NavBar, NavBarMediator, [ButtonBase, NavBar]);
			mediatorMap.mapView(BackButton, BackButtonMediator, [ButtonBase, BackButton]);
			mediatorMap.mapView(TakePhotoButton, TakePhotoButtonMediator, [ButtonBase, TakePhotoButton]);
			mediatorMap.mapView(AboutPageButton, AboutPageButtonMediator, [ButtonBase, AboutPageButton]);
			mediatorMap.mapView(AcceptButton, AcceptButtonMediator, [ButtonBase, AcceptButton]);
			mediatorMap.mapView(CancelButton, CancelButtonMediator, [ButtonBase, CancelButton]);
			mediatorMap.mapView(ShadowBoxView, ShadowBoxMediator);
			mediatorMap.mapView(TransparentSpinner, TransparentSpinnerMediator);
			
			
			//other
			contextView.stage.addEventListener(Event.RESIZE, appResizeHandler);
			contextView.stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeHandler);
			
			
			//finally
			super.startup();
			
			eventDispatcher.dispatchEvent(new Event(Event.RESIZE)); //hmm
		}
		
		protected function orientationChangeHandler(event:StageOrientationEvent):void
		{
			//event.preventDefault();
			
			trace("ORIENTATION CHANGE. " + event.beforeOrientation + " to " + event.afterOrientation);
			
			eventDispatcher.dispatchEvent(event);
		}
		
		protected function appResizeHandler(event:Event):void
		{
			//We really only need this to happen once...
			contextView.stage.removeEventListener(Event.RESIZE, appResizeHandler);
			
			//event.preventDefault();
			
			trace("RESIZE. " + contextView.stage.stageWidth, contextView.stage.stageHeight + " full: " + contextView.stage.fullScreenWidth, contextView.stage.fullScreenHeight);
			
			eventDispatcher.dispatchEvent(event);
		}
	}
}