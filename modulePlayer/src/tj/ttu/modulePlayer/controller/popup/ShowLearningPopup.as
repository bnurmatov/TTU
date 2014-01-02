////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.controller.popup
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import spark.components.Label;
	import spark.components.TitleWindow;
	
	import tj.ttu.modulePlayer.view.components.popup.LearningPopup;
	import tj.ttu.modulePlayer.view.mediators.popup.LearningPopupMediator;
	import tj.ttu.modulePlayer.view.skins.popup.StepCompletePopupSkin;
	import tj.ttu.moduleUtility.vo.StepVO;
	
	/**
	 * ShowLearningPopup class 
	 */
	public class ShowLearningPopup extends SimpleCommand
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
		 * ShowLearningPopup 
		 */
		public function ShowLearningPopup()
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
		/**
		 *  Launch learning popups.
		 */ 
		override public function execute(note:INotification):void
		{
			var step:StepVO = note.getBody() as StepVO;
			var rootApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
			
			var parent:Sprite;
			var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
			// no types so no dependencies
			var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
			if (mp && mp.useSWFBridge())
				parent = Sprite(sm.getSandboxRoot());
			else
				parent = Sprite(FlexGlobals.topLevelApplication);
			
			
			var view:LearningPopup = new LearningPopup();
			view.setStyle("skinClass", StepCompletePopupSkin);
			view.width 	= rootApp.width;
			view.height = rootApp.height;
			view.step 		= step.step;
			
			if(facade.hasMediator(LearningPopupMediator.NAME))
				facade.removeMediator(LearningPopupMediator.NAME);
			facade.registerMediator(new LearningPopupMediator(view));
			
			// Setting a module factory allows the correct embedded font to be found.
			if (parent is UIComponent)
				view.moduleFactory = UIComponent(parent).moduleFactory;
			else
			{
				view.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;
				// also set document is parent isn't a UIComponent
				view.document = FlexGlobals.topLevelApplication.document;
			}
			
			PopUpManager.addPopUp( view, parent, true, null, view.moduleFactory );
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