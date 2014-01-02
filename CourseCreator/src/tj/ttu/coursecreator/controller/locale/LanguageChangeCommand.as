////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 14, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.controller.locale
{
	import flashx.textLayout.formats.Direction;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	import tj.ttu.base.constants.LocaleConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.utils.LanguageInfoUtil;
	import tj.ttu.base.vo.LocaleVO;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.coursecreator.controller.BaseCommand;
	
	/**
	 * LocaleChangeCommand class 
	 */
	public class LanguageChangeCommand extends BaseCommand
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
		 * LocaleChangeCommand 
		 */
		public function LanguageChangeCommand()
		{
			super();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _langUtil:LanguageInfoUtil;
		
		private function get langUtil():LanguageInfoUtil
		{
			if(!_langUtil)
				_langUtil = LanguageInfoUtil.getInstance();
			return _langUtil;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function execute(notification:INotification):void
		{
			var localeVo:LocaleVO = notification.getBody() as LocaleVO;
			if(localeVo)
			{
				if(configProxy)
				{
					//uiFont
					configProxy.uiFont = langUtil.getFontByLocale( localeVo.locale );
					configProxy.uiDirection = langUtil.getIsRTLByLocale( localeVo.locale ) ? Direction.RTL : Direction.LTR;
					
					//en Font
					configProxy.enLanguageFont 		= langUtil.getFontByLocale( LocaleConstants.en_US );
					configProxy.enLanguageName 		= langUtil.getLanguageNameByLocale( LocaleConstants.en_US );
					configProxy.enLanguageCode 		= langUtil.getLanguageCode( LocaleConstants.en_US );
					configProxy.enLanguageDirection = langUtil.getIsRTLByLocale( LocaleConstants.en_US ) ? Direction.RTL : Direction.LTR;

					//tj Font
					configProxy.tjLanguageFont 		= langUtil.getFontByLocale( LocaleConstants.tg_TJ );
					configProxy.tjLanguageName 		= langUtil.getLanguageNameByLocale( LocaleConstants.tg_TJ );
					configProxy.tjLanguageCode 		= langUtil.getLanguageCode( LocaleConstants.tg_TJ );
					configProxy.tjLanguageDirection = langUtil.getIsRTLByLocale( LocaleConstants.tg_TJ ) ? Direction.RTL : Direction.LTR;
					
					//ru Font
					configProxy.ruLanguageFont 		= langUtil.getFontByLocale( LocaleConstants.ru_RU );
					configProxy.ruLanguageName 		= langUtil.getLanguageNameByLocale( LocaleConstants.ru_RU );
					configProxy.ruLanguageCode 		= langUtil.getLanguageCode( LocaleConstants.ru_RU );
					configProxy.ruLanguageDirection = langUtil.getIsRTLByLocale( LocaleConstants.ru_RU ) ? Direction.RTL : Direction.LTR;
				}
				
				if(fontManagerProxy)
				{
					var message:String = ResourceManager.getInstance().getString(ResourceConstants.TTU_COMPONENTS, 'fontLoadingProgressMessage') || 'Font loading';
					sendNotification(TTUConstants.SHOW_BUSY_PROGRESS_BAR, new BusyProgressbarVO(message, TTUConstants.FONT_LOADED) );
					fontManagerProxy.load( langUtil.getFonts() );
				}
				
				if(resourceProxy)
				{
					resourceProxy.locale = localeVo.locale;
					resourceProxy.load();
				}
			}
		}
		
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
		/**
		 * @private
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