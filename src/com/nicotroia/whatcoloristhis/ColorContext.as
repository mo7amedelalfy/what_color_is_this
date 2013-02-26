package com.nicotroia.whatcoloristhis
{
	import com.nicotroia.whatcoloristhis.controller.commands.GotoPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.LayoutPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ResizeAppCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.StartupAnimationCommand;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	import com.nicotroia.whatcoloristhis.view.buttons.AboutPageButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.BackButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBase;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBaseMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.NavBarMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.TakePhotoButtonMediator;
	import com.nicotroia.whatcoloristhis.view.pages.AboutPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	import com.nicotroia.whatcoloristhis.view.pages.PageBaseMediator;
	import com.nicotroia.whatcoloristhis.view.pages.ResultPageMediator;
	import com.nicotroia.whatcoloristhis.view.pages.WelcomePageMediator;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	public class ColorContext extends Context
	{
		public var pageContainer:Sprite;
		public var overlayContainer:Sprite;
		public var backgroundSprite:Sprite;
		
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
			
			
			//startup chain
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupAnimationCommand, ContextEvent);
			
			
			//events
			commandMap.mapEvent(NavigationEvent.NAVIGATE_TO_PAGE, GotoPageCommand, NavigationEvent);
			commandMap.mapEvent(Event.RESIZE, LayoutPageCommand);
			
			
			//pages
			mediatorMap.mapView(PageBase, PageBaseMediator);
			mediatorMap.mapView(WelcomePage, WelcomePageMediator, [PageBase, WelcomePage]);
			mediatorMap.mapView(AboutPage, AboutPageMediator, [PageBase, AboutPage]);
			mediatorMap.mapView(ResultPage, ResultPageMediator, [PageBase, ResultPage]);
			
			
			//buttons
			mediatorMap.mapView(ButtonBase, ButtonBaseMediator);
			mediatorMap.mapView(NavBar, NavBarMediator, [ButtonBase, NavBar]);
			mediatorMap.mapView(BackButton, BackButtonMediator, [ButtonBase, BackButton]);
			mediatorMap.mapView(TakePhotoButton, TakePhotoButtonMediator, [ButtonBase, TakePhotoButton]);
			mediatorMap.mapView(AboutPageButton, AboutPageButtonMediator, [ButtonBase, AboutPageButton]);
			
			
			contextView.stage.addEventListener(Event.RESIZE, appResizeHandler);
			
			super.startup();
		}
		
		protected function appResizeHandler(event:Event):void
		{
			event.preventDefault();
			
			//trace("resize. " + contextView.stage.stageWidth, contextView.stage.stageHeight);
			
			eventDispatcher.dispatchEvent(event);
			//eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.APP_RESIZED));
		}
	}
}