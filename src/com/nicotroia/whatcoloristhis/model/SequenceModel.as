package com.nicotroia.whatcoloristhis.model
{
	import com.nicotroia.whatcoloristhis.view.pages.PageBase;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.robotlegs.mvcs.Actor;

	public class SequenceModel extends Actor
	{
		public var pages:Dictionary;
		public var assets:Dictionary;
		public var assetWaitingList:Dictionary;
		public var isTransitioning:Boolean = false;
		
		//PAGE Constants
		public static const PAGE_Welcome:Class = WelcomePage;
		public static const PAGE_About:Class = AboutPage;
		public static const PAGE_AreaSelect:Class = AreaSelectPage;
		public static const PAGE_Result:Class = ResultPage;
		
		//ASSET Constants
		public static const ASSET_BACKGROUND:Class = Background;
		
		private var _pageList:Vector.<Class>;
		private var _assetList:Vector.<Class>;
		private var _currentPage:PageBase;
		private var _currentClass:Class;
		private var _lastPageClass:Class;
		
		public function get lastPageClass():Class { return _lastPageClass; }
		public function get currentPage():PageBase { return _currentPage; }
		public function get pageList():Vector.<Class> { return _pageList; }
		public function get assetList():Vector.<Class> { return _assetList; }
		
		public function SequenceModel()
		{
			pages = new Dictionary();
			assets = new Dictionary();
			assetWaitingList = new Dictionary();
			
			//PAGES AND ASSETS THAT WILL GET INITIALIZED 
			_pageList = new <Class>[PAGE_Welcome, PAGE_About, PAGE_AreaSelect, PAGE_Result];
			_assetList = new <Class>[ASSET_BACKGROUND]; 
			
			//EACH ASSET WILL BE ADDED TO THE FOLLOWING ARRAY OF PAGES
			assetWaitingList[ASSET_BACKGROUND] = new <Class>[ PAGE_Welcome, PAGE_About, PAGE_AreaSelect, PAGE_Result ];
			
			//Preallocate pages
			for each( var PageConstant:Class in _pageList ) { 
				trace("preallocating page " + PageConstant );
				pages[PageConstant] = new PageConstant(); 
			}
			
			for each( var AssetConstant:Class in _assetList ) { 
				trace("preallocating asset " + AssetConstant );
				assets[AssetConstant] = new AssetConstant();
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