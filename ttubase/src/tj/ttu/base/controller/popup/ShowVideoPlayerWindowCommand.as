////////////////////////////////////////////////////////////////////////////////
// Copyright Jan 29, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.controller.popup
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.view.components.videoplayer.VideoPlayerPopup;
	import tj.ttu.base.view.mediators.videoplayer.VideoPlayerPopupMediator;
	import tj.ttu.base.view.skins.videoplayer.VideoPlayerPopupSkin;
	
	/**
	 * ShowVideoPlayerWindowCommand class 
	 */
	public class ShowVideoPlayerWindowCommand extends SimpleCommand
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
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * ShowVideoPlayerWindowCommand 
		 */
		public function ShowVideoPlayerWindowCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get root():DisplayObject
		{
			return FlexGlobals.topLevelApplication as DisplayObject;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function execute(notification:INotification):void
		{
			var videoUrl:String = notification.getBody() as String;
			var view:VideoPlayerPopup = new VideoPlayerPopup();
			view.setStyle("skinClass", VideoPlayerPopupSkin);
			if(facade.hasMediator(VideoPlayerPopupMediator.NAME))
				facade.removeMediator(VideoPlayerPopupMediator.NAME);
			facade.registerMediator(new VideoPlayerPopupMediator(view));
			view.videoUrl = videoUrl;
			PopUpManager.addPopUp(view, root, true);
			PopUpManager.centerPopUp(view)
			view.setFocus();
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
		
		/**
		 *  @private
		 */
		
		
	}
}