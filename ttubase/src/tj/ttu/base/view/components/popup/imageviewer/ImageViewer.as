////////////////////////////////////////////////////////////////////////////////
// Copyright Jun 8, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.view.components.popup.imageviewer
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.CloseEvent;
	
	import spark.components.Button;
	import spark.components.VSlider;
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * ImageViewer class 
	 */
	public class ImageViewer extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart]
		public var zoomInButton:Button;
		[SkinPart]
		public var slider:VSlider;
		[SkinPart]
		public var zoomOutButton:Button;
		[SkinPart]
		public var imageHolder:ImageHolder;
		
		/**
		 * buttonClose
		 */
		[SkinPart(required="true")]
		public var buttonClose:Button;
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ImageViewer 
		 */
		public function ImageViewer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// imageURL
		//-----------------------------------------
		private var imageURLChanged:Boolean = false;
		private var _imageURL:String;
		/**
		 * 
		 * Setting the imageURL triggers the loading of the image and extraction 
		 * and assignment of it's bitmapData. 
		 *
		 */ 		
		
		[Bindable]
		public function get imageURL():String
		{
			return _imageURL;
		}
		public function set imageURL(value:String):void
		{
			// setting imageURL triggers loading sequence		
			if (value == _imageURL)
				return;
			_imageURL = value;
			imageURLChanged = true;
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
			if(imageHolder && imageURLChanged)
			{
				imageHolder.imageURL = _imageURL;
				imageURLChanged = false;
			}
		}
		
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == zoomInButton)
				zoomInButton.addEventListener(MouseEvent.CLICK, onZoomIn);
			else if(instance == zoomOutButton)
				zoomOutButton.addEventListener(MouseEvent.CLICK, onZoomOut);
			else if(instance == slider)
				slider.addEventListener(Event.CHANGE, onSliderValueChange);
			if(instance == buttonClose)
				buttonClose.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == zoomInButton)
				zoomInButton.removeEventListener(MouseEvent.CLICK, onZoomIn);
			else if(instance == zoomOutButton)
				zoomOutButton.removeEventListener(MouseEvent.CLICK, onZoomOut);
			else if(instance == slider)
				slider.removeEventListener(Event.CHANGE, onSliderValueChange);
			if(instance == buttonClose)
				buttonClose.removeEventListener(MouseEvent.CLICK, onClose);
			super.partRemoved(partName, instance);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		protected function onSliderValueChange(event:Event):void
		{
			if(imageHolder)
				imageHolder.setZoom(slider.value)
		}
		
		protected function onZoomOut(event:MouseEvent):void
		{
			if(imageHolder)
				imageHolder.zoom(Zoom.ZOOM_OUT);
		}
		
		protected function onZoomIn(event:MouseEvent):void
		{
			if(imageHolder)
				imageHolder.zoom(Zoom.ZOOM_IN);
		}
		
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}		
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			if(!imageHolder) return;
			if (event.delta > 0)
				imageHolder.zoom(Zoom.ZOOM_IN);						
			else 
				imageHolder.zoom(Zoom.ZOOM_OUT);						
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
	}
}