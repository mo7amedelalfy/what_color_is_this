package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Settings;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	import com.nicotroia.whatcoloristhis.view.feathers.SettingsListItemRenderer;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.Slider;
	import feathers.controls.ToggleSwitch;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	public class SettingsPage extends PageBase
	{
		public var backButton:Button;
		public var fetchNtcToggle:ToggleSwitch;
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
			_textFormat.font = "Arial,_sans"; //layoutModel.infoDispBold.fontName;
			_textFormat.size = uint(24 * layoutModel.scale);
			_textFormat.color = 0x444444;
			
			trace("settings page drawing vectors");
			
			removeDrawnVector(_background);
			removeDrawnVector(fetchNtcToggle);
			removeDrawnVector(fetchCrayolaToggle);
			removeDrawnVector(fetchPantoneToggle);
			removeDrawnVector(numberOfChoicesSlider);
			removeDrawnVector(_settingsList);
			
			_background = drawBackgroundQuad();
			fetchNtcToggle = new ToggleSwitch();
			fetchCrayolaToggle = new ToggleSwitch();
			fetchPantoneToggle = new ToggleSwitch();
			numberOfChoicesSlider = new Slider();
			_settingsList = new List();
			
			addChildAt(_background, 0);
			addChild(_settingsList);
			
			//Settings
			backButton.label = "Done";
			
			numberOfChoicesSlider.minimum = 5;
			numberOfChoicesSlider.maximum = 50;
			numberOfChoicesSlider.step = 1;
			numberOfChoicesSlider.page = 5;
			numberOfChoicesSlider.value = Settings.colorChoicesGivenToUser;
			
			_settingsList.x = 0;
			_settingsList.y = layoutModel.navBarHeight;
			_settingsList.width = layoutModel.appWidth;
			_settingsList.height = layoutModel.appHeight - _settingsList.y;
			
			var groceryList:ListCollection = new ListCollection([
				{ text: "Results will include Crayola colors", accessory: fetchCrayolaToggle, isSelected:Settings.fetchCrayolaResults }, 
				{ text: "Results will include Pantone colors", accessory: fetchPantoneToggle, isSelected:Settings.fetchPantoneResults }, 
				{ text: "Results will include 'Name That Color'", accessory: fetchNtcToggle, isSelected:Settings.fetchNtcResults }, 
				{ text: "Color choice sensitivity:\nRaise to include more color choices", accessory: numberOfChoicesSlider, value:Settings.colorChoicesGivenToUser },
			]);
			
			_settingsList.dataProvider = groceryList;
			_settingsList.isSelectable = false;
			
			//_settingsList.scrollerProperties.hasElasticEdges = true;
			_settingsList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			
			_settingsList.itemRendererProperties.labelField = "text";
			_settingsList.itemRendererProperties.accessoryField = "accessory";
			
			_settingsList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:SettingsListItemRenderer = new SettingsListItemRenderer();
				
				renderer.accessoryFunction = function( item:Object ):DisplayObject { 
					if( item.accessory is ToggleSwitch ) { 
						var toggle:ToggleSwitch = item.accessory;
						
						toggle.isSelected = item.isSelected;
						
						return toggle;
					}
					
					if( item.accessory is Slider ) { 
						var slider:Slider = item.accessory;
						
						slider.value = item.value;
						
						return slider;
					}
					
					return item.accessory;
				};
				
				//will apply textformat in the theme init
				renderer.nameList.add("settings-list-item-renderer");

				return renderer;
			};
			
		}
	}
}