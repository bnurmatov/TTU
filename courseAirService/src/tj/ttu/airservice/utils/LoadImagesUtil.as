////////////////////////////////////////////////////////////////////////////////
// Copyright May 25, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import tj.ttu.airservice.utils.events.UtilEvent;
	import tj.ttu.base.vo.ImageVO;
	
	/**
	 * LoadImagesUtil class 
	 */
	public class LoadImagesUtil extends EventDispatcher
	{
		
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
		private var currentImage:ImageVO;
		private var currentImageIndex:int;
		private var loader:Loader;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LoadImagesUtil 
		 */
		public function LoadImagesUtil(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _images:Array;

		public function get images():Array
		{
			return _images;
		}

		public function set images(value:Array):void
		{
			_images = value;
			currentImageIndex = _images ? images.length : -1;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		public function load(images:Array):void
		{
			this.images = images;
			loadNextImage();
		}
		
		private function loadNextImage():void
		{
			shiftCurrentImage();
			if(currentImage)
			{
				initLoader();
				loader.load(new URLRequest(currentImage.imageUrl));
			}
			else
				complete();
		}
		
		private function complete():void
		{
			dispatchEvent( new UtilEvent(UtilEvent.IMAGES_LOADED_COMPLETE, images));
			destroyLoader();
			images = null;
		}
		
		/**
		 *  @private
		 */
		
		/**
		 * Shift to the next <code>ChapterVO</code> in array of current chapters.
		 */
		private function shiftCurrentImage():void
		{
			currentImage = images ? images[--currentImageIndex] : null;
		}
		
		private function initLoader():void
		{
			if(!loader)
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
		}
		
		private function destroyLoader():void
		{
			if(loader)
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader = null;
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		
		protected function onIOError(event:IOErrorEvent):void
		{
			trace("IOErrorEvent=======>>>>>>",event.text);
			loadNextImage();
		}
		
		protected function onLoadComplete(event:Event):void
		{
			currentImage.image = Bitmap(loader.content).bitmapData;
			loadNextImage();
		}
	}
}