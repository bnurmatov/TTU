////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 10, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.progressbar
{
	// TODO move progressBar to components	
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.Range;
	
	/***
	 * Component displays load progress of an loading asset
	 * 
	 */  
	public class ProgressBar extends Range
	{
		//-------------------------------------------------------------------
		// Class constants
		//-------------------------------------------------------------------
		/**
		 *  The <code>TRACK_HEIGHT</code> constant 
		 *  defines the value fpr the hieght of the track.
		 *  
		 *  default skin:
		 *  com.transparent.skins.LearningProgressBarSkin
		 */	
		public static const TRACK_HEIGHT:Number = 12;
		//-------------------------------------------------------------------
		// Constructor
		//-------------------------------------------------------------------
		/**
		 * Constructor
		 */ 
		public function ProgressBar()
		{
			super();
		}
		
		//-------------------------------------------------------------------
		// Skin parts
		//-------------------------------------------------------------------
		
		/**
		 * Skin parts
		 */ 
		[SkinPart(required="false")]
		public var track:Group;
		[SkinPart(required="false")]
		public var progressBar:Group;
		[SkinPart(required="false")]
		public var labelProgress:Label;
		
		//-------------------------------------------------------------------
		// Properties
		//-------------------------------------------------------------------
		
		/**
		 * If set to false hides progress' lable 
		 */		
		public var hasLable:Boolean = true;
		
		//-------------------------------------------------------------------
		// value
		//-------------------------------------------------------------------
		/**
		 *  @private
		 *  Storage for the value property.
		 */
		private var _value:Number = 0;
		
		[Bindable("valueChanged")]
		
		/**
		 *  Read-only property that contains the amount of progress
		 *  that has been made - between the minimum and maximum values.
		 */
		override public function get value():Number
		{
			return _value;
		}
		override public function set value(val:Number):void
		{
			super.value = val;
			_value = val;
			invalidateProperties(); // TODO need to review
			//dispatchEvent(new ProgressBarEvent(ProgressBarEvent.VALUE_CHANGED));
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
		 *  Largest progress value for the ProgressBar. 
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
				//dispatchEvent(new ProgressBarEvent(ProgressBarEvent.MAXIMUM_CHANGED));
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
				
				//dispatchEvent(new ProgressBarEvent(ProgressBarEvent.MINIMUM_CHANGED));
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
			if(maximum != 0 && progressBar != null)
			{
				progressBar.percentWidth=100 * (value/maximum);
				
				if(progressBar.percentWidth > 100)
				{
					progressBar.percentWidth = 100;
				}
				if(value == 0)
				{
					progressBar.visible = false;
				}
				else
				{
					progressBar.visible = true ;
				}
				resourcesChanged();
			}
		}
		
		override protected function attachSkin() : void
		{
			super.attachSkin();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override protected function detachSkin() : void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			super.detachSkin();
		}
		override protected function resourcesChanged() : void
		{
			if(labelProgress)
			{
				labelProgress.text = 
					resourceManager.getString("tlcomponents",
						"learningProgressBar_label", [(value), 
							(maximum)]);
				labelProgress.visible = hasLable;
			}
		
		}
		/**
		 *  Percentage of process that is completed.The range is 0 to 100.
		 *  Use the <code>setProgress()</code> method to change the percentage.
		 */
		public function get percentComplete():Number
		{
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
		public function setProgress(numCompleted:Number, totalCount:Number):void
		{
			_setProgress(numCompleted, totalCount);
			
			invalidateSkinState();
		}
		
		//-------------------------------------------------------------------
		// Private Methods 
		//-------------------------------------------------------------------
		
		/**
		 * @private
		 *  Changes the value and the maximum properties.
		 */
		private function _setProgress(numCompleted:Number, totalCount:Number):void
		{
			numCompleted = numCompleted + 1;
			// don't show more than totalCount
			numCompleted = numCompleted >= totalCount ? totalCount : numCompleted;

			if (enabled && !isNaN(numCompleted) && !isNaN(totalCount))
			{
				value = numCompleted;
				_maximum = totalCount;
				invalidateProperties();
				invalidateSkinState();
			}
		}
		/**
		 * @private
		 */ 
		private function onCreationComplete(event:Event):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			resourcesChanged();
			invalidateProperties();
		}
	}
}