////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 15, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.loader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.resources.ResourceManager;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.events.LoaderEvent;
	import tj.ttu.base.utils.BMPDecoder;
	import tj.ttu.base.utils.SupportedMediaFormat;
	
	[Event(name="loadComplete", 	type="tj.ttu.base.events.LoaderEvent")]
	[Event(name="loadError", 		type="tj.ttu.base.events.LoaderEvent")]
	[Event(name="loadProgress", 	type="tj.ttu.base.events.LoaderEvent")]
	[Event(name="cancel", 			type="tj.ttu.base.events.LoaderEvent")]
	/**
	 * ImageUrlLoader class 
	 */
	public class ImageUrlLoader extends EventDispatcher
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
		private var remoteManager:LoaderInfo;
		private var reloadManager:LoaderInfo;
		private var urlLoader:URLLoader;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ImageUrlLoader 
		 */
		public function ImageUrlLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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
		public function load(url:String):void
		{
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			attachURLLoadingListeners();
			try
			{
				var request:URLRequest = new URLRequest( url );
				urlLoader.load( request );
			}
			catch(err:Error)
			{
				removeManagers();
				dispatchEvent( new LoaderEvent(LoaderEvent.LOAD_ERROR, err.message));
			}
		}
		/**
		 *  @private
		 */
		
		private function attachURLLoadingListeners():void
		{
			if( urlLoader )
			{
				urlLoader.addEventListener( Event.COMPLETE, imageBinaryLoadedHandler );
				urlLoader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorEventHandler );
				urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, ioErrorEventHandler );
				urlLoader.addEventListener( ErrorEvent.ERROR, ioErrorEventHandler );
				urlLoader.addEventListener( ProgressEvent.PROGRESS, loadingProgressHandler );
				urlLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
			}
		}
		
		private function attachReloadingListeners():void
		{
			if( reloadManager )
			{
				reloadManager.addEventListener( Event.COMPLETE, imageReloadedHandler );
				reloadManager.addEventListener( IOErrorEvent.IO_ERROR, ioErrorEventHandler );
				reloadManager.addEventListener( SecurityErrorEvent.SECURITY_ERROR, ioErrorEventHandler );
				reloadManager.addEventListener( ErrorEvent.ERROR, ioErrorEventHandler );
				reloadManager.addEventListener( ProgressEvent.PROGRESS, loadingProgressHandler );
			}
		}
		
		private function removeHandlers() : void
		{
			if( urlLoader )
			{
				urlLoader.removeEventListener( Event.COMPLETE, imageBinaryLoadedHandler );
				urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorEventHandler );
				urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, ioErrorEventHandler );
				urlLoader.removeEventListener( ErrorEvent.ERROR, ioErrorEventHandler );
				urlLoader.removeEventListener( ProgressEvent.PROGRESS, loadingProgressHandler );
				urlLoader.removeEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
			}
			
			if( reloadManager )
			{
				reloadManager.removeEventListener( Event.COMPLETE, imageReloadedHandler );
				reloadManager.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorEventHandler );
				reloadManager.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, ioErrorEventHandler );
				reloadManager.removeEventListener( ErrorEvent.ERROR, ioErrorEventHandler );
				reloadManager.removeEventListener( ProgressEvent.PROGRESS, loadingProgressHandler );
			}
		}
		
		/**
		 *  @private
		 */
		private function removeManagers() : void
		{
			removeHandlers();
			urlLoader 	= null;
			reloadManager	= null;
		}
		
		private function convertBMPImage(data:ByteArray):void
		{
			var bmpUtil:BMPDecoder =  new BMPDecoder();
			var bmpBitmap:BitmapData = bmpUtil.decode( data );
			sendLoadedImage(new Bitmap( bmpBitmap ));
		}
		
		private function showImage( data:ByteArray ) : void
		{
			var loader:Loader = new Loader();
			reloadManager = loader.contentLoaderInfo;
			attachReloadingListeners();
			
			try
			{
				loader.loadBytes( data );
			}
			catch( err:SecurityError )
			{
				removeManagers();
				dispatchEvent( new LoaderEvent(LoaderEvent.LOAD_ERROR, err.message));
			}
			
		}
		
		private function sendLoadedImage(bmp:Bitmap):void
		{
			removeManagers();
			dispatchEvent( new LoaderEvent(LoaderEvent.LOAD_COMPLETE, bmp));
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
		private function imageBinaryLoadedHandler( event:Event ) : void
		{
			var ba:ByteArray = urlLoader.data as ByteArray;
			var fileType:String;
			if(ba)
			{
				fileType = SupportedMediaFormat.getSupportedImageType(ba);
				if(fileType)
				{
					switch(fileType)
					{
						case SupportedMediaFormat.GIF_TYPE:
						case SupportedMediaFormat.JPEG_TYPE:
						case SupportedMediaFormat.PNG_TYPE:
						{
							showImage(ba);
							break;
						}
						case SupportedMediaFormat.BMP_TYPE:
						{
							convertBMPImage(ba);
							break;
						}
					}
				}
				else
				{
					var error:String = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS,'unknownFileFormat') || 'Unknown file format.';
					removeManagers();
					dispatchEvent( new LoaderEvent(LoaderEvent.LOAD_ERROR, error));
				}
			}
		}
		
		private function imageReloadedHandler( event:Event ) : void
		{
			var bmd:BitmapData = new BitmapData(reloadManager.width, reloadManager.height);
			bmd.draw(reloadManager.loader);
			sendLoadedImage(new Bitmap(bmd));
		}
		
		private function loadingProgressHandler(event:ProgressEvent):void
		{
			dispatchEvent( new LoaderEvent(LoaderEvent.LOAD_PROGRESS, event));
		}
		
		
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
		}
		
		
		private function ioErrorEventHandler(event:ErrorEvent):void
		{
			var error:String;
			if(event is  SecurityErrorEvent)
				error = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "imageSecurityEror") || "This site does not allow you to load the image.";
			else if(event.errorID == 2124)
				error = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "badImageFormatErrorMessage") || "The image you have tried to import is not supported (or is corrupted). Please convert the image to an appropriate file type (.bmp, .gif, .jpg, and .png) and try again.";
			else
				error = event.text;
			
			removeManagers();
			dispatchEvent( new LoaderEvent(LoaderEvent.LOAD_ERROR, error));
		}
		
		
	}
}