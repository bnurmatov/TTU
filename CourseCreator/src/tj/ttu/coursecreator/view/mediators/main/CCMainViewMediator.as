////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 2, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.view.mediators.main
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.coursecreator.view.components.CCMainView;
	import tj.ttu.coursecreatorbase.view.mediators.CourseCreatorMediator;
	
	/**
	 * CCMainViewMediator class 
	 */
	public class CCMainViewMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'CCMainViewMediator';
		
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
		 * CCMainViewMediator 
		 */
		public function CCMainViewMediator(viewComponent:CCMainView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():CCMainView
		{
			return viewComponent as CCMainView;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			if(component)
			{
				facade.registerMediator(new CourseCreatorMediator(component.courseBase));
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				facade.removeMediator(CourseCreatorMediator.NAME);
			}
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			super.handleNotification(note);
			switch(note.getName())
			{
				case TTUConstants.SHOW_ERROR_WINDOW:
				case TTUConstants.FONT_LOADED:
				{
					sendNotification(TTUConstants.SPIN_END, new BusyProgressbarVO(null, note.getName()));
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.SHOW_ERROR_WINDOW,
					TTUConstants.FONT_LOADED
			];
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