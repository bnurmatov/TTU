////////////////////////////////////////////////////////////////////////////////
// Copyright May 30, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller.publish
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.airservice.controller.BaseAirCommand;
	import tj.ttu.airservice.utils.FileNameUtil;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.vo.LessonArtifactVO;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	
	/**
	 * SaveArtifactToLocalDiskCommand class 
	 */
	public class SaveArtifactToLocalDiskCommand extends BaseAirCommand
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
		private var loader:URLLoader;
		private var fileReference:FileReference;
		private var vo:LessonArtifactVO;
		private var fileData:ByteArray;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * SaveArtifactToLocalDiskCommand 
		 */
		public function SaveArtifactToLocalDiskCommand()
		{
			super();
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
		override public function execute(notification:INotification):void
		{
			vo = notification.getBody() as LessonArtifactVO;
			if(vo)
			{
				initLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.load( new URLRequest(vo.url));
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		private function initLoader():void
		{
			if(!loader)
			{
				loader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
		}
		
		private function destroyLoader():void
		{
			if(loader)
			{
				loader.removeEventListener(Event.COMPLETE, onLoadComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				loader = null;
			}
		}
		
		private function initFileReference():void
		{
			if(!fileReference)
			{
				fileReference = new FileReference();
				fileReference.addEventListener(Event.COMPLETE, onSaveComplete);
				fileReference.addEventListener(Event.CANCEL, onCancelSave);
				fileReference.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
		}
		
		private function destroyFileReference():void
		{
			if(fileReference)
			{
				fileReference.removeEventListener(Event.COMPLETE, onSaveComplete);
				fileReference.removeEventListener(Event.CANCEL, onCancelSave);
				fileReference.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				fileReference = null;
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
		protected function onLoadComplete(event:Event):void
		{
			fileData = loader.data as ByteArray;
			destroyLoader();
			initFileReference();
			var fileName:String = FileNameUtil.getFileName(vo.url).replace(/%20/g, " ");
			fileName = fileName.replace(/[\:*?"<>|%]/g, "");
			fileReference.save(fileData, fileName);
		}
		
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			destroyLoader();
			destroyFileReference();
			sendNotification( TTUConstants.SHOW_ERROR_WINDOW, event.text );
		}
		
		protected function onIOError(event:IOErrorEvent):void
		{
			destroyLoader();
			destroyFileReference();
			sendNotification( TTUConstants.SHOW_ERROR_WINDOW, event.text );
		}
		
		protected function onCancelSave(event:Event):void
		{
			destroyFileReference();
			sendNotification(CourseServiceNotification.SAVE_ARTIFACT_TO_DISK_CANCELED);
		}
		
		protected function onSaveComplete(event:Event):void
		{
			destroyFileReference();
			sendNotification(CourseServiceNotification.ARTIFACT_TO_DISK_SAVED);
		}		
		
	}
}