package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class SettingsPage extends PageBase
	{
		public var backButton:Button;
		public var fetchCrayolaToggle:ToggleSwitch;
		public var fetchPantoneToggle:ToggleSwitch;
		
		private var _settingsList:List;
		private var _textFormat:TextFormat;
		
		public function SettingsPage()
		{
			backButton = new Button();
			_textFormat = new TextFormat();
			
			super();
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void 
		{ 
			_textFormat.font = layoutModel.infoDispBold.fontName;
			_textFormat.size = uint(36 * layoutModel.scale);
			_textFormat.color = 0xffffff;
			
			trace("settings page drawing vectors");
			
			removeDrawnVector(fetchCrayolaToggle);
			removeDrawnVector(fetchPantoneToggle);
			removeDrawnVector(_settingsList);
			
			fetchCrayolaToggle = new ToggleSwitch();
			fetchPantoneToggle = new ToggleSwitch();
			_settingsList = new List();
			
			addChild(_settingsList);
			
			//Settings
			backButton.label = "Done";
			
			_settingsList.x = 0;
			_settingsList.y = (88 * layoutModel.scale);
			_settingsList.width = layoutModel.appWidth;
			_settingsList.height = layoutModel.appHeight - (88 * layoutModel.scale);
			
			var groceryList:ListCollection = new ListCollection([
				{ text: "Results will include Crayola colors", accessory: fetchCrayolaToggle, isSelected:Settings.fetchCrayolaResults }, 
				{ text: "Results will include Pantone colors", accessory: fetchPantoneToggle, isSelected:Settings.fetchPantoneResults }, 
			]);
			
			_settingsList.dataProvider = groceryList;
			
			_settingsList.itemRendererProperties.labelField = "text";
			_settingsList.itemRendererProperties.accessoryField = "accessory";
			
			_settingsList.scrollerProperties.hasElasticEdges = true;
			
			_settingsList.isSelectable = false;
			
			_settingsList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.accessoryFunction = function( item:Object ):DisplayObject { 
					var toggle:ToggleSwitch = item.accessory;
					
					toggle.isSelected = item.isSelected;
					
					return toggle;
				};
				
				return renderer;
			};
			
		}
	}
}