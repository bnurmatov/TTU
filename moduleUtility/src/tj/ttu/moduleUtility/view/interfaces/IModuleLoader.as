
////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.view.interfaces
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IVisualElement;
	
	public interface IModuleLoader extends IEventDispatcher, IVisualElement
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		function get module():IModule;
		
		function load(url:String):void;
		
		function get url():String
		
		function unloadModule():void;
		
	}
	
	
}
