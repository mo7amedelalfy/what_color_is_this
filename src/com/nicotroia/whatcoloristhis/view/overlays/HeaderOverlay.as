package com.nicotroia.whatcoloristhis.view.overlays
{
	import com.nicotroia.whatcoloristhis.view.feathers.WhatColorIsThisTheme;
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	
	import feathers.controls.Header;
	
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class HeaderOverlay extends PageBase
	{
		public var header:Header;
		
		private var _textFormat:TextFormat;
		
		public function HeaderOverlay()
		{
			_textFormat = new TextFormat();
			
			header = new Header();
			header.leftItems = new <DisplayObject>[];
			header.rightItems = new <DisplayObject>[];
			header.titleProperties.htmlText = true;
			
			super();
		}
		
		public function changeTitle(title:String):void
		{
			header.titleProperties.htmlText = true;
			header.title = title;
			header.validate();
			//header.titleProperties.textFormat = _textFormat;
		}
		
		public function addButtonToLeft(button:DisplayObject):void
		{
			//trace("adding button to left");
			header.leftItems = new <DisplayObject>[button];
			
			TweenLite.from(button, 0.33, {alpha:0, ease:Circ.easeInOut});
		}
		
		public function addButtonToRight(button:DisplayObject):void
		{
			//trace("adding button to right");
			header.rightItems = new <DisplayObject>[button];
			
			TweenLite.from(button, 0.33, {alpha:0, ease:Circ.easeInOut});
		}
		
		public function removeButtons():void
		{
			//trace("removing all buttons");
			if( header.leftItems && header.leftItems.length ) header.leftItems = new Vector.<DisplayObject>();
			if( header.rightItems && header.rightItems.length ) header.rightItems = new Vector.<DisplayObject>();
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void 
		{ 
			_textFormat.font = layoutModel.infoDispBold.fontName;
			_textFormat.size = uint(36 * layoutModel.scale);
			_textFormat.color = 0xffffff;
			
			//trace("header overlay drawing vectors");
			
			//Remove first
			//removeDrawnVector( header );
			
			//Make things
			
			
			//Add
			addChild( header );
			
			//Settings
			header.titleProperties.isHTML = true;
			header.title = "";
			header.titleProperties.textFormat = _textFormat;
			header.width = layoutModel.appWidth;
			header.height = layoutModel.navBarHeight;
		}
		
		/*
		override protected function removedFromStageHandler(event:Event):void
		{
			super.removedFromStageHandler(event);
			
			if( header.leftItems && header.leftItems.length ) header.leftItems = new Vector.<DisplayObject>();
			if( header.rightItems && header.rightItems.length ) header.rightItems = new Vector.<DisplayObject>();
			
			removeDrawnVector( header );
		}
		*/
	}
}