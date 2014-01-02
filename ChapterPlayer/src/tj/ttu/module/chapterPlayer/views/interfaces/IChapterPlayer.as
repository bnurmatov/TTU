
////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 13, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.views.interfaces
{
	import tj.ttu.module.chapterPlayer.views.components.ChapterPlayerPanel;
	import tj.ttu.module.chapterPlayer.views.components.StartScreenView;

	public interface IChapterPlayer
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  Returns module name
		 */
		function get moduleName():String;
		
		/**
		 *  Returns module view reference
		 */		
		function get view():ChapterPlayerPanel;
		
		/**
		 *  Returns module view reference
		 */		
		function get startScreen():StartScreenView;
		
	}
	
	
}
