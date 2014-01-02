////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.interfaces
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElement;
	
	public interface IStartScreen extends IEventDispatcher, IVisualElement
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		function set isResume( value:Boolean ) : void;
		
		function set title( value:String ) : void;
		
		function set description( value:String ) : void;
		
		function get enabled():Boolean;

		function set enabled(value:Boolean):void;
		
		function setFocus():void;
		function get stageWidth():Number;
	}
}