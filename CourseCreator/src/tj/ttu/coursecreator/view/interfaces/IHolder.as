
////////////////////////////////////////////////////////////////////////////////
// Copyright Oct 23, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.view.interfaces
{
	import flash.events.IEventDispatcher;
	
	import tj.ttu.coursecreator.view.components.CCHeader;
	import tj.ttu.coursecreator.view.components.CCMainView;
	
	public interface IHolder extends IEventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		function get iHeader():CCHeader;
		
		function get iMainView():CCMainView;
		
	}
	
	
}
