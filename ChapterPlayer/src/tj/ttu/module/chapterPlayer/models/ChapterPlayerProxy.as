////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 11, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.models
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.base.coretypes.LessonVO;
	import tj.ttu.base.vo.ConfigurationVO;
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerNotifications;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ScoreMessage;
	import tj.ttu.moduleUtility.vo.ScoreVO;
	
	/**
	 * ChapterPlayerProxy class 
	 */
	public class ChapterPlayerProxy extends Proxy
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ChapterPlayerProxy';
		
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
		 * ChapterPlayerProxy 
		 */
		public function ChapterPlayerProxy()
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
				chapters 	= _lesson ? _lesson.chapters 	: null;
			}
		}
		
		//--------------------------------------
		//  chapters
		//--------------------------------------
		private var _chapters:Array
		
		public function get chapters():Array
		{
			return _chapters;
		}
		
		public function set chapters(value:Array):void
		{
			if( _chapters !== value)
			{
				_chapters = value;
				//currentChapter = (_chapters && currentChapterIndex != -1) ? _chapters[currentChapterIndex] : null;
			}
		}
		
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
			chapters = null;
			moduleDescription = null;
			config = null;
			completed = false;
		}
		
		/**
		 *  Creates <code>ScoreMessage</code> and sends notification
		 *  @parameter changedScores the list of the changed scores.
		 */
		public function sendStatus( changedScores:Array = null ):void
		{
			var scoreVo:ScoreVO = new ScoreVO();
			scoreVo.changedScores = changedScores;
			/*scoreVo.correct 	= correct;
			scoreVo.total 		= total;
			scoreVo.position 	= position;*/
			scoreVo.data 		= config ? config.data as Array: null;
			
			var activityStatus:String = completed ?
				MessageConstants.MODULE_COMPLETED: 
				MessageConstants.MODULE_INCOMPLETE;
			
			var sm:ScoreMessage = new ScoreMessage(
				PipeConstants.MODULE_TO_SHELL_MESSAGE, 
				activityStatus,
				scoreVo);
			
			sendNotification(ChapterPlayerNotifications.SEND_MESSAGE_TO_SHELL, sm);	
		} 	
		
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