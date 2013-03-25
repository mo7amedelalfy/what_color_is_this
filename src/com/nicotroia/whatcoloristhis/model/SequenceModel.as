package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.view.overlays.HeaderOverlay;
	import com.nicotroia.whatcoloristhis.view.pages.AboutPage;
	import com.nicotroia.whatcoloristhis.view.pages.AreaSelectPage;
	import com.nicotroia.whatcoloristhis.view.pages.ConfirmColorPage;
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	import com.nicotroia.whatcoloristhis.view.pages.ResultPage;
	import com.nicotroia.whatcoloristhis.view.pages.SettingsPage;
	import com.nicotroia.whatcoloristhis.view.pages.WelcomePage;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.robotlegs.mvcs.Actor;

	public class SequenceModel extends Actor
	{
		public var pages:Dictionary;
		public var assets:Dictionary;
		public var overlays:Dictionary;
		public var assetWaitingList:Dictionary;
		public var overlayWaitingList:Dictionary;
		public var isTransitioning:Boolean = false;
		public var lastPageRemovedSuccessfully:Boolean = true;
		
		//PAGE Constants
		public static const PAGE_Welcome:Class = WelcomePage;
		public static const PAGE_Settings:Class = SettingsPage;
		public static const PAGE_About:Class = AboutPage;
		public static const PAGE_AreaSelect:Class = AreaSelectPage;
		public static const PAGE_ConfirmColor:Class = ConfirmColorPage;
		public static const PAGE_Result:Class = ResultPage;
		
		//ASSET Constants
		//public static const ASSET_Background:Class = BackgroundAsset;
		
		//OVERLAY Constants
		public static const OVERLAY_Header:Class = HeaderOverlay;
		//public static const OVERLAY_NavBar:Class = NavBarOverlay;
		//public static const OVERLAY_BackButton:Class = BackButtonOverlay;
		
		private var _pageList:Vector.<Class>;
		private var _assetList:Vector.<Class>;
		private var _overlayList:Vector.<Class>;
		private var _currentPage:PageBase;
		private var _currentClass:Class;
		private var _lastPageClass:Class;
		
		public function get lastPageClass():Class { return _lastPageClass; }
		public function get currentPage():PageBase { return _currentPage; }
		public function get pageList():Vector.<Class> { return _pageList; }
		public function get assetList():Vector.<Class> { return _assetList; }
		public function get overlayList():Vector.<Class> { return _overlayList; }
		
		public function SequenceModel()
		{
			pages = new Dictionary();
			assets = new Dictionary();
			overlays = new Dictionary();
			assetWaitingList = new Dictionary();
			overlayWaitingList = new Dictionary();
			
			//Define everything that will be created and used.
			_pageList = new <Class>[PAGE_Welcome, PAGE_Settings, PAGE_About, PAGE_AreaSelect, PAGE_ConfirmColor, PAGE_Result];
			_assetList = new <Class>[]; //ASSET_Background];
			_overlayList = new <Class>[OVERLAY_Header]; //OVERLAY_NavBar, OVERLAY_BackButton];
			
			//Each asset will be added to the following pages
			//assetWaitingList[ASSET_Background] = new <Class>[ PAGE_Welcome, PAGE_About, PAGE_AreaSelect, PAGE_Result ];
			
			//Each overlay will be added to the following pages
			overlayWaitingList[OVERLAY_Header] = new <Class>[ PAGE_Welcome, PAGE_Settings, PAGE_About, PAGE_AreaSelect, PAGE_ConfirmColor, PAGE_Result ];
			
			//Preallocate Pages
			for each( var PageConstant:Class in _pageList ) { 
				trace("preallocating page " + PageConstant );
				pages[PageConstant] = new PageConstant(); 
			}
			
			//Preallocate Assets
			for each( var AssetConstant:Class in _assetList ) { 
				trace("preallocating asset " + AssetConstant );
				assets[AssetConstant] = new AssetConstant();
			}
			
			//Preallocate Overlays
			for each( var OverlayConstant:Class in _overlayList ) { 
				trace("preallocating overlay " + OverlayConstant );
				overlays[OverlayConstant] = new OverlayConstant();
			}
			
			trace("SequenceModel ready");
		}
		
		public function getPage(PageConstant:Class):PageBase
		{
			if( _currentClass ) _lastPageClass = _currentClass;
			_currentClass = PageConstant;
			_currentPage = pages[PageConstant];
			
			return _currentPage;
		}
		
		public function getClassByName(className:String):Class
		{
			try
			{
				return Class(getDefinitionByName(className));
			}
			catch (argErr:ArgumentError)
			{
				return null;
			}
			catch (refErr:ReferenceError)
			{
				return null;
			}
			catch (typeErr:TypeError)
			{
				return null;
			}
			
			return null;
		}
	}
}