////////////////////////////////////////////////////////////////////////////////
// Copyright May 31, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.coursecreator.controller.busyProgressBar
{
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import tj.ttu.components.components.progressbar.BusyProgressBar;
	import tj.ttu.components.skins.progressbar.BusyProgressBarSkin;
	import tj.ttu.components.vo.BusyProgressbarVO;
	import tj.ttu.coursecreator.view.mediators.busyprogressbar.BusyProgressBarMediator;
	
	/**
	 * ShowBusyProgressBarCommand class 
	 */
	public class ShowBusyProgressBarCommand extends SimpleCommand
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
		 * ShowBusyProgressBarCommand 
		 */
		public function ShowBusyProgressBarCommand()
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
		override public function execute(note:INotification):void
		{
			if(!facade.hasMediator(BusyProgressBarMediator.NAME))
			{
				var vo:BusyProgressbarVO = note.getBody() as BusyProgressbarVO;
				var progressBar:BusyProgressBar = new BusyProgressBar();
				progressBar.message = note.getBody() as String;
				facade.registerMediator( new BusyProgressBarMediator(progressBar, vo));
				progressBar.setStyle("skinClass", BusyProgressBarSkin);
				PopUpManager.addPopUp(progressBar as IFlexDisplayObject, FlexGlobals.topLevelApplication as DisplayObject,true);
				PopUpManager.centerPopUp(progressBar as IFlexDisplayObject);
				progressBar.setFocus();
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