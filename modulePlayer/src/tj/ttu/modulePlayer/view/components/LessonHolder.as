////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 5, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.mx_internal;
	import mx.effects.Parallel;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.RichText;
	import spark.components.ToggleButton;
	import spark.components.mediaClasses.VolumeBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.base.constants.AudioValues;
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.StringUtil;
	import tj.ttu.base.utils.TLFUtil;
	import tj.ttu.base.vo.ModuleVO;
	import tj.ttu.components.events.AudioSettingEvent;
	import tj.ttu.modulePlayer.view.components.background.HolderBackground;
	import tj.ttu.modulePlayer.view.events.LessonHolderEvent;
	import tj.ttu.moduleUtility.view.components.ModuleLoader;

	use namespace mx_internal;
	/**
	 * LessonHolder class 
	 */
	public class LessonHolder extends SkinnableComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  SkinParts
		//
		//--------------------------------------------------------------------------
		
		
		[SkinPart]
		public var lessonHolderHeader:LessonHolderHeader;
		
		[SkinPart]
		public var lessonHolderMainView:LessonHolderMainView;
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructor
		 * LessonHolder 
		 */
		public function LessonHolder()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
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
		public function resetComponent():void
		{
			lessonHolderHeader.resetComponent();
			lessonHolderMainView.resetComponent();
		}
		/**
		 *  @private
		 */
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handler Methods
		//
		//--------------------------------------------------------------------------
		
		
		
	}
}