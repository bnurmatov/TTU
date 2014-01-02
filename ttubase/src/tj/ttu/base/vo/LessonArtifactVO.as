////////////////////////////////////////////////////////////////////////////////
// Copyright Apr 20, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.base.vo
{
	/**
	 * LessonArtifactVO class 
	 */
	public class LessonArtifactVO
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const PDF					:String = 'PDF';
		public static const WINDOWS_INSTALLER	:String = 'WINDOWS_INSTALLER';
		public static const DVD_CONTENT			:String = 'DVD_CONTENT';
		public static const B4X_CONTENT			:String = 'B4X_CONTENT';
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *  Resouce id.
		 */
		public var id:String;
		/**
		 *  Lesson UUID.
		 */
		public var lessonUuid:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonArtifactVO 
		 */
		public function LessonArtifactVO()
		{
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get sortId():int
		{
			switch(_artifactType)
			{
				case PDF:
					return 1;
				case WINDOWS_INSTALLER:
					return 2;
				case DVD_CONTENT:
					return 3;
				case B4X_CONTENT:
					return 4;
				default:
				{
					return 1;
				}
			}
		}
		//------------------------------------------
		// url
		//------------------------------------------
		private var _url:String;
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		//------------------------------------------
		// artifactType Enum: PDF, WINDOWS_INSTALLER, DVD_CONTENT, B4X_CONTENT
		//------------------------------------------
		private var _artifactType:String;

		public function get artifactType():String
		{
			return _artifactType;
		}

		public function set artifactType(value:String):void
		{
			_artifactType = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @public
		 */
		
		/**
		 *  @private
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @protected
		 */
		
		/**
		 *  @private
		 */
		
		
	}
}