////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 7, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.controller.popups
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.view.components.popup.image.InsertImagePopup;
	import tj.ttu.coursecreatorbase.view.mediators.popup.image.InsertImagePopupMediator;
	import tj.ttu.coursecreatorbase.view.skins.popup.image.InsertImagePopupSkin;
	import tj.ttu.courseservice.constants.CourseServiceNotification;
	import tj.ttu.courseservice.model.vo.MediaVO;
	
	/**
	 * ShowInsertImagePopup class 
	 */
	public class ShowInsertImagePopup extends SimpleCommand
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
		 * ShowInsertImagePopup 
		 */
		public function ShowInsertImagePopup()
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
		override public function execute(note:INotification):void
		{
			var mediaVo:MediaVO = note.getBody() as MediaVO;
			var rootApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			var view:InsertImagePopup = new InsertImagePopup();
			var insertNotification:String = CourseServiceNotification.ASSOCIATE_IMAGE;
			switch(note.getName())
			{
				case CourseCreatorNotifications.SHOW_INSERT_IMAGE_WINDOW:
					insertNotification = CourseServiceNotification.ASSOCIATE_IMAGE;
					view.setStyle("skinClass", InsertImagePopupSkin);
					break;
				default:
					view.setStyle("skinClass", InsertImagePopupSkin);
			}
			
			var nw:Number =  Math.min(rootApp.width, 	800);
			var nh:Number =  Math.min(rootApp.height, 600);
			var factor:Number =Math.min(0.8, Math.min(nw / 800, nh / 600));
			view.width = nw *factor;
			view.height =nh *factor;
			
			view.mediaVo = mediaVo;
			
			if(facade.hasMediator(InsertImagePopupMediator.NAME))
				facade.removeMediator(InsertImagePopupMediator.NAME);
			
			facade.registerMediator(new InsertImagePopupMediator(view, insertNotification));
			PopUpManager.addPopUp( view, rootApp, true );
			PopUpManager.centerPopUp( view );
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