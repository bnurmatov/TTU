////////////////////////////////////////////////////////////////////////////////
// Copyright Aug 28, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.models
{
	import flash.events.Event;
	
	import mx.collections.IList;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.ConfigurationVO;
	import tj.ttu.module.assesment.constants.AssesmentNotifications;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModuleMessage;
	import tj.ttu.moduleUtility.utils.messages.ModulePipeMessage;
	import tj.ttu.moduleUtility.utils.messages.ScoreMessage;
	import tj.ttu.moduleUtility.vo.ScoreVO;
	
	/**
	 * AssesmentProxy class 
	 */
	public final class AssesmentPlayerProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 * proxy name
		 */
		public static const NAME:String = 'AssesmentProxy';
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var config:ConfigurationVO;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * AssesmentProxy 
		 */
		public function AssesmentPlayerProxy()
		{
			super(NAME);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------------
		//  lessonVO
		//--------------------------------------
		private var _lesson:LessonVO;
		
		public function get lesson():LessonVO
		{
			return _lesson;
		}
		
		public function set lesson(value:LessonVO):void
		{
			if( _lesson !== value)
			{
				_lesson = value;
			}
		}
		
		//--------------------------------------
		//  questions
		//--------------------------------------
		private var _questions:IList;

		public function get questions():IList
		{
			return _questions;
		}

		public function set questions(value:IList):void
		{
			_questions = value;
			total = _questions ? _questions.length : 0;
			if(_questions)
			{
				var message:ModuleMessage = new ModuleMessage(
					PipeConstants.MODULE_TO_SHELL_MESSAGE, 
					MessageConstants.ASSESSMENT_QUESTIONS,
					_questions);
				
				sendNotification(AssesmentNotifications.SEND_MESSAGE_TO_SHELL, message);
			}
		}

		//--------------------------------------
		//  chapters
		//--------------------------------------
		
		
		//--------------------------------------
		//  moduleDescription
		//--------------------------------------
		private var _moduleDescription:String;
		
		public function get moduleDescription():String
		{
			return _moduleDescription;
		}
		
		public function set moduleDescription(value:String):void
		{
			_moduleDescription = value;
		}
		
		//--------------------------------------
		//  activityName
		//--------------------------------------
		/**
		 * Activity name 
		 */
		public function get activityName():String
		{
			return config ? config.activityName : null;
		}
		//--------------------------------------
		//  muted
		//--------------------------------------
		public function get muted():Boolean
		{
			return config ? config.muted : false;
		}
		//--------------------------------------
		//  volume
		//--------------------------------------
		public function get volume():Number
		{
			return config ? config.volume : 0;
		}
		//--------------------------------------
		//  tempoEnabled
		//--------------------------------------
		public function get tempoEnabled():Boolean
		{
			return config ? config.tempoEnabled : false;
		}
		//--------------------------------------
		//  completed
		//--------------------------------------
		private var _completed:Boolean;
		
		public function get completed():Boolean
		{
			return _completed;
		}
		
		public function set completed(value:Boolean):void
		{
			_completed = value;
		}
		//--------------------------------------
		//  correct
		//--------------------------------------
		private var _correct:uint = 0;

		public function get correct():uint
		{
			return _correct;
		}

		public function set correct(value:uint):void
		{
			if( _correct !== value)
			{
				_correct = value;
			}
		}
		//--------------------------------------
		//  total
		//--------------------------------------
		private var _total:int = 0;

		public function get total():int
		{
			return _total;
		}

		public function set total(value:int):void
		{
			_total = value;
		}

		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		override public function onRemove():void
		{
			cleanUp();
			super.onRemove();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		public function cleanUp():void
		{
			lesson = null;
			moduleDescription = null;
			config = null;
			questions = null;
			completed = false;
			total = 0;
			correct = 0;
		}
		
		/**
		 *  Creates <code>ScoreMessage</code> and sends notification
		 *  @parameter changedScores the list of the changed scores.
		 */
		public function sendStatus( changedScores:Array = null, userAnswers:Array=null ):void
		{
			var scoreVo:ScoreVO = new ScoreVO();
			scoreVo.changedScores = changedScores;
			scoreVo.userAnswers = userAnswers;
			scoreVo.correct 	= correct;
			scoreVo.total 		= total;
			scoreVo.data 		= config ? config.data as Array: null;
			
			var activityStatus:String = completed ?
				MessageConstants.MODULE_COMPLETED: 
				MessageConstants.MODULE_INCOMPLETE;
			
			var sm:ScoreMessage = new ScoreMessage(
				PipeConstants.MODULE_TO_SHELL_MESSAGE, 
				activityStatus,
				scoreVo);
			
			sendNotification(AssesmentNotifications.SEND_MESSAGE_TO_SHELL, sm);	
		} 	
	}
}