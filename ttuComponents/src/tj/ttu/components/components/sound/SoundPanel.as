////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 1, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.sound
{
	import flash.utils.ByteArray;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	
	/**
	 * The Sound panel for etalon and user sound.
	 */
	
	public class SoundPanel extends SkinnableComponent
	{

		public static const RAW_DATA:String = "rawData";
		
		public static const SLOW_RAW_DATA:String = "slowRawData";
		
		/**
		 * Constructor.
		 */
		public function SoundPanel()
		{
			super();
		}
		
		
		//Skin Parts
		[SkinPart(required="false")]
		/**
		 *  A skin part that wave form draw. 
		 *  
		 *  @productversion Flex 4
		 */
		public var waveForm:WaveForm;

		/**
		 * Property numChannnels for WaveForm
		 * @default =2
		 */ 
		protected var _numChannels:uint =2;

		/**
		 *  @private
		 */ 
		public function set numChannels(value:uint):void
		{
			_numChannels = value;
			if(waveForm)
			{
				waveForm.numChannels = value; 
			}
		}
		/**
		 * Property duration
		 * 
		 */ 
		protected var _sndData:ByteArray;

		/**
		 *  @private
		 */ 
		public function set sndData(value:ByteArray):void
		{
			_sndData = value;
			if(waveForm)
			{
				waveForm.graphics.clear();
				waveForm.sndBytes = value;
			}
		}
		public function get sndData():ByteArray
		{
			return _sndData;
		}

		/**
		 *  Draw wave form.
		 */ 
		public function drawWave():void
		{
			if(waveForm)
			{
				//waveForm.drawWave();
			}
		}
						
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			if(instance == waveForm)
			{
				if(_numChannels)
				{
					waveForm.numChannels = _numChannels;
					
				}
				if(_sndData)
				{
					waveForm.sndBytes = _sndData;
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
	}
}
