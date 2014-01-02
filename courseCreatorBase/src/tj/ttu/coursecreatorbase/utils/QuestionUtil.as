////////////////////////////////////////////////////////////////////////////////
// Copyright Feb 7, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreatorbase.utils
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.vo.AnswerVo;
	import tj.ttu.base.vo.QuestionVo;
	
	/**
	 * QuestionUtil class 
	 */
	public class QuestionUtil
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
		 * QuestionUtil 
		 */
		public function QuestionUtil()
		{
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
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		/**
		 * 
		 * @param question QuestionVO
		 * @return QuestionVO
		 * 
		 */		
		public static function cloneQuestion( question:QuestionVo ) : QuestionVo
		{
			var clone:QuestionVo = new QuestionVo();
			
			clone.guid 					= question.guid;
			clone.incorrectAnswerHint 	= question.incorrectAnswerHint;
			clone.selected 				= question.selected;
			clone.text 					= question.text;
			clone.answers 				= cloneAnswers(question.answers);
			
			return clone;
		}
		
		private static function cloneAnswers(answers:IList):IList
		{
			if(!answers) return null;
			var list:IList = new ArrayCollection();
			for each(var item:AnswerVo in answers)
			{
				if(item)
					list.addItem(cloneAnswer(item));
			}
			return list; 
		}
		
		private static function cloneAnswer(answer:AnswerVo):AnswerVo
		{
			var clone:AnswerVo = new AnswerVo();
			clone.guid 				= answer.guid;
			clone.isCorrect 		= answer.isCorrect;
			clone.isNotSaveToServer = answer.isNotSaveToServer;
			clone.position 			= answer.position;
			clone.text 				= answer.text;
			return clone;
		}
		
		public static function compareQuestion( src:QuestionVo, desc:QuestionVo ) : Boolean
		{
			if(!src || !desc)
				return false;
			
			var properties:Array = [ 'incorrectAnswerHint', 'text', 'answers' ];
			
			for each( var property:String in properties )
			{
				if(property == 'answers')
				{
					if( compareAnswers( src[ property ], desc[ property ] ))
						return true;
				}
				else
				{
					if( StringUtil.compare( src[ property ], desc[ property ] ))
						return true;
				}
			}
			
			return false;
		}
		
		public static function compareAnswers( src:IList, desc:IList ) : Boolean
		{
			if(!src || !desc)
				return false;
			
			if(src.length != desc.length)
				return true;
			else
			{
				for(var i:int = 0; i < src.length; i++)
				{
					if( compareAnswer(src.getItemAt( i ) as AnswerVo, desc.getItemAt( i ) as AnswerVo))
						return true;
				}
			}
			return false;
		}
		
		public static function compareAnswer( src:AnswerVo, desc:AnswerVo ) : Boolean
		{
			if(!src || !desc)
				return false;
			var properties:Array = [ 'isCorrect', 'text'];
			for each( var property:String in properties )
			{
				if(property == 'isCorrect')
				{
					if(  src[ property ] != desc[ property ] )
						return true;
				}
				else
				{
					if( StringUtil.compare( src[ property ], desc[ property ] ))
						return true;
				}
			}
			
			return false;
		}
	}
}