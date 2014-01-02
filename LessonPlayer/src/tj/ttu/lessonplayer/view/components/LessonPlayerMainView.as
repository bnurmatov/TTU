////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 29, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.view.components
{
	import spark.components.supportClasses.SkinnableComponent;
	
	import tj.ttu.lessonplayer.view.components.header.HeaderView;
	import tj.ttu.modulePlayer.view.components.LessonHolderMainView;
	
	/**
	 * LessonPlayerMainView class 
	 */
	public class LessonPlayerMainView extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		[SkinPart(required="true")]
		public var headerView:HeaderView;
		
		[SkinPart(required="true")]
		public var lessonHolder:LessonHolderMainView;
		//----------------------------------------;----------------------------------
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
		 * CCMainView 
		 */
		public function LessonPlayerMainView()
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