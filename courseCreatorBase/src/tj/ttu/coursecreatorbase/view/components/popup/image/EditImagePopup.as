////////////////////////////////////////////////////////////////////////////////
// Copyright Jun 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.view.components.popup.image
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	
	import mx.core.IFlexDisplayObject;
	import mx.managers.IFocusManagerContainer;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.HSlider;
	import spark.components.Image;
	import spark.components.VSlider;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.base.utils.ImageNormalizer;
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.coursecreatorbase.view.events.CourseEvent;
	
	/**
	 * EditImagePopup class 
	 */
	public class EditImagePopup extends SkinnableComponent implements IFocusManagerContainer
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 * selectImageButton
		 */
		[SkinPart(required="true")]
		public var updateImageButton:Button;
		/**
		 * insertButton
		 */
		[SkinPart(required="true")]
		public var deleteButton:Button;
		/**
		 * buttonCancel
		 */
		[SkinPart(required="true")]
		public var cancelButton:Button;
		
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
		public var locationList:DropDownList;
		
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
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * EditImagePopup 
		 */
		public function EditImagePopup()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _defaultButton:IFlexDisplayObject;
		
		public function get defaultButton():IFlexDisplayObject
		{
			return _defaultButton;
		}
		
		public function set defaultButton(value:IFlexDisplayObject):void
		{
			_defaultButton = value;
		}
		//----------------------------------
		//  imageHasChanged
		//----------------------------------
		private var _imageHasChanged:Boolean;
		
		[Bindable(event="imageHasChangedChange")]
		public function get imageHasChanged():Boolean
		{
			return _imageHasChanged;
		}
		
		public function set imageHasChanged(value:Boolean):void
		{
			if( _imageHasChanged !== value)
			{
				_imageHasChanged = value;
				dispatchEvent(new Event("imageHasChangedChange"));
			}
		}
		
		//----------------------------------
		//  insertImageVo
		//----------------------------------
		private var _insertImageVo:InlineGraphicElement;
		
		public function get insertImageVo():InlineGraphicElement
		{
			return _insertImageVo;
		}
		
		public function set insertImageVo(value:InlineGraphicElement):void
		{
			if( _insertImageVo !== value)
			{
				_insertImageVo 	= value;
				imageWidth 		= value? value.width:0;
				imageHeight 	= value? value.height:0;
				imageLocation 	= value? value.float:null;
				image 			= value? value.source:null;
				if(value && value.source is Loader)
				{
					image = (value.source as Loader).content as Bitmap;
				}
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
				imageUrlChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
		//  imageWidthChanged
		//----------------------------------
		private var imageWidthChanged:Boolean;
		private var _imageWidth:Number;
		
		public function get imageWidth():Number
		{
			return _imageWidth;
		}
		
		public function set imageWidth(value:Number):void
		{
			if( _imageWidth !== value)
			{
				_imageWidth = value;
				imageWidthChanged = true;
				invalidateProperties();
			}
		}
		
		//----------------------------------
		//  imageHeightChanged
		//----------------------------------
		private var imageHeightChanged:Boolean;
		private var _imageHeight:Number;
		public function get imageHeight():Number
		{
			return _imageHeight;
		}
		
		public function set imageHeight(value:Number):void
		{
			if( _imageHeight !== value)
			{
				_imageHeight = value;
				imageHeightChanged = true;
				invalidateProperties();
			}
		}
		//----------------------------------
		//  imageLocationChanged
		//----------------------------------
		private var imageLocationChanged:Boolean;
		private var _imageLocation:String;
		public function get imageLocation():String
		{
			return _imageLocation;
		}
		
		public function set imageLocation(value:String):void
		{
			if( _imageLocation !== value)
			{
				_imageLocation = value;
				imageLocationChanged = true;
				invalidateProperties();
			}
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
				imageBox.source = _image;
				if(image is Bitmap)
				{
					var bitmapData:BitmapData = Bitmap(image).bitmapData.clone();
					bitmapData = ImageNormalizer.normalizeForText(bitmapData);
					imageWidthSlider.maximum 	= bitmapData.width;
					imageHeightSlider.maximum 	= bitmapData.height;
					imageWidthSlider.value 		= imageWidth;
					imageHeightSlider.value 	= imageHeight;	
					bitmapData.dispose();
				}
				imageUrlChanged = false;
			}
			if(imageWidthChanged && imageWidthSlider)
			{
				imageWidthSlider.value = imageWidth;
				imageWidthChanged = false;
			}
			if(imageHeightChanged && imageHeightSlider)
			{
				imageHeightSlider.value = imageHeight;
				imageHeightChanged = false;
			}
			if(imageLocationChanged && locationList)
			{
				locationList.selectedIndex = imageLocation == ImageVO.LEFT ? 0: 1;
				imageLocationChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == imageBox)
			{
				imageBox.addEventListener(Event.COMPLETE, onImageLoadComplete);
			}
			if(instance == locationList)
			{
				locationList.addEventListener(Event.CHANGE, onImageLcationChange);
			}
			if(instance == imageBox)
			{
				imageBox.addEventListener(Event.COMPLETE, onImageLoadComplete);
			}
			if(instance == updateImageButton)
			{
				updateImageButton.addEventListener(MouseEvent.CLICK, onUpdateImage);
			}
			if(instance == deleteButton)
			{
				deleteButton.addEventListener(MouseEvent.CLICK, onDeleteImage);
			}
			if(instance == cancelButton)
			{
				cancelButton.addEventListener(MouseEvent.CLICK, onClose);
			}
			if(instance == buttonClose)
			{
				buttonClose.addEventListener(MouseEvent.CLICK, onClose);
			}
			if(instance == imageWidthSlider)
			{
				imageWidthSlider.addEventListener(Event.CHANGE, onWidthSliderChange);
			}
			if(instance == imageHeightSlider)
			{
				imageHeightSlider.addEventListener(Event.CHANGE, onHeightSliderChange);
			}
		}
		
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == imageBox)
			{
				imageBox.removeEventListener(Event.COMPLETE, onImageLoadComplete);
			}
			if(instance == locationList)
			{
				locationList.removeEventListener(Event.CHANGE, onImageLcationChange);
			}
			if(instance == updateImageButton)
			{
				updateImageButton.removeEventListener(MouseEvent.CLICK, onUpdateImage);
			}
			
			if(instance == deleteButton)
			{
				deleteButton.removeEventListener(MouseEvent.CLICK, onDeleteImage);
			}
			
			if(instance == cancelButton)
			{
				cancelButton.removeEventListener(MouseEvent.CLICK, onClose);
			}
			
			if(instance == buttonClose)
			{
				buttonClose.removeEventListener(MouseEvent.CLICK, onClose);
			}
			if(instance == imageWidthSlider)
			{
				imageWidthSlider.removeEventListener(Event.CHANGE, onWidthSliderChange);
			}
			if(instance == imageHeightSlider)
			{
				imageHeightSlider.removeEventListener(Event.CHANGE, onHeightSliderChange);
			}
			super.partRemoved(partName, instance);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent( new Event(Event.CLOSE));
		}
		
		/**
		 *  @private
		 */
		protected function onDeleteImage(event:MouseEvent):void
		{
			dispatchEvent( new CourseEvent(CourseEvent.REMOVE_IMAGE, insertImageVo));
		}
		
		/**
		 *  @private
		 */
		protected function onUpdateImage(event:MouseEvent):void
		{
			var bmp:BitmapData = ImageNormalizer.normalizeForSize(imageBox.bitmapData.clone(), imageWidthSlider.value, imageHeightSlider.value);
			insertImageVo.float	 = locationList.selectedItem.data;
			insertImageVo.width  = bmp.width;
			insertImageVo.height = bmp.height;
			insertImageVo.paddingBottom = -5;
			bmp.dispose();
			dispatchEvent( new CourseEvent(CourseEvent.UPDATE_IMAGE, insertImageVo));
		}
		
		/**
		 *  @private
		 */
		private function onImageLoadComplete( event:Event ) : void
		{
			var contentBitmap:Bitmap = new Bitmap(imageBox.bitmapData);
			if(contentBitmap)
			{
				contentBitmap = new Bitmap(ImageNormalizer.normalize(contentBitmap.bitmapData));
				var bitmapData:BitmapData = contentBitmap.bitmapData.clone();
				bitmapData = ImageNormalizer.normalizeForText(bitmapData);
				imageWidthSlider.maximum = 	int(bitmapData.width);
				imageHeightSlider.maximum = int(bitmapData.height);
				imageWidthSlider.value = isNaN(imageWidth)? bitmapData.width: imageWidth;
				imageHeightSlider.value	= isNaN(imageHeight)? bitmapData.height: imageHeight;	
				if(imageBox)
				{
					imageBox.width = imageWidthSlider.value;
					imageBox.height = imageHeightSlider.value;
				}
				bitmapData.dispose();
			}
		}
		
		/**
		 *  @private
		 */
		protected function onWidthSliderChange(event:Event):void
		{
			var coef:Number = imageWidthSlider.maximum / imageHeightSlider.maximum;
			imageHeightSlider.value = imageWidthSlider.value / coef;
			imageHasChanged = true;
		}
		
		/**
		 *  @private
		 */
		protected function onHeightSliderChange(event:Event):void
		{
			var coef:Number = imageWidthSlider.maximum / imageHeightSlider.maximum;
			imageWidthSlider.value = imageHeightSlider.value * coef;
			imageHasChanged = true;
		}	
		/**
		 *  @private
		 */
		protected function onImageLcationChange(event:IndexChangeEvent):void
		{
			imageHasChanged = true;
		}	
	}
}