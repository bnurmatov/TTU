
////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.moduleUtility.view.interfaces
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IStateClient;
	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	
	public interface IModule extends IEventDispatcher, IStateClient
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Removes PureMVC objects and prepares component for garbage collection .
		 */		
		function dispose():void;
		
		/**
		 * Accept an input pipe.
		 * <p>
		 * Registers an input pipe with this module's Junction.</p>
		 */
		function acceptInputPipe( name:String, pipe:IPipeFitting ):void;
		
		/**
		 * Accept an output pipe.
		 * <p>
		 * Registers an input pipe with this module's Junction.</p>
		 */
		function acceptOutputPipe( name:String, pipe:IPipeFitting ):void;
		
	}
	
	
}
