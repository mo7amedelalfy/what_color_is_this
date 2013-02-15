package com.nicotroia.whatcoloristhis
{
	import com.nicotroia.whatcoloristhis.controller.commands.GotoPageCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.ResizeAppCommand;
	import com.nicotroia.whatcoloristhis.controller.commands.StartupAnimationCommand;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.SequenceModel;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBase;
	import com.nicotroia.whatcoloristhis.view.buttons.ButtonBaseMediator;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	import com.nicotroia.whatcoloristhis.view.pages.PageBaseMediator;
	
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
			
			
			//buttons
			mediatorMap.mapView(ButtonBase, ButtonBaseMediator);
			
			
			contextView.stage.addEventListener(Event.RESIZE, appResizeHandler);
			
			super.startup();
		}
		
		protected function appResizeHandler(event:Event):void
		{
			commandMap.execute(ResizeAppCommand, event, Event);
		}
	}
}