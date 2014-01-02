////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 19, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.controller.popups
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.model.resource.ResourceProxy;
	import tj.ttu.coursecreatorbase.constants.CourseCreatorNotifications;
	import tj.ttu.coursecreatorbase.model.CourseProxy;
	import tj.ttu.coursecreatorbase.view.components.popup.CourseManagePopup;
	import tj.ttu.coursecreatorbase.view.mediators.popup.CourseManagePopupMediator;
	import tj.ttu.coursecreatorbase.view.skins.popup.CreateCoursePopupSkin;
	
	/**
	 * ShowCourseManagePopup class 
	 */
	public class ShowCourseManagePopup extends SimpleCommand
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
		 * ShowCourseManagePopup 
		 */
		public function ShowCourseManagePopup()
		{
			super();
		}
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get courseProxy():CourseProxy
		{
			return facade.retrieveProxy( CourseProxy.NAME ) as CourseProxy;
		}
		
		/**
		 * we currently only have a single user system 
		 */
		private var _resourceProxy:ResourceProxy;
		
		public function get resourceProxy():ResourceProxy
		{
			if(!_resourceProxy)
				_resourceProxy = facade.retrieveProxy( ResourceProxy.NAME ) as ResourceProxy;
			return _resourceProxy;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function execute(note:INotification):void
		{
			var rootApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			var view:CourseManagePopup = new CourseManagePopup();
			switch(note.getName())
			{
				case CourseCreatorNotifications.SHOW_CREATE_LESSON_POPUP:
					view.lesson = null;
					view.isCreateLesson = true;
					view.closeEnable = courseProxy.currentLesson != null;
					break;
				case CourseCreatorNotifications.SHOW_EDIT_LESSON_DETAILS_POPUP:
					if(courseProxy)
						view.lesson = courseProxy.currentLesson;
					view.isCreateLesson = false;
					break;
				case CourseCreatorNotifications.SHOW_CLONE_LESSON_POPUP:
					view.isReuseContent = true;
					view.lesson = note.getBody() as LessonVO;
					view.duplicateName();
					break;
			}
			view.locale = resourceProxy.locale;
			view.width = rootApp.width;
			view.height = rootApp.height;
			
			
			var parent:Sprite;
			var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
			// no types so no dependencies
			var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
			if (mp && mp.useSWFBridge())
				parent = Sprite(sm.getSandboxRoot());
			else
				parent = Sprite(FlexGlobals.topLevelApplication);
			
			// Setting a module factory allows the correct embedded font to be found.
			if (parent is UIComponent)
				view.moduleFactory = UIComponent(parent).moduleFactory;
			else
			{
				view.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
				// also set document is parent isn't a UIComponent
				view.document = FlexGlobals.topLevelApplication.document;
			}
			
			if(facade.hasMediator( CourseManagePopupMediator.NAME ))
				facade.removeMediator( CourseManagePopupMediator.NAME );
			facade.registerMediator( new CourseManagePopupMediator(view));
			PopUpManager.addPopUp( view , parent, true);
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