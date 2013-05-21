package com.nicotroia.whatcoloristhis.view.pages
{
	import com.nicotroia.whatcoloristhis.model.CameraModel;
	import com.nicotroia.whatcoloristhis.model.LayoutModel;
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.Image;

	public class SuggestionPage extends PageBase
	{
		public var backButton:Button;
		public var textInput:TextInput;
		public var submitButton:Button;
		
		private var _infoTitleImage:Image;
		private var _infoTitleTextFormat:TextFormat;
		
		public function SuggestionPage()
		{
			vectorPage = new SuggestionPageVector();
			_infoTitleTextFormat = new TextFormat();
			
			super();
		}
		
		public function setTextFormat(layoutModel:LayoutModel):void
		{
			_infoTitleTextFormat.font = layoutModel.infoDispMedium.fontName;
			_infoTitleTextFormat.size = (30 * layoutModel.scale);
			_infoTitleTextFormat.leading = 10 * layoutModel.scale;
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel=null):void
		{
			setTextFormat( layoutModel );
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			vectorPage.infoTitle.x = 0;
			vectorPage.infoTitle.y = (layoutModel.navBarHeight/Starling.contentScaleFactor) - (3 * layoutModel.scale * Starling.contentScaleFactor);
			
			vectorPage.infoTitle.bar.width = layoutModel.appWidth + 4;
			vectorPage.infoTitle.bar.height = 100 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.infoTitle.bar.x = -2;
			vectorPage.infoTitle.bar.y = 0;
			
			vectorPage.infoTitle.labelTF.wordWrap = false;
			vectorPage.infoTitle.labelTF.multiline = true;
			vectorPage.infoTitle.labelTF.width = layoutModel.appWidth;
			vectorPage.infoTitle.labelTF.height = 100 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.infoTitle.labelTF.x = 0;
			vectorPage.infoTitle.labelTF.y = 10 * layoutModel.scale * Starling.contentScaleFactor;
			
			vectorPage.infoTitle.labelTF.text = "Please suggest a new name.\nAll submissions will be reviewed."; 
			vectorPage.infoTitle.labelTF.setTextFormat( _infoTitleTextFormat );
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null, cameraModel:CameraModel = null):void
		{	
			//Remove first
			removeDrawnVector( _background );
			removeDrawnVector( _infoTitleImage );
			removeDrawnVector( submitButton );
			
			
			//Create
			_background = drawBackgroundQuad();
			backButton = new Button();
			textInput = new TextInput();
			_infoTitleImage = createImageFromDisplayObject( vectorPage.infoTitle );
			submitButton = new Button();
			
			
			//Add
			addChildAt(_background, 0);
			addChild( textInput );
			addChild( _infoTitleImage );
			addChild( submitButton );
			
			
			//Settings
			backButton.label = "Back";
			submitButton.label = "Submit";
			
			textInput.textEditorFactory = function():ITextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontFamily = "Arial";
				editor.fontSize = 14;
				editor.color = 0xffffff;
				
				return editor;
			};
				
			//textInput.backgroundSkin = new Scale9Image( backgroundSkinTextures );
			//textInput.backgroundDisabledSkin = new Scale9Image( disabledBackgroundSkinTextures );
			//textInput.backgroundFocusedSkin = new Scale9Image( focusedBackgroundSkinTextures );
			textInput.text = "Suggestion";
			textInput.paddingTop = 28 * layoutModel.scale;
			textInput.paddingRight = 28 * layoutModel.scale;
			textInput.paddingBottom = 10 * layoutModel.scale;
			textInput.paddingLeft = 28 * layoutModel.scale;
			textInput.width = layoutModel.appWidth - (96 * layoutModel.scale);
			textInput.height = 80 * layoutModel.scale;
			textInput.x = 48 * layoutModel.scale;
			textInput.y = vectorPage.infoTitle.y + vectorPage.infoTitle.height + (42 * layoutModel.scale);
			
			textInput.textEditorProperties.autoCorrect = false;
			textInput.textEditorProperties.displayAsPassword = false;
			textInput.textEditorProperties.fontFamily = "Arial";
			textInput.textEditorProperties.fontSize = 24 * layoutModel.scale;
			textInput.textEditorProperties.color = 0xffffff;
			
			textInput.invalidate(FeathersControl.INVALIDATION_FLAG_ALL);
			textInput.validate();
			
			submitButton.x = textInput.x; //(layoutModel.appWidth * 0.5) - (submitButton.width * 0.5); //
			submitButton.y = textInput.y + textInput.height + (42 * layoutModel.scale);
		}
		
		public function reset():void
		{
			backButton.isEnabled = true;
			backButton.isSelected = false;
			submitButton.isEnabled = true;
			submitButton.isSelected = false;
			textInput.isEnabled = true;
			textInput.setFocus();
			
			textInput.text = "Suggestion";
		}
	}
}