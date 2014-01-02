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
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.resources.ResourceManager;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.events.LoaderEvent;
	import tj.ttu.base.utils.BMPDecoder;
	import tj.ttu.base.utils.SupportedFileFormat;
	import tj.ttu.base.utils.SupportedMediaFormat;
	
	[Event(name="loadComplete", 	type="tj.ttu.base.events.LoaderEvent")]
	[Event(name="loadError", 		type="tj.ttu.base.events.LoaderEvent")]
	[Event(name="loadProgress", 	type="tj.ttu.base.events.LoaderEvent")]
	[Event(name="cancel", 			type="tj.ttu.base.events.LoaderEvent")]
	/**
	 * ImageFileLoader class 
	 */
	public class ImageFileLoader extends EventDispatcher
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		/**
		 * Description for extension filter of browse dialog
		 */
		private static const IMAGE_FILTER_DESCRIPTION:String = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "importImageFilterDescription") || "Images";
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		private var fileManager:FileReference;
		private var reloadManager:LoaderInfo;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ImageFileLoader 
		 */
		public function ImageFileLoader(target:IEventDispatcher=null)
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
		
		public function load():void
		{
			fileManager = new FileReference();
			fileManager.addEventListener( Event.SELECT, selectFileHandler );
			fileManager.addEventListener( Event.CANCEL, cancelFileHandler );
			fileManager.addEventListener( IOErrorEvent.IO_ERROR, ioErrorEventHandler );
			fileManager.addEventListener( SecurityErrorEvent.SECURITY_ERROR, ioErrorEventHandler );
			fileManager.addEventListener( ErrorEvent.ERROR, ioErrorEventHandler );
			
			// create extension filter, and launch browse dialog
			var fileFilter:FileFilter = new FileFilter(IMAGE_FILTER_DESCRIPTION, SupportedMediaFormat.getSupportedImageFilterExtensions());
			
			try
			{
				fileManager.browse([fileFilter]);
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
		private function removeManagers() : void
		{
			removeHandlers();
			fileManager 	= null;
			reloadManager	= null;
		}
		
		
		private function removeHandlers() : void
		{
			if( fileManager )
			{
				fileManager.removeEventListener( Event.SELECT, selectFileHandler );
				fileManager.removeEventListener( Event.CANCEL, cancelFileHandler );
				fileManager.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorEventHandler );
				fileManager.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, ioErrorEventHandler );
				fileManager.removeEventListener( ErrorEvent.ERROR, ioErrorEventHandler );
				fileManager.removeEventListener( Event.COMPLETE, fileLoadedHandler );
				fileManager.removeEventListener( ProgressEvent.PROGRESS, loadingProgressHandler );
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
		
		private function convertBMPImage(data:ByteArray):void
		{
			var bmpUtil:BMPDecoder =  new BMPDecoder();
			var bmpBitmap:BitmapData = bmpUtil.decode( data );
			var resultBitmap:Bitmap = new Bitmap( bmpBitmap );
			sendLoadedImage(resultBitmap);
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
		private function selectFileHandler(event:Event):void
		{
			fileManager.addEventListener( Event.COMPLETE, fileLoadedHandler );
			fileManager.addEventListener( ProgressEvent.PROGRESS, loadingProgressHandler );
			fileManager.load();
		}
		
		private function fileLoadedHandler(event:Event):void
		{
			var fileType:String = SupportedFileFormat.extractFileType(fileManager);
			if(fileType == SupportedMediaFormat.BMP_TYPE)
				convertBMPImage(fileManager.data);
			else
				showImage( fileManager.data );
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
		
		
		private function cancelFileHandler(event:Event):void
		{
			removeManagers();
			dispatchEvent( new LoaderEvent(LoaderEvent.CANCEL));
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