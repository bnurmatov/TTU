////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 8, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.courseservice.model.vo
{
	import flash.utils.ByteArray;
	
	import tj.ttu.base.vo.ImageVO;
	import tj.ttu.base.vo.ResourceVO;
	import tj.ttu.base.vo.SoundVO;
	import tj.ttu.base.vo.VideoVO;

	/**
	 * MediaVO class 
	 */
	public class MediaVO
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const LESSON:String = 'lesson';
		public static const AUTHOR:String = 'author';
		public static const CHAPTER:String = 'chapter';
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public var targetGuid:String;
		
		public var target:String;
		
		public var binaryContent:ByteArray;
		
		public var fileName:String;
		
		public var lessonVersion:int;
		
		public var lessonUuid:String;
		
		public var imageVO:ImageVO;
		
		public var soundVO:SoundVO;
		
		public var videoVO:VideoVO;
		
		public var resource:ResourceVO;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * MediaVO 
		 */
		public function MediaVO(targetGuid:String = null, target:String = CHAPTER)
		{
			this.targetGuid = targetGuid;
			this.target = target;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
				
	}
}