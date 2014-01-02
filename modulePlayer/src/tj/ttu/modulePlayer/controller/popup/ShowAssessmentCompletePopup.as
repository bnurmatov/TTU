////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 3, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.controller.popup
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.components.components.popup.ConfirmationPopup;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.modulePlayer.view.components.popup.AssessmentCompletePopup;
	import tj.ttu.modulePlayer.view.mediators.popup.AssessmentCompletePopupMediator;
	import tj.ttu.modulePlayer.view.skins.popup.AssessmentCompletePopupSkin;
	import tj.ttu.moduleUtility.vo.StepVO;
	
	/**
	 * ShowAssessmentCompletePopup class 
	 */
	public class ShowAssessmentCompletePopup extends SimpleCommand
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
		 * ShowAssessmentCompletePopup 
		 */
		public function ShowAssessmentCompletePopup()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------
		//	assessmentProxy
		//-----------------------------------
		
		/**
		 * @private
		 * Storage for the assessmentProxy property.
		 */
		private var _assessmentProxy:AssessmentProxy;
		
		/**
		 * Reference to the <code>AssessmentProxy</code>.
		 */
		public function get assessmentProxy():AssessmentProxy
		{
			if (!this._assessmentProxy)
				this._assessmentProxy = this.facade.retrieveProxy(AssessmentProxy.NAME) as AssessmentProxy;
			
			return this._assessmentProxy;
		}		
		
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
			var view:AssessmentCompletePopup = new AssessmentCompletePopup();
			view.setStyle("skinClass", AssessmentCompletePopupSkin);
			view.width 	= rootApp.width;
			view.height = rootApp.height;
			view.step 		= step.step;
			view.correct 	= step.correct;
			view.incorrect 	= step.incorrect;
			view.total 		= step.total;
			view.score 		= step.completed;
			view.userAnswers= step.answers;
			view.isPassed	= assessmentProxy.isPassed;
			if(facade.hasMediator(AssessmentCompletePopupMediator.NAME))
				facade.removeMediator(AssessmentCompletePopupMediator.NAME);
			
			facade.registerMediator(new AssessmentCompletePopupMediator(view));
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