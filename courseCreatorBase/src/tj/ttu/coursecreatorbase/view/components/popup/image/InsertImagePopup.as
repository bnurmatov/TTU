////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.popup.image
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import mx.core.FlexGlobals;
	import mx.graphics.codec.PNGEncoder;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.HSlider;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.VSlider;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.events.LoaderEvent;
	import tj.ttu.base.loader.ImageFileLoader;
	import tj.ttu.base.loader.ImageUrlLoader;
	import tj.ttu.base.utils.ImageNormalizer;
	import tj.ttu.base.utils.ProtocolType;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.utils.SupportedMediaFormat;
	import tj.ttu.base.utils.TrimUtil;
	import tj.ttu.base.utils.URIUtil;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.components.components.dropdown.ProtocolDropDownList;
	import tj.ttu.components.components.popup.PopupWindow;
	import tj.ttu.components.components.progressbar.ProgressBar;
	import tj.ttu.components.skins.popup.InfoWindowSkin;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * InsertImagePopup class 
	 */
	public class InsertImagePopup extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 * labelMessage
		 */
		[SkinPart(required="false")]
		public var labelMessage:Label;
		
		/**
		 * dropDownOpen
		 */
		[SkinPart(required="true")]
		public var dropDownOpen:ProtocolDropDownList;
		
		/**
		 * textInputUrl
		 */
		[SkinPart(required="true")]
		public var textInputUrl:TextArea;
		
		/**
		 * 
		 * A skin part that defines the progressLoader of the component. 
		 * 
		 */		
		[SkinPart(required="false")]
		public var progressLoader:ProgressBar;
	
		/**
		 * insertButton
		 */
		[SkinPart(required="true")]
		public var insertButton:Button;
		
		
		/**
		 * buttonCancel
		 */
		[SkinPart(required="true")]
		public var buttonCancel:Button;
		
		
		/**
		 * buttonClose
		 */
		[SkinPart(required="true")]
		public var buttonClose:Button;
		
		/**
		 * imageBox
		 */
		[SkinPart(required="true")]
		public var imageBox:Image;
		
		/**
		 * imageWidth
		 */
		[SkinPart(required="true")]
		public var imageWidthSlider:HSlider;
		
		/**
		 * imageHeight
		 */
		[SkinPart(required="true")]
		public var imageHeightSlider:VSlider;
		
		/**
		 * locationDDList
		 */
		[SkinPart(required="true")]
		public var locationDDList:DropDownList;
		
		/**
		 * locationDDList
		 */
		[SkinPart(required="false")]
		public var paddingLeftTextInput:TextInput;
		
		/**
		 * locationDDList
		 */
		[SkinPart(required="false")]
		public var paddingRightTextInput:TextInput;
		
		/**
		 * locationDDList
		 */
		[SkinPart(required="false")]
		public var paddingTopTextInput:TextInput;
		
		/**
		 * locationDDList
		 */
		[SkinPart(required="false")]
		public var paddingBottomTextInput:TextInput;
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var imageFileLoader:ImageFileLoader;
		private var imageUrlLoader:ImageUrlLoader;
		private var warningPopup:PopupWindow;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * InsertImagePopup 
		 */
		public function InsertImagePopup()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  mediaVo
		//----------------------------------
		private var _mediaVo:MediaVO;
		
		public function get mediaVo():MediaVO
		{
			return _mediaVo;
		}
		
		public function set mediaVo(value:MediaVO):void
		{
			if( _mediaVo !== value)
			{
				_mediaVo = value;
				insertImageVo = _mediaVo ? _mediaVo.imageVO : null;
			}
		}
		
		//----------------------------------
		//  insertImageVo
		//----------------------------------
		private var _insertImageVo:ImageVO;
		
		public function get insertImageVo():ImageVO
		{
			return _insertImageVo;
		}
		
		public function set insertImageVo(value:ImageVO):void
		{
			if( _insertImageVo !== value)
			{
				_insertImageVo = value;
			}
		}
		
		//----------------------------------
		//  enableInsert
		//----------------------------------
		private var _enableInsert:Boolean = false;
		
		[Bindable(event="enableInsertChange")]
		public function get enableInsert():Boolean
		{
			return _enableInsert;
		}
		
		public function set enableInsert(value:Boolean):void
		{
			if( _enableInsert !== value)
			{
				_enableInsert = value;
				dispatchEvent(new Event("enableInsertChange"));
			}
		}
		
		//----------------------------------
		//  imageUrl
		//----------------------------------
		private var imageUrlChanged:Boolean = false;
		private var _image:Object;
		
		
		public function get image():Object
		{
			return _image;
		}
		
		public function set image(value:Object):void
		{
			if( _image !== value)
			{
				_image = value;
				enableInsert = _image ? true : false;
				imageUrlChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// visibleProgress
		//-----------------------------------------		
		private var visibleProgressChanged:Boolean = false;
		
		/**
		 * 
		 * Internal storage for visibleProgress.
		 * 
		 */		
		private var _visibleProgress:Boolean;
		
		/**
		 * 
		 * @private
		 * 
		 */		
		private function set visibleProgress(value:Boolean):void
		{
			if( _visibleProgress != value )
			{
				_visibleProgress = value;
				visibleProgressChanged = true;
				invalidateProperties();
			}
		}
		
		//-----------------------------------------
		// error
		//-----------------------------------------
		private var errorChanged:Boolean = false;
		
		/**
		 * 
		 * Internal storage for error.
		 * 
		 */
		private var _error:String;
		
		/**
		 * 
		 * @private
		 * 
		 */		
		private function set error(value:String):void
		{
			_error = value;
			errorChanged 	= true;
			invalidateProperties();
		}
		//-----------------------------------------
		// message
		//-----------------------------------------		
		private var origColor:Number;
		private var messageChanged:Boolean = false;
		
		/**
		 * 
		 * Internal storage for message.
		 * 
		 */		
		private var _message:String = null;
		
		public function get message():String
		{
			return _message;
		}
		/**
		 * 
		 * @private
		 * 
		 */		
		public function set message(value:String):void
		{
			_message = value;
			messageChanged 	= true;
			invalidateProperties();
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(imageBox && imageUrlChanged)
			{
				if( _image is Bitmap )
					imageBox.source 	= _image ? _image.bitmapData : null;
				else
					imageBox.source 	= _image as String;
				
				imageBox.visible	= _image != null;
				
				if( progressLoader && labelMessage )
				{
					progressLoader.visible 	= false;
					labelMessage.visible 	= false;
				}
				imageUrlChanged = false;
			}
			if( progressLoader && visibleProgressChanged )
			{
				progressLoader.visible = _visibleProgress;
				
				if( labelMessage && imageBox )
				{
					labelMessage.visible = false;
					imageBox.visible = false;
				}
				
				visibleProgressChanged = false;
			}
			
			if( errorChanged && labelMessage )
			{
				if( labelMessage.getStyle( "color" ) != getStyle('errorColor') )
					labelMessage.setStyle( "color", getStyle('errorColor') );
				
				labelMessage.text 		= _error;
				labelMessage.visible 	= !StringUtil.isNullOrEmpty( _error );
				
				if( progressLoader && imageBox )
				{
					progressLoader.visible 	= false;
					imageBox.visible 	= false;
				}
				
				errorChanged = false;
			}
			
			if( messageChanged && labelMessage )
			{
				if( labelMessage.getStyle( "color" ) != origColor )
					labelMessage.setStyle( "color", origColor );
				
				labelMessage.text 		= _message;
				labelMessage.visible 	= !StringUtil.isNullOrEmpty( _message );
				
				if( progressLoader && imageBox )
				{
					progressLoader.visible 	= false;
					imageBox.visible 	= false;
				}
				
				messageChanged = false;
			}
			
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == dropDownOpen)
			{
				dropDownOpen.addEventListener(MouseEvent.CLICK , openImageFileHandler);
				dropDownOpen.addEventListener(IndexChangeEvent.CHANGE , openImageFileHandler);
				dropDownOpen.selectedIndex = 1;
			}
			
			if(instance == insertButton)
			{
				insertButton.addEventListener(MouseEvent.CLICK, onInsertImage);
			}
			
			if(instance == buttonCancel)
			{
				buttonCancel.addEventListener(MouseEvent.CLICK, onCloseHandler);
			}
			
			if(instance == buttonClose)
			{
				buttonClose.addEventListener(MouseEvent.CLICK, onCloseHandler);
			}
			if(instance == imageWidthSlider)
			{
				imageWidthSlider.addEventListener(Event.CHANGE, onWidthSliderChange);
			}
			if(instance == imageHeightSlider)
			{
				imageHeightSlider.addEventListener(Event.CHANGE, onHeightSliderChange);
			}
			
			message = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, 'insertImagePopupMessageLabelText') || ' Choose an image to insert it to your text content. Optionaly you can set width, height and position property of selected image.'
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if(instance == dropDownOpen)
			{
				dropDownOpen.removeEventListener(MouseEvent.CLICK , openImageFileHandler);
				dropDownOpen.removeEventListener(IndexChangeEvent.CHANGE , openImageFileHandler);
				dropDownOpen.selectedIndex = 1;
			}
			
			if(instance == insertButton)
			{
				insertButton.removeEventListener(MouseEvent.CLICK, onInsertImage);
			}
			
			if(instance == buttonCancel)
			{
				buttonCancel.removeEventListener(MouseEvent.CLICK, onCloseHandler);
			}
			
			if(instance == buttonClose)
			{
				buttonClose.removeEventListener(MouseEvent.CLICK, onCloseHandler);
			}
			if(instance == imageWidthSlider)
			{
				imageWidthSlider.removeEventListener(Event.CHANGE, onWidthSliderChange);
			}
			if(instance == imageHeightSlider)
			{
				imageHeightSlider.removeEventListener(Event.CHANGE, onHeightSliderChange);
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		private function attachFileLoaderListeners():void
		{
			if(imageFileLoader)
			{
				imageFileLoader.addEventListener(LoaderEvent.LOAD_COMPLETE, onImageLoaded);
				imageFileLoader.addEventListener(LoaderEvent.LOAD_PROGRESS, onImageLoadProgress);
				imageFileLoader.addEventListener(LoaderEvent.LOAD_ERROR, onImageLoadError);
				imageFileLoader.addEventListener(LoaderEvent.CANCEL, onImageLoadCanceled);
			}
		}
		
		private function attachUrlLoaderListeners():void
		{
			if(imageUrlLoader)
			{
				imageUrlLoader.addEventListener(LoaderEvent.LOAD_COMPLETE, onImageLoaded);
				imageUrlLoader.addEventListener(LoaderEvent.LOAD_PROGRESS, onImageLoadProgress);
				imageUrlLoader.addEventListener(LoaderEvent.LOAD_ERROR, onImageLoadError);
			}
		}
		
		private function removeListeners():void
		{
			if(imageFileLoader)
			{
				imageFileLoader.removeEventListener(LoaderEvent.LOAD_COMPLETE, onImageLoaded);
				imageFileLoader.removeEventListener(LoaderEvent.LOAD_PROGRESS, onImageLoadProgress);
				imageFileLoader.removeEventListener(LoaderEvent.LOAD_ERROR, onImageLoadError);
				imageFileLoader.removeEventListener(LoaderEvent.CANCEL, onImageLoadCanceled);
			}
			
			if(imageUrlLoader)
			{
				imageUrlLoader.removeEventListener(LoaderEvent.LOAD_COMPLETE, onImageLoaded);
				imageUrlLoader.removeEventListener(LoaderEvent.LOAD_PROGRESS, onImageLoadProgress);
				imageUrlLoader.removeEventListener(LoaderEvent.LOAD_ERROR, onImageLoadError);
			}
		}
		
		private function removeLoaders():void
		{
			removeListeners();
			imageFileLoader = null;
			imageUrlLoader = null;
		}
		
		private function showWarningPopup():void
		{
			var message:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, "importImageIsNotSupportedMessge") || "Image is not supported"; 
			var detailMessage:String = resourceManager.getString(ResourceConstants.TTU_COMPONENTS, "importImageIsNotSupportedMessgeDetils") || "The image you have tried to import is not supported (or is corrupted). Please convert the image to an appropriate file type (.gif, .jpg, and .png) and try again."; 
			
			var parent:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			
			warningPopup = new PopupWindow();
			
			warningPopup.setStyle("skinClass", InfoWindowSkin);
			warningPopup.message = message;
			warningPopup.messageDetail = detailMessage; 
			
			warningPopup.addEventListener(PopupWindow.OK, onWarningPopup);
			warningPopup.addEventListener(Event.CLOSE, onWarningPopup);
			
			PopUpManager.addPopUp(warningPopup, parent, true);
			PopUpManager.centerPopUp(warningPopup);
			warningPopup.setFocus();
		}
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		protected function onWarningPopup(event:Event):void
		{
			warningPopup.removeEventListener(Event.CLOSE, onWarningPopup);
			warningPopup.removeEventListener(PopupWindow.OK, onWarningPopup);
			PopUpManager.removePopUp(warningPopup);
			warningPopup = null;		
		}
		
		
		protected function onCloseHandler(event:MouseEvent):void
		{
			dispatchEvent( new Event(Event.CLOSE));
		}
		
		protected function onInsertImage(event:MouseEvent):void
		{
			if(!(_image is Bitmap))
				return;
			
			//var bitmapData:BitmapData = ImageNormalizer.normalize((_image as Bitmap).bitmapData, imageWidthSlider.value, imageHeightSlider.value);
			
			if(!_insertImageVo)
				_insertImageVo = new ImageVO();
			
			var encode:PNGEncoder 		= new PNGEncoder();
			_insertImageVo.binarySource = encode.encode( (_image as Bitmap).bitmapData );
			_insertImageVo.image 		= _image;
			insertImageVo.width 		= String( imageWidthSlider.value );
			insertImageVo.height 		= String( imageHeightSlider.value );
			insertImageVo.location 		= locationDDList.selectedItem.data;
			
			
			if(mediaVo)
			{
				mediaVo.imageVO = _insertImageVo;
				dispatchEvent( new CourseEvent(CourseEvent.INSERT_IMAGE, mediaVo));
			}
		}
		
		protected function onWidthSliderChange(event:Event):void
		{
			var coef:Number = imageWidthSlider.maximum / imageHeightSlider.maximum;
			imageHeightSlider.value = imageWidthSlider.value / coef;
		}
		
		protected function onHeightSliderChange(event:Event):void
		{
			var coef:Number = imageWidthSlider.maximum / imageHeightSlider.maximum;
			imageWidthSlider.value = imageHeightSlider.value * coef;
		}
		
		
		protected function openImageFileHandler(event:Event):void
		{
			var url:String = TrimUtil.trim( textInputUrl.text );
			var protocol:String = ProtocolType.HTTP; 
			
			if( StringUtil.isNullOrEmpty( url ) && 
				event.type != IndexChangeEvent.CHANGE || protocol == ProtocolType.LOCALE )
			{
				//image file loader
				imageFileLoader = new ImageFileLoader();
				attachFileLoaderListeners();
				imageFileLoader.load();
			}
			else
			{
				if( event.type == IndexChangeEvent.CHANGE )
					protocol = dropDownOpen.selectedItem.protocol;
				
				if(protocol == ProtocolType.LOCALE)
				{
					textInputUrl.text = "";
					return;
				}
				
				if( !URIUtil.check( url ) )
				{
					error = resourceManager.getString( ResourceConstants.TTU_COMPONENTS, "errorImageAddress" ) || "Entered an Incorrect Address";
				}
				else
				{
					
					if( url.indexOf( "//" ) == -1 )
						url = protocol + url;
					
					var pos:int = url.lastIndexOf( "\\" );
					pos = pos == -1 ? url.lastIndexOf( "/" ) : pos;
					// image url loader
					imageUrlLoader = new ImageUrlLoader();
					attachUrlLoaderListeners();
					imageUrlLoader.load( url );
				}				
			}
			
			dropDownOpen.selectedIndex = -1;
		}
		
		protected function onImageLoaded(event:LoaderEvent):void
		{
			var contentBitmap:Bitmap = event.data as Bitmap;
			if(contentBitmap)
			{
				contentBitmap.bitmapData = ImageNormalizer.normalize(contentBitmap.bitmapData);
				var bitmapData:BitmapData = contentBitmap.bitmapData.clone();
				bitmapData = ImageNormalizer.normalizeForText(bitmapData);
				imageWidthSlider.value = imageWidthSlider.maximum = 	int(bitmapData.width);
				imageHeightSlider.value = imageHeightSlider.maximum = 	int(bitmapData.height);
				image = contentBitmap;
				bitmapData.dispose();
			}
			removeLoaders();
		}
		
		protected function onImageLoadError(event:LoaderEvent):void
		{
			error = event.data as String;
			removeLoaders();
			showWarningPopup();
		}
		
		protected function onImageLoadProgress(event:LoaderEvent):void
		{
			var progressEvent:ProgressEvent = event.data as ProgressEvent;
			if( progressLoader && progressEvent)
			{
				progressLoader.setProgress( progressEvent.bytesLoaded, progressEvent.bytesTotal );
				
				visibleProgress = progressEvent.bytesLoaded != progressEvent.bytesTotal;
			}
		}
		
		protected function onImageLoadCanceled(event:LoaderEvent):void
		{
			removeLoaders();
		}
		
	}
}