////////////////////////////////////////////////////////////////////////////////
// Copyright Sep 12, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.assesment.views.components.list
{
	import flash.events.Event;
	
	import mx.core.ClassFactory;
	
	import spark.components.List;
	import spark.components.RadioButtonGroup;
	
	import tj.ttu.base.vo.AnswerVo;
	import tj.ttu.module.assesment.views.renderers.MultiChoiseAnswerItemRenderer;
	import tj.ttu.module.assesment.views.renderers.SingleChoiseAnswerItemRenderer;
	
	/**
	 * AnswerList class 
	 */
	public class AnswerList extends List
	{
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		[SkinPart(required="true")]
		public var radioButtonGroup:RadioButtonGroup;
		
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
		 * AnswerList 
		 */
		public function AnswerList()
		{
			super();
			itemRendererFunction = activityItemRendereritemFunction;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------------
		// isMultiChoice
		//-----------------------------------------
		private var _isMultiChoice:Boolean;
		
		[Bindable(event="isMultiChoiceChange")]
		public function get isMultiChoice():Boolean
		{
			return _isMultiChoice;
		}
		
		public function set isMultiChoice(value:Boolean):void
		{
			_isMultiChoice = value;
			dispatchEvent(new Event("isMultiChoiceChange"));
		}
		//-----------------------------------------
		// radioGroup
		//-----------------------------------------
		
		
		
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
		public  const singleChoiseClass:ClassFactory = new ClassFactory(SingleChoiseAnswerItemRenderer);
		public  const multiChoiseClass:ClassFactory 	= new ClassFactory(MultiChoiseAnswerItemRenderer) ;
		
		private function activityItemRendereritemFunction(item:Object):ClassFactory 
		{ 
			var act:AnswerVo = item as AnswerVo;
			if(!act)
				return null;
			if(_isMultiChoice)
				return multiChoiseClass;
			
			return singleChoiseClass;
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