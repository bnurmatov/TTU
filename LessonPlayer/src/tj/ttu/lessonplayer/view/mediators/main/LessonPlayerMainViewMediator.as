////////////////////////////////////////////////////////////////////////////////
// Copyright Nov 2, 2012, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.lessonplayer.view.mediators.main
{
	import mx.controls.Alert;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import tj.ttu.lessonplayer.view.components.LessonPlayerMainView;
	import tj.ttu.lessonplayer.view.mediators.header.HeaderViewMediator;
	import tj.ttu.modulePlayer.view.mediators.LessonHolderHeaderMediator;
	import tj.ttu.modulePlayer.view.mediators.LessonHolderMainViewMediator;
	
	/**
	 * CCMainViewMediator class 
	 */
	public class LessonPlayerMainViewMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'LessonPlayerMainViewMediator';
		
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
		public function LessonPlayerMainViewMediator(viewComponent:LessonPlayerMainView)
		{
			super(NAME, viewComponent);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component():LessonPlayerMainView
		{
			return viewComponent as LessonPlayerMainView;
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
				if(facade.hasMediator(HeaderViewMediator.NAME))
					facade.removeMediator(HeaderViewMediator.NAME);
				facade.registerMediator(new HeaderViewMediator(component.headerView));
				
				if(facade.hasMediator(LessonHolderMainViewMediator.NAME))
					facade.removeMediator(LessonHolderMainViewMediator.NAME);
				facade.registerMediator(new LessonHolderMainViewMediator(component.lessonHolder));
			}
		}
		
		override public function onRemove():void
		{
			if(component)
			{
				facade.removeMediator(LessonHolderHeaderMediator.NAME);
				facade.removeMediator(LessonHolderMainViewMediator.NAME);
			}
			viewComponent = null;
			super.onRemove();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			// TODO Auto Generated method stub
			super.handleNotification(notification);
		}
		
		override public function listNotificationInterests():Array
		{
			// TODO Auto Generated method stub
			return super.listNotificationInterests();
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