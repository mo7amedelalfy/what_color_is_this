package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class ConfirmColorPage extends PageBase
	{
		public var backButton:Button;
		public var colorList:List;
		
		public function ConfirmColorPage()
		{
			backButton = new Button();
			
			super();	
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			
		}
		
		public function reset():void
		{
			removeDrawnVector(colorList);
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void
		{
			trace("confirm color page drawing vectors");
			
			//Remove first
			removeDrawnVector( _background );
			removeDrawnVector( colorList );
			
			
			//Create
			_background = drawBackgroundQuad();
			colorList = new List();
			
			
			//Now add
			addChildAt(_background, 0);
			addChild(colorList);
			
			
			//Settings
			backButton.label = "Back";
			
			colorList.x = 0;
			colorList.y = layoutModel.navBarHeight/Starling.contentScaleFactor;
			colorList.width = layoutModel.appWidth;
			colorList.height = layoutModel.appHeight - colorList.y;
			
			var options:ListCollection = new ListCollection();
			for( var i:uint = 0; i < cameraModel.top5.length; i++ ) { 
				options.push({text:"0x"+ cameraModel.top5[i], hex:cameraModel.top5[i]});
			}
			
			colorList.dataProvider = options;
			
			colorList.itemRendererProperties.labelField = "text";
			
			colorList.scrollerProperties.hasElasticEdges = true;
			
			colorList.isSelectable = true;
			
			colorList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.iconFunction = function( item:Object ):DisplayObject {
					return new Quad((200 * layoutModel.scale) * Starling.contentScaleFactor, (200 * layoutModel.scale) * Starling.contentScaleFactor, uint("0x"+item.hex));
				};
				
				return renderer;
			};
		}
	}
}