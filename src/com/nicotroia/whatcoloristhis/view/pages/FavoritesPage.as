package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.Assets;
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.FavoritesModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class FavoritesPage extends PageBase
	{
		public var backButton:Button;
		public var favoritesList:List;
		public var accessoryDeleteButtons:Vector.<Button>;
		
		private var _pageContainer:ScrollContainer;

		private var _dataList:ListCollection;
		
		public function FavoritesPage()
		{
			//vectorPage = new FavoritesPageVector();
			
			super();
		}
		
		public function reset():void
		{
			accessoryDeleteButtons = new Vector.<Button>();
			
			if( favoritesList.dataProvider ) { 
				favoritesList.selectedItem = null;
				favoritesList.validate();
			}
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			//setupTextFormats( layoutModel );
			
			//vectorPage.x = 0;
			//vectorPage.y = 0;
			
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void
		{	
			//Remove
			removeDrawnVector( _background );
			//removeDrawnVector( _pageContainer );
			removeDrawnVector( favoritesList );
			
			
			//Create
			_background = drawBackgroundQuad();
			//_pageContainer = new ScrollContainer();
			favoritesList = new List();
			backButton = new Button();
			
			
			//Add
			addChildAt( _background, 0 );
			//addChild( _pageContainer );
			addChild( favoritesList );
			
			
			//Settings
			backButton.label = "Back";
			
			
			//Favorites List
			favoritesList.x = 0;
			favoritesList.y = (layoutModel.navBarHeight/Starling.contentScaleFactor);
			favoritesList.width = layoutModel.appWidth;
			favoritesList.height = layoutModel.appHeight - favoritesList.y;
			
			//
			
			favoritesList.itemRendererProperties.labelField = "text";
			favoritesList.itemRendererProperties.paddingTop = favoritesList.itemRendererProperties.paddingBottom = 12 * Assets.roundedScaleFactor;
			favoritesList.itemRendererProperties.paddingRight = favoritesList.itemRendererProperties.paddingLeft = 12 * Assets.roundedScaleFactor;
			favoritesList.itemRendererProperties.gap = 14 * Assets.roundedScaleFactor;
			
			favoritesList.scrollerProperties.hasElasticEdges = true;
			
			favoritesList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				
				renderer.iconFunction = function( item:Object ):DisplayObject {
					return new Quad((140 * layoutModel.scale) * Starling.contentScaleFactor, (140 * layoutModel.scale) * Starling.contentScaleFactor, uint("0x"+item.hex));
				};
				
				renderer.accessoryFunction = function( item:Object ):DisplayObject
				{
					var removeButton:Button = item.accessory;
					removeButton.label = "Remove";
					
					return removeButton; 
				}
				
				return renderer;
			};
			
			favoritesList.isSelectable = true;
			
		}
		
		public function displayFavorites( favoritesModel:FavoritesModel ):void
		{
			_dataList = new ListCollection();
			
			//fill with random values
			/*
			var randomColor:uint;
			for( var i:uint = 0; i < 20; i++ ) { 
			randomColor = Math.random() * 0xffffff;
			list.push({text:"0x"+randomColor.toString(16), hex:randomColor.toString(16)});
			}
			*/
			
			var favoriteColors:Array = favoritesModel.favorites;
			var deleteButtonAccessory:Button;
			for each( var hex:String in favoriteColors ) { 
				deleteButtonAccessory = new Button();
				accessoryDeleteButtons[accessoryDeleteButtons.length] = deleteButtonAccessory;
				
				_dataList.push({text:"0x" + hex, hex:hex, accessory:deleteButtonAccessory});
			}
			
			favoritesList.dataProvider = _dataList;
		}
		
		public function removeFavoriteFromList(item:Object):void
		{
			var index:int = _dataList.getItemIndex( item );
			
			if( index > -1 ) { 
				accessoryDeleteButtons.splice( index, 1 );
				
				_dataList.removeItemAt( index );
				
				favoritesList.dataProvider = _dataList;
				favoritesList.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
				favoritesList.validate();
			}
		}
		
	}
}