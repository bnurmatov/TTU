
////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.view.interfaces
{
	import flash.events.IEventDispatcher;
	
	import tj.ttu.base.view.interfaces.IAudioController;
	import tj.ttu.coursecreator.view.components.window.CCStatusBar;

	public interface ICourseCreator extends IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		function get iholder():IHolder;
		
		function get iaudioPlayer():IAudioController;
		
		function set version(value:String):void; 
		
		function set versionVisible(value:Boolean):void; 
		
		function get istatus():CCStatusBar;
		
	}
	
	
}
