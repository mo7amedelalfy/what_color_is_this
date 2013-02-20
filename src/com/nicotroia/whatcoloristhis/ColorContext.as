package com.nicotroia.whatcoloristhis
{
	import com.nicotroia.whatcoloristhis.controller.commands.GotoPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ResizeAppCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.StartupAnimationCommand;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.controller.events.NotificationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBase;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBaseMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.ChooseExistingButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.TakePhotoButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.AboutPageButtonMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.TopNavBarMediator;
	import com.nicotroia.whatcoloristhis.view.buttons.WelcomePageButtonMediator;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	import com.nicotroia.whatcoloristhis.view.pages.PageBaseMediator;
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
			
			
			//pages
			mediatorMap.mapView(PageBase, PageBaseMediator);
			mediatorMap.mapView(WelcomePage, WelcomePageMediator, [PageBase, WelcomePage]);
			mediatorMap.mapView(AboutPage, PageBaseMediator, [PageBase]);
			
			
			//buttons
			mediatorMap.mapView(ButtonBase, ButtonBaseMediator);
			mediatorMap.mapView(TopNavBar, TopNavBarMediator, [ButtonBase, TopNavBar]);
			mediatorMap.mapView(WelcomePageButton, WelcomePageButtonMediator, [ButtonBase, WelcomePageButton]);
			mediatorMap.mapView(TakePhotoButton, TakePhotoButtonMediator, [ButtonBase, TakePhotoButton]);
			mediatorMap.mapView(ChooseExistingButton, ChooseExistingButtonMediator, [ButtonBase, ChooseExistingButton]);
			mediatorMap.mapView(AboutPageButton, AboutPageButtonMediator, [ButtonBase, AboutPageButton]);
			
			
			contextView.stage.addEventListener(Event.RESIZE, appResizeHandler);
			
			super.startup();
		}
		
		protected function appResizeHandler(event:Event):void
		{
			//trace("resize. " + contextView.stage.stageWidth, contextView.stage.stageHeight);
			
			//commandMap.execute(ResizeAppCommand, event, Event);
			eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.APP_RESIZED));
		}
	}
}