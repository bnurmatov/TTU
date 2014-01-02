////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 16, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.components.components.dropdown
{
	import flash.events.Event;
	
	import spark.components.DropDownList;
	import spark.events.IndexChangeEvent;
	
	import tj.ttu.base.vo.LocaleVO;
	
	/**
	 * LanguageDropDownList class 
	 */
	public class LanguageDropDownList extends DropDownList
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
		 * LanguageDropDownList 
		 */
		public function LanguageDropDownList()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _flagIcon:Object;

		[Bindable(event="flagIconChange")]
		public function get flagIcon():Object
		{
			return _flagIcon;
		}

		public function set flagIcon(value:Object):void
		{
			if( _flagIcon !== value)
			{
				_flagIcon = value;
				dispatchEvent(new Event("flagIconChange"));
			}
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
		
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(IndexChangeEvent.CHANGE, onIndexChange);
		}
		
		protected function onIndexChange(event:IndexChangeEvent):void
		{
			if(dataProvider)
			{
				var item:LocaleVO = dataProvider.getItemAt( event.newIndex ) as LocaleVO;
				flagIcon = item ? item.image : null;
			}
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
			removeEventListener(IndexChangeEvent.CHANGE, onIndexChange);
		}
		
	}
}