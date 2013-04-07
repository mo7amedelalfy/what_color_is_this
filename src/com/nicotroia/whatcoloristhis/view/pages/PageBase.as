package com.nicotroia.whatcoloristhis.view.pages
{
	import com.feathers.themes.WhatColorIsThisTheme;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quart;
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.controller.events.NavigationEvent;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class PageBase extends Sprite
	{
		public var vectorPage:MovieClip;
		public var reflowed:Boolean;
		
		protected var _feathersTheme:WhatColorIsThisTheme;
		protected var _background:Quad;
		
		public function PageBase()
		{
			this.alpha = 0.0;
			this._feathersTheme = new WhatColorIsThisTheme(this, true);
			
			//this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			//trace("pagebase added to stage");
			//this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			//override
		}
		
		public function reflowVectors(layoutModel:LayoutModel = null, cameraModel:CameraModel = null):void
		{
			
		}
		
		public function drawVectors(layoutModel:LayoutModel = null, cameraModel:CameraModel = null):void
		{
			
		}
		
		protected function createImageFromDisplayObject(target:flash.display.DisplayObject):Image
		{
			var bmd:BitmapData = drawVector(target);
			
			var image:Image = Image.fromBitmap(new Bitmap(bmd), true, Starling.contentScaleFactor); //Assets.scaleFactor);
			image.x = target.x;
			image.y = target.y;
			
			return image;
		}
		
		protected function createButtonFromMovieClip(target:flash.display.MovieClip):Button
		{
			target.gotoAndStop(1);
			
			var upBmd:BitmapData = drawVector(target);
			var upTexture:Texture = Texture.fromBitmapData(upBmd, true, false, Starling.contentScaleFactor); //Assets.scaleFactor);
			
			var button:Button = new Button(upTexture);
			button.alphaWhenDisabled = 0.5;
			button.scaleWhenDown = 0.9;
			button.x = target.x;
			button.y = target.y;
			
			if ( target.totalFrames >= 2 ) { 
				target.gotoAndStop(2);
				
				var downBmd:BitmapData = drawVector(target);
				var downTexture:Texture = Texture.fromBitmapData(downBmd, true, false, Starling.contentScaleFactor); //Assets.scaleFactor);
				
				button.downState = downTexture;
				button.scaleWhenDown = 1;
			}
			
			return button;
		}
		
		protected function drawVector(target:flash.display.DisplayObject):BitmapData
		{
			var bounds:Rectangle = target.getBounds(Starling.current.nativeStage);
			var bmd:BitmapData = new BitmapData(bounds.width + 4, bounds.height + 4, true, 0);
			
			bmd.drawWithQuality(target, 
				new Matrix(target.transform.matrix.a, 0, 0, target.transform.matrix.d, 2, 2),
				null, null, null, true, StageQuality.HIGH);
			
			return bmd;
		}
		
		protected function drawBackgroundQuad(color:uint = 0xf5f5f5):Quad
		{
			this._background = new Quad(Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight, color);
			
			return this._background;
		}
		
		public function show(durationSec:Number = 0.5, delaySec:Number = 0, direction:String = "NavigateRight", callBack:Function = null):void
		{
			if( direction == NavigationEvent.NAVIGATE_RIGHT ) { 
				this.x = stage.stageWidth;
			}
			else { 
				this.x = -stage.stageWidth;
			}
			TweenLite.to(this, durationSec, {alpha:1.0, x:0, delay:delaySec, ease:Quart.easeInOut, onComplete:callBack });
		}
		
		public function hide(durationSec:Number = 0.5, delaySec:Number = 0, direction:String = "NavigateRight", callBack:Function = null):void
		{
			var targetX:Number;
			if( direction == NavigationEvent.NAVIGATE_RIGHT ) { 
				targetX = -stage.stageWidth;
			}
			else { 
				targetX = stage.stageWidth;
			}
			TweenLite.to(this, durationSec, {alpha:0.0, x:targetX, delay:delaySec, ease:Quart.easeInOut, onComplete:callBack });			
		}
		
		protected function removeDrawnVector(target:DisplayObject):void
		{
			if( target ) { 
				//trace(" removed " + target);
				if( target.parent ) target.parent.removeChild(target);
				target.dispose();
			}
		}
		
		protected function stretchImage(img:Image, horizontally:int, vertically:int):void {
			img.setTexCoords(1, new Point(horizontally, 0));
			img.setTexCoords(2, new Point(0, vertically));
			img.setTexCoords(3, new Point(horizontally, vertically));
		}
		
		protected function removedFromStageHandler(event:Event):void
		{
			//pages will never need to remove everything
			
			//trace("pagebase removed from stage");
			
			//this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			//this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			//override
		}
	}
}