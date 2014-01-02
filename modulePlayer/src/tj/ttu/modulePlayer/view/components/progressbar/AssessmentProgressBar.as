////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.components.progressbar
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.supportClasses.Range;
	[SkinState("failed")]
	[SkinState("passed")]
	/***
	 * UnitProgressBar progress of the unit
	 * 
	 */ 
	public class AssessmentProgressBar extends Range
	{
		//-------------------------------------------------------------------
		// Class constants
		//-------------------------------------------------------------------
		/**
		 *  The <code>TRACK_HEIGHT</code> constant 
		 *  defines the value fpr the hieght of the track.
		 */	
		public static const TRACK_HEIGHT:Number = 12;
		//-------------------------------------------------------------------
		// Constructor
		//-------------------------------------------------------------------
		/**
		 * Constructor
		 */ 
		
		
		public function AssessmentProgressBar()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		//-------------------------------------------------------------------
		// Skin parts
		//-------------------------------------------------------------------
		
		/**
		 * Skin parts
		 */ 
		[SkinPart(required="false")]
		public var track:Group;
		[SkinPart(required="true")]
		public var progressBar:Group;
		
		
		//-------------------------------------------------------------------
		// Properties
		//-------------------------------------------------------------------
		//-------------------------------------------------------------------
		// value
		//-------------------------------------------------------------------
		/**
		 *  @private
		 *  Storage for the value property.
		 */
		private var valueChanged:Boolean;
		private var _value:Number = 0;
		
		[Bindable("change")]
		
		/**
		 *  Read-only property that contains the amount of progress
		 *  that has been made - between the minimum and maximum values.
		 */
		override public function get value():Number
		{
			return _value;
		}
		
		override public function set value(newValue:Number):void
		{
			if (newValue == value)
				return;
			_value = newValue;
			valueChanged = true;
			invalidateProperties();
		}
		//----------------------------------
		//  maximum
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the maximum property.
		 */
		private var _maximum:Number = 0;
		
		[Bindable("maximumChanged")]
		[Inspectable(category="General", defaultValue="0")]
		
		/**
		 *  Largest progress value for the ProgressBar. You
		 *  can only use this property in manual mode.
		 *
		 *  @default 0
		 */
		override public function get maximum():Number
		{
			return _maximum;
		}
		
		/**
		 *  @private
		 */
		override public function set maximum(value:Number):void
		{
			if (!isNaN(value) && value != _maximum)
			{
				_maximum = value;
				invalidateDisplayList();
			}
		}
		
		//----------------------------------
		//  minimum
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the minimum property.
		 */
		private var _minimum:Number = 0;
		
		[Bindable("minimumChanged")]
		[Inspectable(category="General", defaultValue="0")]
		
		/**
		 *  Smallest progress value for the ProgressBar. This
		 *  property is set by the developer only in manual mode.
		 *
		 *  @default 0
		 */
		override public function get minimum():Number
		{
			return _minimum;
		}
		
		/**
		 *  @private
		 */
		override public function set minimum(value:Number):void
		{
			if (!isNaN(value) && value != _minimum)
			{
				_minimum = value;
				
				invalidateDisplayList();
				
			}
		}
		//----------------------------------
		//  isPassed
		//----------------------------------
		private var _isPassed:Boolean;

		public function get isPassed():Boolean
		{
			return _isPassed;
		}

		public function set isPassed(value:Boolean):void
		{
			if( _isPassed !== value)
			{
				_isPassed = value;
				invalidateSkinState();
			}
		}

		
		//-------------------------------------------------------------------
		// Overriden methods
		//-------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */ 
		override public function invalidateProperties():void
		{
			super.invalidateProperties();
			if(maximum != 0 && progressBar != null){
				progressBar.percentWidth=100 * value/maximum;
				if(progressBar.percentWidth > 100){
					progressBar.percentWidth = 100;
				}
				if(value == 0)
				{
					progressBar.visible = false;
				}else{
					progressBar.visible = true ;
				}
			}
		}
		
		override protected function getCurrentSkinState():String
		{
			if(_isPassed)
				return 'passed'
			return 'failed';
		}
		
		
		//-------------------------------------------------------------------
		// Public Methods 
		//-------------------------------------------------------------------
		
		/**
		 *  Percentage of process that is completed.The range is 0 to 100.
		 *  Use the <code>setProgress()</code> method to change the percentage.
		 */
		public function get percentComplete():Number
		{
			super.commitProperties();
			if (_value < _minimum || _maximum < _minimum)
				return 0;
			
			// Avoid divide by zero fault.
			if ((_maximum - _minimum) == 0)
				return 0;
			
			var perc:Number = 100 * (_value - _minimum) / (_maximum - _minimum);
			
			if (isNaN(perc) || perc < 0)
				return 0;
			else if (perc > 100)
				return 100;
			else
				return perc;
		}
		
		/**
		 * 
		 * @param numCompelted Completed amount 
		 * @param totalCount  Total amount
		 * 
		 */	
		public function setProgress(numCompelted:Number, totalCount:Number):void
		{
			_setProgress(numCompelted, totalCount);
			//invalidateSkinState();
		}
		
		//-------------------------------------------------------------------
		// Private Methods 
		//-------------------------------------------------------------------
		
		/**
		 * @private
		 *  Changes the value and the maximum properties.
		 */
		private function _setProgress(numCompelted:Number, totalCount:Number):void
		{
			if (enabled && !isNaN(numCompelted) && !isNaN(totalCount))
			{
				_value = numCompelted;
				_maximum = totalCount;
				invalidateProperties();
		//		invalidateSkinState();
			}
		}
		/**
		 * @private
		 */ 
		private function onCreationComplete(event:Event):void
		{
			invalidateProperties();
		}
	}
}