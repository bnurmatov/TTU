////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.vo.ModuleVO;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.utils.messages.ScoreMessage;
	import tj.ttu.moduleUtility.view.interfaces.IModulePipeMessage;
	import tj.ttu.moduleUtility.vo.ScoreVO;
	import tj.ttu.moduleUtility.vo.StepVO;
	
	/**
	 * HandleModuleMessage class 
	 */
	public class HandleModuleMessageCommand extends SimpleCommand
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
		/**
		 * Holds ScoreVo objects which is in message's body 
		 */ 
		private var scoreVo:ScoreVO;
		private var step:StepVO;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * HandleModuleMessage 
		 */
		public function HandleModuleMessageCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _moduleProxy:ModuleProxy;
		
		public function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
			return _moduleProxy;
		}
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
		
		override public function execute(note:INotification):void
		{
			var msg:IModulePipeMessage = note.getBody() as IModulePipeMessage;
			if(!msg || !moduleProxy && !moduleProxy.currentModule)
				return;
			scoreVo = cloneScoreVO(ScoreMessage(msg).scoreVo);
			step = getStep();
			
			if(assessmentProxy.isAssessment)
			{
				assessmentProxy.score = scoreVo;
				handleAssessment(msg);
				// server mode only: save assessment status
				//saveUnitStatus();
				return;
			}
			
			if(scoreVo)
				moduleProxy.scoreVo = scoreVo;
			
			var lessonIndex:int = moduleProxy.currentModuleIndex;
			
			
			switch(msg.contentType)
			{
				case MessageConstants.MODULE_DONE:
					handleDoneComplete();
					//saveUnitStatus();
					break;
				case MessageConstants.MODULE_COMPLETED:
					handleModuleComplete();
					break;
				case MessageConstants.MODULE_STARTED:
					
				case MessageConstants.MODULE_INCOMPLETE:
					handleModuleIncomplete();
					//saveUnitStatus();
					break;
			}
		}
		
		private function cloneScoreVO(scoreVo:ScoreVO):ScoreVO
		{
			if(!scoreVo)
			return null;
			var vo:ScoreVO = new ScoreVO();
			vo.changedScores 	= scoreVo.changedScores;
			vo.correct 			= scoreVo.correct;
			vo.data 			= scoreVo.data;
			vo.hasFeedback 		= scoreVo.hasFeedback;
			vo.incorrect 		= scoreVo.incorrect;
			vo.lastAnswerPercentage = scoreVo.lastAnswerPercentage;
			vo.lastChapter 		= scoreVo.lastChapter;
			vo.position 		= scoreVo.position;
			vo.total 			= scoreVo.total;
			vo.userAnswers 		= scoreVo.userAnswers;
			vo.wasDoneButton 	= scoreVo.wasDoneButton;
			return vo;
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
		/**
		 * @private
		 */
		private function getStep():StepVO
		{
			var nextModule:ModuleVO;
			var nextIndex:int = moduleProxy.currentModuleIndex + 1;
			if(moduleProxy.modules.length > nextIndex)
				nextModule = moduleProxy.modules.getItemAt(nextIndex) as ModuleVO;
			return  new StepVO(nextIndex, nextModule?nextModule.moduleURL:null); 
		}
		/**
		 * @private
		 * Handles <code>MessageConstants.ASSESSMENT_PASSED</code>
		 */
		private function handleAssessment(msg:IModulePipeMessage):void
		{
			switch(msg.contentType)
			{
				case MessageConstants.MODULE_COMPLETED:
					assessmentProxy.score = scoreVo;
					handleAssessmentModuleComplete();
					break;
				case MessageConstants.MODULE_STARTED:
				case MessageConstants.MODULE_INCOMPLETE:
					assessmentProxy.score = scoreVo;
					break;
				default:
					break;
			}
			//saveUnitStatus();
		}
		
		private function handleAssessmentModuleComplete():void
		{
			if(assessmentProxy.isPassed)
			{
				assessmentProxy.isAssessmentComplete = true;
				assessmentProxy.status = ModuleStatus.PASSED;
				moduleProxy.setStatus(ModuleStatus.PASSED);
				sendNotification(TTUConstants.PLAY_SOUND, MessageConstants.CORRECT_SOUND);			
			}
			else if(!assessmentProxy.isPassed)
			{
				assessmentProxy.isAssessmentComplete = true;
				assessmentProxy.status = ModuleStatus.FAILED;
				moduleProxy.setStatus(ModuleStatus.FAILED);
				sendNotification(TTUConstants.RESUME_LESSON);
				sendNotification( TTUConstants.PLAY_SOUND, MessageConstants.INCORRECT_SOUND);
			}
			
			step.completed 		= (scoreVo.correct/scoreVo.total) * 100;
			step.correct 		= scoreVo.correct;
			step.incorrect 		= scoreVo.total - scoreVo.correct;
			step.total 			= scoreVo.total;
			step.answers		= scoreVo.userAnswers;
			sendNotification(TTUConstants.ASSESMENT_COMPLETE, step);
		}
		
		
		/**
		 * @private
		 * Handles <code>MessageConstants.MODULE_DONE</code>
		 */
		private function handleDoneComplete():void
		{
			if(!moduleProxy.currentModule)
				return;
			
			moduleProxy.setStatus(ModuleStatus.COMPLETED);
			sendNotification(TTUConstants.LEARNING_COMPLETE, step);
		}
		
		/**
		 * @private
		 * Handles <code>MessageConstants.MODULE_COMPLETED</code>
		 */
		private function handleModuleComplete():void
		{
			if(!moduleProxy.currentModule)
				return;
			
			if(moduleProxy.currentModule.status != ModuleStatus.COMPLETED)
			{
				//saveUnitStatus();
				moduleProxy.setStatus(ModuleStatus.COMPLETED);
			}
			sendNotification(TTUConstants.LEARNING_COMPLETE, step);
		}
		
		/**
		 * @private
		 * Handles <code>MessageConstants.MODULE_INCOMPLETE</code>
		 */
		private function handleModuleIncomplete():void
		{
			if(!moduleProxy.currentModule)
				return;
			
			moduleProxy.setStatus(ModuleStatus.INCOMPLETE);
			sendNotification(TTUConstants.MODULE_INCOMPLETE);
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
		
		
	}
}