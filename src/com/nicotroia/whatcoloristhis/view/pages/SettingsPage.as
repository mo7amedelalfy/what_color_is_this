package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Slider;
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
		public var numberOfChoicesSlider:Slider;
		
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
			
			removeDrawnVector(_background);
			removeDrawnVector(fetchCrayolaToggle);
			removeDrawnVector(fetchPantoneToggle);
			removeDrawnVector(numberOfChoicesSlider);
			removeDrawnVector(_settingsList);
			
			_background = drawBackgroundQuad();
			fetchCrayolaToggle = new ToggleSwitch();
			fetchPantoneToggle = new ToggleSwitch();
			numberOfChoicesSlider = new Slider();
			_settingsList = new List();
			
			addChildAt(_background, 0);
			addChild(_settingsList);
			
			//Settings
			backButton.label = "Done";
			
			numberOfChoicesSlider.minimum = 10;
			numberOfChoicesSlider.maximum = 50;
			numberOfChoicesSlider.step = 1;
			numberOfChoicesSlider.page = 5;
			numberOfChoicesSlider.value = Settings.colorChoicesGivenToUser;
			
			_settingsList.x = 0;
			_settingsList.y = layoutModel.navBarHeight;
			_settingsList.width = layoutModel.appWidth;
			_settingsList.height = layoutModel.appHeight - _settingsList.y;
			
			var groceryList:ListCollection = new ListCollection([
				{ text: "Include Crayola color results", accessory: fetchCrayolaToggle, isSelected:Settings.fetchCrayolaResults }, 
				{ text: "Include Pantone color results", accessory: fetchPantoneToggle, isSelected:Settings.fetchPantoneResults }, 
				{ text: "Color choice sensitivity", accessory: numberOfChoicesSlider },
			]);
			
			_settingsList.dataProvider = groceryList;
			_settingsList.isSelectable = false;
			
			_settingsList.scrollerProperties.hasElasticEdges = true;
			
			_settingsList.itemRendererProperties.labelField = "text";
			_settingsList.itemRendererProperties.accessoryField = "accessory";
			
			_settingsList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.accessoryFunction = function( item:Object ):DisplayObject { 
					if( item.accessory is ToggleSwitch ) { 
						var toggle:ToggleSwitch = item.accessory;
						
						toggle.isSelected = item.isSelected;
						
						return toggle;
					}
					
					return item.accessory;
				};
				
				return renderer;
			};
			
		}
	}
}