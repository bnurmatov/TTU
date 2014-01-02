////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 15, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.module.chapterPlayer.views.mediators.junction
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	
	import tj.ttu.module.chapterPlayer.Version;
	import tj.ttu.module.chapterPlayer.constants.ChapterPlayerNotifications;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ConfigurationMessage;
	import tj.ttu.moduleUtility.utils.messages.ModuleMessage;
	import tj.ttu.moduleUtility.view.interfaces.IModulePipeMessage;
	
	/**
	 * ChapterPlayerJunctionMediator class 
	 */
	public class ChapterPlayerJunctionMediator extends JunctionMediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'ChapterPlayerJunctionMediator';
		
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
		 * ChapterPlayerJunctionMediator 
		 */
		public function ChapterPlayerJunctionMediator()
		{
			super(NAME, new Junction());
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
		/**
		 *  Disconnect incoming and outgoing pipes
		 */
		override public function onRemove():void
		{
			junction.removePipe(PipeConstants.MODULE_TO_SHELL_PIPE);
			junction.removePipe(PipeConstants.SHELL_TO_MODULE_PIPE);
			
			super.onRemove();
			
			viewComponent = null;
		}		
		
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(ChapterPlayerNotifications.SEND_MESSAGE_TO_SHELL);
			
			return interests;
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch (note.getName())
			{
				case ChapterPlayerNotifications.SEND_MESSAGE_TO_SHELL:
				{
					var msg:Message = note.getBody() as Message;
					junction.sendMessage(PipeConstants.MODULE_TO_SHELL_PIPE, msg);
					break;
				}
				default:
				{
					super.handleNotification(note);
				}
			}
		}
		
		override public function handlePipeMessage(message:IPipeMessage):void
		{
			if (!viewComponent)
				return;
			
			switch(IModulePipeMessage(message).contentType)
			{
				case MessageConstants.ALL:
				{
					sendNotification(ChapterPlayerNotifications.READ_CONFIGURATION_DATA, ConfigurationMessage(message).configuration);
					sendVersion();
					break;
				}
				case MessageConstants.RESTART_MODULE:
				{
					sendNotification(ChapterPlayerNotifications.RESTART_MODULE);
					break;
				}
				case MessageConstants.PAUSE_MODULE:
				{
					var isPaused:Boolean = true;
					
					if (message.getBody() is Boolean)
					{
						isPaused = message.getBody() as Boolean;
						sendNotification(ChapterPlayerNotifications.PAUSE_MODULE, isPaused);
					}
					else
						sendNotification(ChapterPlayerNotifications.PAUSE_MODULE, message.getBody());
					break;
				}
				case MessageConstants.MODULE_SUSPEND:
				{
					sendNotification(ChapterPlayerNotifications.PAUSE_MODULE, true);
					
					break;
				}
				case MessageConstants.MODULE_PROCEED:
				{
					sendNotification(ChapterPlayerNotifications.PAUSE_MODULE, false);
					
					break;
				}
				
				default:
				{
					sendNotification(IModulePipeMessage(message).contentType,
						message);
				}
			}
		}
		
		//----------------------------------------------------------------
		// Methods : private 
		//----------------------------------------------------------------
		/**
		 * @private
		 */
		private function sendVersion():void
		{
			var msg:ModuleMessage = new ModuleMessage(
				PipeConstants.MODULE_TO_SHELL_MESSAGE,
				MessageConstants.MODULE_VERSION, 
				{version : Version.VERSION});
			
			if (junction)
				junction.sendMessage(PipeConstants.MODULE_TO_SHELL_PIPE, msg);
		}
	}
}