////////////////////////////////////////////////////////////////////////////////
// Copyright 2012, Transparent Language, Inc.
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.interfaces
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IVisualElement;

	public interface IAssessmentStartScreen extends IEventDispatcher, IVisualElement
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		function set score( value:Number ) : void;
		function get score():Number;
		
		function set title( value:String ) : void;
		function get title():String;
		
		function set description( value:String ) : void;
		function get description():String;
		
		function set activityState( value:String ) : void;
		function get activityState() : String;
		
		function set isResume( value:Boolean ) : void;
		function get isResume():Boolean;
		
		function set isPassed( value:Boolean ) : void;
		function get isPassed():Boolean;
		
		function setFocus():void;
		function get stageWidth():Number;
	}
}