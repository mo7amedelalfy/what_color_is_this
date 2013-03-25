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
			removeDrawnVector( colorList );
			
			
			//Create
			colorList = new List();
			
			
			//Now add
			addChild(colorList);
			
			
			//Settings
			backButton.label = "Back";
			
			colorList.x = 0;
			colorList.y = (88 * layoutModel.scale);
			colorList.width = layoutModel.appWidth;
			colorList.height = layoutModel.appHeight - (88 * layoutModel.scale);
			
			var options:ListCollection = new ListCollection([
				{text:"0x"+ cameraModel.top5[0], hex:cameraModel.top5[0] }, 
				{text:"0x"+ cameraModel.top5[1], hex:cameraModel.top5[1] }, 
				{text:"0x"+ cameraModel.top5[2], hex:cameraModel.top5[2] }, 
				{text:"0x"+ cameraModel.top5[3], hex:cameraModel.top5[3] }, 
				{text:"0x"+ cameraModel.top5[4], hex:cameraModel.top5[4] }, 
			]);
			
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