////////////////////////////////////////////////////////////////////////////////
// Copyright Dec 26, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.airservice.model
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	import tj.ttu.airservice.model.chapter.ChapterAdapterProxy;
	import tj.ttu.airservice.model.image.ImageAdapterProxy;
	import tj.ttu.airservice.model.image.ImageAssetProxy;
	import tj.ttu.airservice.model.question.QuestionAdapterProxy;
	import tj.ttu.airservice.model.resource.ResourceAdapterProxy;
	import tj.ttu.airservice.model.resource.ResourceAssetsProxy;
	import tj.ttu.airservice.model.sound.SoundAdapterProxy;
	import tj.ttu.airservice.model.sound.SoundAssetProxy;
	import tj.ttu.airservice.model.video.VideoAdapterProxy;
	import tj.ttu.airservice.model.video.VideoAssetProxy;
	
	/**
	 * BaseProxy class 
	 */
	public class BaseProxy extends Proxy
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
		 * BaseProxy 
		 */
		public function BaseProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------------
		//  databaseMangerProxy
		//--------------------------------------
		public function get databaseMangerProxy():DatabaseManagerProxy
		{
			return facade.retrieveProxy( DatabaseManagerProxy.NAME ) as DatabaseManagerProxy;
		}
		//--------------------------------------
		//  chapterAdapterProxy
		//--------------------------------------
		public function get chapterAdapterProxy():ChapterAdapterProxy
		{
			return facade.retrieveProxy( ChapterAdapterProxy.NAME ) as ChapterAdapterProxy;
		}
		//--------------------------------------
		//  imageAdapterProxy
		//--------------------------------------
		public function get imageAdapterProxy():ImageAdapterProxy
		{
			return facade.retrieveProxy( ImageAdapterProxy.NAME ) as ImageAdapterProxy;
		}
		
		//--------------------------------------
		//  soundAdapterProxy
		//--------------------------------------
		public function get soundAdapterProxy():SoundAdapterProxy
		{
			return facade.retrieveProxy( SoundAdapterProxy.NAME ) as SoundAdapterProxy;
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