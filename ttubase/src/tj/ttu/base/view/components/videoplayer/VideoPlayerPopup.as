////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 29, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.view.components.videoplayer
{
	import flash.events.Event;
	
	import mx.events.CloseEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * VideoPlayerPopup class 
	 */
	public class VideoPlayerPopup extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinPart
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var videoPlayer:TTUVideoPlayer;
		
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
		 * VideoPlayerPopup 
		 */
		public function VideoPlayerPopup()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var videoUrlChanged:Boolean = false;
		private var _videoUrl:String;

		public function get videoUrl():String
		{
			return _videoUrl;
		}

		public function set videoUrl(value:String):void
		{
			if( _videoUrl !== value)
			{
				_videoUrl = value;
				videoUrlChanged = true;
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
			if(videoUrlChanged && videoPlayer)
			{
				videoPlayer.source = _videoUrl;
				videoUrlChanged = false;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if(instance == videoPlayer)
			{
				videoPlayer.addEventListener(CloseEvent.CLOSE, onClose);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == videoPlayer)
			{
				videoPlayer.removeEventListener(CloseEvent.CLOSE, onClose);
			}
			super.partRemoved(partName, instance);
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		/**
		 *  @private
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		protected function onClose(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
	}
}