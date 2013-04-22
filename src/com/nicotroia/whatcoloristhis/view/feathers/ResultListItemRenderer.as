package com.nicotroia.whatcoloristhis.view.feathers
{
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.skins.Scale9ImageStateValueSelector;
	
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class ResultListItemRenderer extends DefaultListItemRenderer //Button implements IListItemRenderer
	{
		protected var _nameLabel:Label;
		protected var _descriptionLabel:Label;
		protected var _nameLabelTextFormat:TextFormat;
		protected var _descriptionLabelTextFormat:TextFormat;
		protected var _title:String;
		protected var _description:String;
		protected var _titleFunction:Function;
		protected var _descriptionFunction:Function;
		
		public function ResultListItemRenderer()
		{
			
		}
		
		public function get title():String { return this._title; }
		
		public function set title(value:String):void
		{
			if(this._title == value)
			{
				return;
			}
			this._title = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get titleFunction():Function { return this._titleFunction; }
		
		public function set titleFunction(value:Function):void
		{
			if(this._titleFunction == value)
			{
				return;
			}
			this._titleFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get description():String { return this._description; }
		
		public function set description(value:String):void
		{
			if( this._description == value ) return;
			
			this._description = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get descriptionFunction():Function { return this._descriptionFunction; }
		
		public function set descriptionFunction(value:Function):void
		{
			if(this._descriptionFunction == value)
			{
				return;
			}
			this._descriptionFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get nameLabelTextFormat():TextFormat { return this._nameLabelTextFormat; }
		
		public function set nameLabelTextFormat(value:TextFormat):void { this._nameLabelTextFormat = value; }
		
		public function get descriptionLabelTextFormat():TextFormat { return this._descriptionLabelTextFormat; }
		
		public function set descriptionLabelTextFormat(value:TextFormat):void { this._descriptionLabelTextFormat = value; }
		
		override protected function initialize():void
		{
			if( ! this._nameLabel) {
				this._nameLabel = new Label();
				this.addChild(this._nameLabel);
			}
			
			if( ! this._descriptionLabel ) { 
				this._descriptionLabel = new Label();
				this.addChild(this._descriptionLabel);
			}
		}
		
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			this._nameLabel.width = NaN;
			this._nameLabel.height = NaN;
			this._nameLabel.validate();
			
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = this.owner.width; //this._itemLabel.width;
			}
			
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				var iconHeight:Number = this.paddingTop + this.currentIcon.height + this.paddingBottom;
				var textHeight:Number = this.paddingTop + this._nameLabel.height + this.gap + this._descriptionLabel.height + this.paddingBottom;
				newHeight = Math.max(iconHeight, textHeight);
			}
			
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		override public function itemToLabel(item:Object):String
		{
			//no label
			return "";
		}
		
		override protected function commitData():void
		{
			//trace("resultListItemRenderer commitData");
			super.commitData();
			
			if( this._titleFunction ) this._title = this._titleFunction(this._data); 
			if( this._title ) { 
				this._nameLabel.text = this._title;
			}
			else { 
				this._nameLabel.text = "";
			}
			
			if( this._descriptionFunction ) this._description = this._descriptionFunction(this._data);
			if( this._description ) { 
				this._descriptionLabel.text = this._description;
			}
			else { 
				this._descriptionLabel.text = "";
			}
		}
		
		override protected function layoutContent():void
		{
			//trace("resultListItemRenderer layout");
			
			super.layoutContent();
			
			this._nameLabel.x = this.paddingLeft + this.currentIcon.width + this.gap;
			this._nameLabel.y = this.paddingTop;
			this._nameLabel.width = this.actualWidth - this._nameLabel.x - this.paddingRight;
			//this._nameLabel.height = (20 * Starling.contentScaleFactor);
			this._nameLabel.textRendererProperties.embedFonts = true;
			this._nameLabel.textRendererProperties.wordWrap = false;
			this._nameLabel.textRendererProperties.textFormat = _nameLabelTextFormat
			
			this._descriptionLabel.x = this.paddingLeft + this.currentIcon.width + this.gap;
			this._descriptionLabel.y = this.paddingTop + (this.currentIcon.height * 0.5); // + this.gap;
			this._descriptionLabel.width = this.actualWidth - this._nameLabel.x - this.paddingRight; //labelWidth;
			//this._descriptionLabel.height = (20 * Starling.contentScaleFactor);
			this._descriptionLabel.textRendererProperties.embedFonts = false;
			this._descriptionLabel.textRendererProperties.wordWrap = true;
			this._descriptionLabel.textRendererProperties.textFormat = _descriptionLabelTextFormat;
		}
	}
}