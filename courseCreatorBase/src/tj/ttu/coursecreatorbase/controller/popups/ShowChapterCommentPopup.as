////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 25, 2012, Tajik Technical University
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
	
	import tj.ttu.base.coretypes.ChapterVO;
	import tj.ttu.coursecreatorbase.view.components.popup.comment.ChapterCommentPopup;
	import tj.ttu.coursecreatorbase.view.mediators.popup.comment.ChapterCommentMediator;
	import tj.ttu.coursecreatorbase.view.skins.popup.comment.ChapterCommentPopupSkin;
	
	/**
	 * ShowChapterCommentPopup class 
	 */
	public class ShowChapterCommentPopup extends SimpleCommand
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
		 * ShowChapterCommentPopup 
		 */
		public function ShowChapterCommentPopup()
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
			var chapterVO:ChapterVO = note.getBody() as ChapterVO;
			var parent:Sprite;
			
			var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
			// no types so no dependencies
			var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
			if (mp && mp.useSWFBridge())
				parent = Sprite(sm.getSandboxRoot());
			else
				parent = Sprite(FlexGlobals.topLevelApplication);
			
			var popup:ChapterCommentPopup = new ChapterCommentPopup();
			popup.setStyle("skinClass", ChapterCommentPopupSkin);
			
			popup.chapter = chapterVO;
			
			if(facade.hasMediator(ChapterCommentMediator.NAME))
				facade.removeMediator(ChapterCommentMediator.NAME);
			
			facade.registerMediator(new ChapterCommentMediator(popup));
			
			if (parent is UIComponent)
				popup.moduleFactory = UIComponent(parent).moduleFactory;
			else
			{
				popup.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
				// also set document is parent isn't a UIComponent
				popup.document = FlexGlobals.topLevelApplication.document;
			}
			
			PopUpManager.addPopUp( popup, parent, true );
			PopUpManager.centerPopUp( popup );
			popup.setFocus();
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