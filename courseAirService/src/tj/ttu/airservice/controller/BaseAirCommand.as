////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 22, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.controller
{
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.airservice.model.DatabaseManagerProxy;
	import tj.ttu.airservice.model.chapter.ChapterAdapterProxy;
	import tj.ttu.airservice.model.image.ImageAdapterProxy;
	import tj.ttu.airservice.model.image.ImageAssetProxy;
	import tj.ttu.airservice.model.lesson.LessonAdapterProxy;
	import tj.ttu.airservice.model.publish.PublishLessonProxy;
	import tj.ttu.airservice.model.question.QuestionAdapterProxy;
	import tj.ttu.airservice.model.resource.ResourceAdapterProxy;
	import tj.ttu.airservice.model.resource.ResourceAssetsProxy;
	import tj.ttu.airservice.model.sound.SoundAdapterProxy;
	import tj.ttu.airservice.model.sound.SoundAssetProxy;
	import tj.ttu.airservice.model.user.UserAdapterProxy;
	import tj.ttu.airservice.model.video.VideoAdapterProxy;
	import tj.ttu.airservice.model.video.VideoAssetProxy;
	import tj.ttu.base.model.filereference.FileRefferenceProxy;
	import tj.ttu.base.model.resource.ResourceProxy;
	
	/**
	 * BaseAirCommand class 
	 */
	public class BaseAirCommand extends SimpleCommand
	{
		
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
		 * BaseAirCommand 
		 */
		public function BaseAirCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//-----------------------------------
		//	databaseManagerProxy
		//-----------------------------------
		public function get databaseManagerProxy():DatabaseManagerProxy
		{
			return facade.retrieveProxy(DatabaseManagerProxy.NAME ) as DatabaseManagerProxy;
		}
		
		//-----------------------------------
		//	lessonAdapterProxy
		//-----------------------------------
		public function get lessonAdapterProxy():LessonAdapterProxy
		{
			return facade.retrieveProxy(LessonAdapterProxy.NAME ) as LessonAdapterProxy;
		}
		//-----------------------------------
		//	userAdapterProxy
		//-----------------------------------
		public function get userAdapterProxy():UserAdapterProxy
		{
			return facade.retrieveProxy(UserAdapterProxy.NAME) as UserAdapterProxy;
		}
		//-----------------------------------
		//	chapterAdapterProxy
		//-----------------------------------
		public function get chapterAdapterProxy():ChapterAdapterProxy
		{
			return facade.retrieveProxy(ChapterAdapterProxy.NAME ) as ChapterAdapterProxy;
		}

		//-----------------------------------
		//	ImageAdapterProxy
		//-----------------------------------
		public function get imageAdapterProxy():ImageAdapterProxy
		{
			return facade.retrieveProxy( ImageAdapterProxy.NAME ) as ImageAdapterProxy;
		}
		//-----------------------------------
		//	ImageAssetsProxy
		//-----------------------------------
		public function get imageAssetsProxy():ImageAssetProxy
		{
			if(!facade.hasProxy(ImageAssetProxy.NAME))
				facade.registerProxy( new ImageAssetProxy());
			return facade.retrieveProxy( ImageAssetProxy.NAME ) as ImageAssetProxy;
		}
		
		//--------------------------------------
		//  soundAdapterProxy
		//--------------------------------------
		public function get soundAdapterProxy():SoundAdapterProxy
		{
			return facade.retrieveProxy( SoundAdapterProxy.NAME ) as SoundAdapterProxy;
		}
		
		//-----------------------------------
		//	SoundAssetsProxy
		//-----------------------------------
		public function get soundAssetsProxy():SoundAssetProxy
		{
			if(!facade.hasProxy(SoundAssetProxy.NAME))
				facade.registerProxy( new SoundAssetProxy());
			return facade.retrieveProxy( SoundAssetProxy.NAME ) as SoundAssetProxy;
		}
		
		//--------------------------------------
		//  videoAdapterProxy
		//--------------------------------------
		public function get videoAdapterProxy():VideoAdapterProxy
		{
			return facade.retrieveProxy( VideoAdapterProxy.NAME ) as VideoAdapterProxy;
		}
		
		//-----------------------------------
		//	videoAssetProxy
		//-----------------------------------
		public function get videoAssetProxy():VideoAssetProxy
		{
			if(!facade.hasProxy(VideoAssetProxy.NAME))
				facade.registerProxy( new VideoAssetProxy());
			return facade.retrieveProxy( VideoAssetProxy.NAME ) as VideoAssetProxy;
		}
		
		//-----------------------------------
		//	fileRefferenceProxy
		//-----------------------------------
		public function get fileRefferenceProxy():FileRefferenceProxy
		{
			if(!facade.hasProxy(FileRefferenceProxy.NAME))
				facade.registerProxy( new FileRefferenceProxy());
			
			return facade.retrieveProxy( FileRefferenceProxy.NAME ) as FileRefferenceProxy;
		}
		
		//--------------------------------------
		//  questionAdapterProxy
		//--------------------------------------
		public function get questionAdapterProxy():QuestionAdapterProxy
		{
			return facade.retrieveProxy( QuestionAdapterProxy.NAME ) as QuestionAdapterProxy;
		}
		
		//--------------------------------------
		//  resourceAdapterProxy
		//--------------------------------------
		public function get resourceAdapterProxy():ResourceAdapterProxy
		{
			return facade.retrieveProxy( ResourceAdapterProxy.NAME ) as ResourceAdapterProxy;
		}
		
		//-----------------------------------
		//	resourceAssetProxy
		//-----------------------------------
		public function get resourceAssetProxy():ResourceAssetsProxy
		{
			if(!facade.hasProxy(ResourceAssetsProxy.NAME))
				facade.registerProxy( new ResourceAssetsProxy());
			return facade.retrieveProxy( ResourceAssetsProxy.NAME ) as ResourceAssetsProxy;
		}
		
		//-----------------------------------
		//	publishLessonProxy
		//-----------------------------------
		public function get publishLessonProxy():PublishLessonProxy
		{
			if(!facade.hasProxy(PublishLessonProxy.NAME))
				facade.registerProxy(new PublishLessonProxy());
			return facade.retrieveProxy( PublishLessonProxy.NAME ) as PublishLessonProxy;
		}
		
		/**
		 * we currently only have a single user system 
		 */
		private var _resourceProxy:ResourceProxy;
		
		public function get resourceProxy():ResourceProxy
		{
			if(!_resourceProxy)
				_resourceProxy = facade.retrieveProxy( ResourceProxy.NAME ) as ResourceProxy;
			return _resourceProxy;
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