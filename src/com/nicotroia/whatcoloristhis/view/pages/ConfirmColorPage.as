package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.ColorNode;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;

	public class ConfirmColorPage extends PageBase
	{
		public var backButton:Button;
		public var colorList:List;
		
		private var _orderTitleImage:Image;
		private var _orderTitleTextFormat:TextFormat;
		
		public function ConfirmColorPage()
		{
			vectorPage = new ConfirmColorPageVector();
			backButton = new Button();
			_orderTitleTextFormat = new TextFormat();
			
			super();	
		}
		
		public function setTextFormat(layoutModel:LayoutModel):void
		{
			_orderTitleTextFormat.font = layoutModel.infoDispMedium.fontName;
			_orderTitleTextFormat.size = (30 * layoutModel.scale);
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			setTextFormat(layoutModel);
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			vectorPage.orderTitle.x = 0;
			vectorPage.orderTitle.y = (layoutModel.navBarHeight/Starling.contentScaleFactor) - (3 * layoutModel.scale * Starling.contentScaleFactor);
			
			vectorPage.orderTitle.bar.width = layoutModel.appWidth + 4;
			vectorPage.orderTitle.bar.height = 50 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.orderTitle.bar.x = -2;
			vectorPage.orderTitle.bar.y = 0;
			
			vectorPage.orderTitle.labelTF.width = layoutModel.appWidth;
			vectorPage.orderTitle.labelTF.height = 50 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.orderTitle.labelTF.x = 0;
			vectorPage.orderTitle.labelTF.y = 10 * layoutModel.scale * Starling.contentScaleFactor;
			
			vectorPage.orderTitle.labelTF.text = "The most frequent colors are at the top."; 
			vectorPage.orderTitle.labelTF.setTextFormat( _orderTitleTextFormat );
		}
		
		public function reset():void
		{
			//removeDrawnVector(colorList);
			if( colorList.dataProvider ) { 
				colorList.selectedItem = null;
				colorList.validate();
			}
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void
		{
			trace("confirm color page drawing vectors");
			
			//Remove first
			removeDrawnVector( _background );
			removeDrawnVector( colorList );
			removeDrawnVector( _orderTitleImage );
			
			
			//Create
			_background = drawBackgroundQuad();
			colorList = new List();
			_orderTitleImage = createImageFromDisplayObject( vectorPage.orderTitle );
			
			
			//Now add
			addChildAt(_background, 0);
			addChild(colorList);
			addChild(_orderTitleImage);
			
			
			//Settings
			backButton.label = "Back";
			
			colorList.x = 0;
			colorList.y = vectorPage.orderTitle.y + vectorPage.orderTitle.bar.height;
			colorList.width = layoutModel.appWidth;
			colorList.height = layoutModel.appHeight - colorList.y;
		}
		
		public function drawConfirmationColors(layoutModel:LayoutModel, cameraModel:CameraModel):void
		{
			var options:ListCollection = new ListCollection();
			var node:ColorNode = cameraModel.top5.head;
			while( node ) { 
				options.push({text:"0x"+ node.data, hex:node.data});
				node = node.next;
			}
			
			colorList.dataProvider = options;
			
			colorList.itemRendererProperties.labelField = "text";
			colorList.itemRendererProperties.paddingTop = colorList.itemRendererProperties.paddingBottom = 12 * Assets.roundedScaleFactor;
			colorList.itemRendererProperties.paddingRight = colorList.itemRendererProperties.paddingLeft = 12 * Assets.roundedScaleFactor;
			colorList.itemRendererProperties.gap = 14 * Assets.roundedScaleFactor;
			
			colorList.scrollerProperties.hasElasticEdges = true;
			
			colorList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.iconFunction = function( item:Object ):DisplayObject {
					return new Quad((140 * layoutModel.scale) * Starling.contentScaleFactor, (140 * layoutModel.scale) * Starling.contentScaleFactor, uint("0x"+item.hex));
				};
				
				return renderer;
			};
			
			colorList.isSelectable = true;
		}
	}
}