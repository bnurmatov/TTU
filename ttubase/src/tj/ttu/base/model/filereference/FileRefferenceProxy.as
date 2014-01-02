////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 14, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.model.filereference
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.SupportedMediaFormat;
	
	public class FileRefferenceProxy extends Proxy
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * Proxy Name
		 */
		public static const NAME:String = "FileRefferenceProxy";
		
		/**
		 * Description for extension filter of browse dialog
		 */
		private static const IMAGE_FILTER_DESCRIPTION:String = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "importImageFilterDescription") || "Images";
		
		/**
		 * Description for extension filter of browse dialog
		 */
		private static const SOUND_FILTER_DESCRIPTION:String = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "importSoundFilterDescription") || "Sounds";
		
		/**
		 * Description for extension filter of browse dialog
		 */
		private static const PDF_FILTER_DESCRIPTION:String = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "importPdfFilterDescription") || "PDF Files";
		
		
		/**
		 * Description for extension filter of browse dialog
		 */
		private static const VIDEO_FILTER_DESCRIPTION:String = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "importVideoFilterDescription") || "Video Files (.flv)";
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 * File refrerence
		 */
		private var fileReference:FileReference;
		
		/**
		 * Notification to send upon completion
		 */
		private var completionNotification:String;
		
		/**
		 * Notification to send upon canceling
		 */
		private var cancelNotification:String;
		
		/**
		 * Notification to send upon error
		 */
		private var errorNotification:String;
		
		/**
		 * Notification to send upon show busy indicator
		 */
		private var startSpinNotification:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 */
		public function FileRefferenceProxy()
		{
			super(NAME);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//  Public
		//--------------------------------------------------------------------------
		
		/**
		 * Launch browse dialog for a image, and handle events.
		 * 
		 * @param completionNotification	Notification to send upon load completion.
		 * @param cancelNotification		Notification to send upon canceling.
		 * @param errorNotification			Notification to send upon error.
		 * @param typeFilter				Determines which files the dialog box displays.
		 */
		public function browseForImage(completionNotification:String, cancelNotification:String=null, errorNotification:String=null, typeFilter:Array=null, startSpinNotification:String=null):void
		{
			this.completionNotification = completionNotification;
			this.cancelNotification 	= cancelNotification;
			this.errorNotification		= errorNotification;
			this.startSpinNotification	= startSpinNotification;
			
			// create file ref object, and add listeners
			fileReference = new FileReference();
			attachListeners();
			
			// create extension filter, and launch browse dialog
			var fileFilter:FileFilter = new FileFilter(IMAGE_FILTER_DESCRIPTION, SupportedMediaFormat.getSupportedImageFilterExtensions());
			
			try
			{
				fileReference.browse(typeFilter || [fileFilter]);
			}
			catch(err:Error)
			{
				if(errorNotification)
					sendNotification(errorNotification, err);
			}
		}
		
		/**
		 * Launch browse dialog for a image, and handle events.
		 * 
		 * @param completionNotification	Notification to send upon load completion.
		 * @param cancelNotification		Notification to send upon canceling.
		 * @param errorNotification			Notification to send upon error.
		 * @param typeFilter				Determines which files the dialog box displays.
		 */
		public function browseForSound(completionNotification:String, cancelNotification:String=null, errorNotification:String=null, typeFilter:Array=null, startSpinNotification:String=null):void
		{
			this.completionNotification = completionNotification;
			this.cancelNotification 	= cancelNotification;
			this.errorNotification		= errorNotification;
			this.startSpinNotification	= startSpinNotification;
			
			// create file ref object, and add listeners
			fileReference = new FileReference();
			attachListeners();
			
			// create extension filter, and launch browse dialog
			var fileFilter:FileFilter = new FileFilter(SOUND_FILTER_DESCRIPTION, SupportedMediaFormat.getSupportedSoundFilterExtensions());
			
			try
			{
				fileReference.browse(typeFilter || [fileFilter]);
			}
			catch(err:Error)
			{
				if(errorNotification)
					sendNotification(errorNotification, err);
			}
		}
		
		/**
		 * Launch browse dialog for a resource, and handle events.
		 * 
		 * @param completionNotification	Notification to send upon load completion.
		 * @param cancelNotification		Notification to send upon canceling.
		 * @param errorNotification			Notification to send upon error.
		 * @param typeFilter				Determines which files the dialog box displays.
		 */
		public function browseForBook(completionNotification:String, cancelNotification:String=null, errorNotification:String=null, typeFilter:Array=null, startSpinNotification:String=null):void
		{
			this.completionNotification = completionNotification;
			this.cancelNotification 	= cancelNotification;
			this.errorNotification		= errorNotification;
			this.startSpinNotification	= startSpinNotification;
			
			// create file ref object, and add listeners
			fileReference = new FileReference();
			attachListeners();
			
			// create extension filter, and launch browse dialog
			var fileFilter:FileFilter = new FileFilter(PDF_FILTER_DESCRIPTION, SupportedMediaFormat.getSupportedBookFilterExtensions());
			
			try
			{
				fileReference.browse(typeFilter || [fileFilter]);
			}
			catch(err:Error)
			{
				if(errorNotification)
					sendNotification(errorNotification, err);
			}
		}
		
		/**
		 * Launch browse dialog for a video, and handle events.
		 * 
		 * @param completionNotification	Notification to send upon load completion.
		 * @param cancelNotification		Notification to send upon canceling.
		 * @param errorNotification			Notification to send upon error.
		 * @param typeFilter				Determines which files the dialog box displays.
		 */
		public function browseForVideo(completionNotification:String, cancelNotification:String=null, errorNotification:String=null, typeFilter:Array=null,  startSpinNotification:String=null):void
		{
			this.completionNotification = completionNotification;
			this.cancelNotification 	= cancelNotification;
			this.errorNotification		= errorNotification;
			this.startSpinNotification	= startSpinNotification;
			
			// create file ref object, and add listeners
			fileReference = new FileReference();
			attachListeners();
			var filter:String = SupportedMediaFormat.getSupportedVideoFilterExtensions();
			var description:String = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, "importVideoFilterDescription", [filter]) || "Video Files ("+filter+")";
			// create extension filter, and launch browse dialog
			var fileFilter:FileFilter = new FileFilter(description, filter);
			
			try
			{
				fileReference.browse(typeFilter || [fileFilter]);
			}
			catch(err:Error)
			{
				if(errorNotification)
					sendNotification(errorNotification, err);
			}
		}
		
		//--------------------------------------------------------------------------
		//  Public Overridden
		//--------------------------------------------------------------------------
		/**
		 * Prepare any data
		 */
		public override function onRegister():void
		{
			super.onRegister();
		}
		
		/**
		 * Clean up
		 */
		public override function onRemove():void
		{
			detachListeners();
			
			fileReference 			= null;
			completionNotification 	= null;
			cancelNotification 		= null;
			errorNotification 		= null;
			startSpinNotification	= null;
			super.onRemove();
		}
		
		//--------------------------------------------------------------------------
		//  Private
		//--------------------------------------------------------------------------
		/**
		 * Add any listeners
		 */
		private function attachListeners():void 
		{
			if(fileReference)
			{
				fileReference.addEventListener(Event.SELECT, selectHandler);
				fileReference.addEventListener(Event.COMPLETE, completeHandler);
				fileReference.addEventListener(Event.CANCEL, cancelHandler);
				fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				fileReference.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				fileReference.addEventListener(Event.OPEN, openHandler);
				fileReference.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			}
		}
		
		/**
		 * Remove any listeners
		 */
		private function detachListeners():void 
		{
			if(fileReference)
			{
				fileReference.removeEventListener(Event.SELECT, selectHandler);
				fileReference.removeEventListener(Event.COMPLETE, completeHandler);
				fileReference.removeEventListener(Event.CANCEL, cancelHandler);
				fileReference.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				fileReference.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				fileReference.removeEventListener(Event.OPEN, openHandler);
				fileReference.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			}
		}
		
		
		//--------------------------------------------------------------------------
		//  Private Event Handlers
		//--------------------------------------------------------------------------
		/**
		 * Selection event, triggered when the user submits with a selected file
		 */
		private function selectHandler(event:Event):void
		{
			sendNotification( startSpinNotification );
			fileReference.load();
		}
		
		/**
		 * Completion handler, when a file is selected
		 */
		private function completeHandler(event:Event):void
		{
			detachListeners();
			sendNotification(completionNotification, fileReference);
			facade.removeProxy(NAME);
		}
		
		/**
		 * Handle a 'cancel' button click
		 */
		private function cancelHandler(event:Event):void 
		{
			detachListeners();
			if(cancelNotification)
				sendNotification(cancelNotification);
			facade.removeProxy(NAME);
		}
		
		/**
		 * Handle status
		 */
		private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
		}
		
		/**
		 * Handle io error
		 */
		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			detachListeners();
			if(errorNotification)
				sendNotification(errorNotification, event);
			facade.removeProxy(NAME);
		}
		
		/**
		 * handle open
		 */
		private function openHandler(event:Event):void 
		{
		}
		
		/**
		 * handle progress
		 */
		private function progressHandler(event:ProgressEvent):void 
		{
		}
		
		/**
		 * handle security error
		 */
		private function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			detachListeners();
			if(errorNotification)
				sendNotification(errorNotification, event);
			facade.removeProxy(NAME);
		}
	}
}