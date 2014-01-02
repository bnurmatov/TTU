
////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.view.interfaces
{
	import flash.events.IEventDispatcher;
	
	import tj.ttu.base.view.interfaces.IAudioController;
	import tj.ttu.lessonplayer.view.components.LessonPlayerMainView;
	import tj.ttu.lessonplayer.view.components.window.LessonPlayerStatusBar;

	public interface ILessonPlayer extends IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		function get iMainView():LessonPlayerMainView;
		
		function get iaudioPlayer():IAudioController;
		
		function set version(value:String):void; 
		
		function set versionVisible(value:Boolean):void; 
		
		function get istatus():LessonPlayerStatusBar;
		
	}
	
	
}
