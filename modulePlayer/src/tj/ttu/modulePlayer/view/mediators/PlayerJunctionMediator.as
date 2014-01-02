////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 6, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.mediators
{
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
	
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModuleMessage;
	import tj.ttu.moduleUtility.utils.messages.ModulePipeMessage;
	import tj.ttu.moduleUtility.view.interfaces.IModule;
	import tj.ttu.moduleUtility.view.interfaces.IModulePipeMessage;
	
	/**
	 * PlayerJunctionMediator class 
	 */
	public class PlayerJunctionMediator extends JunctionMediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = 'PlayerJunctionMediator';
		
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
		 * PlayerJunctionMediator 
		 */
		public function PlayerJunctionMediator()
		{
			super(NAME, new Junction());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		private var _moduleProxy:ModuleProxy;

		public function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy( ModuleProxy.NAME ) as ModuleProxy;
			return _moduleProxy;
		}
		//-----------------------------------
		//	assessmentProxy
		//-----------------------------------
		
		/**
		 * @private
		 * Storage for the assessmentProxy property.
		 */
		private var _assessmentProxy:AssessmentProxy;
		
		/**
		 * Reference to the <code>AssessmentProxy</code>.
		 */
		public function get assessmentProxy():AssessmentProxy
		{
			if (!this._assessmentProxy)
				this._assessmentProxy = this.facade.retrieveProxy(AssessmentProxy.NAME) as AssessmentProxy;
			
			return this._assessmentProxy;
		}		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function onRemove():void
		{
			disconnectModule();
			viewComponent = null;
			super.onRemove();
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case TTUConstants.MODULE_ADDED:
				{
					connectModule(note.getBody() as IModule);
					break;
				}
				case TTUConstants.SEND_MESSAGE_TO_MODULE:
				{
					try
					{
						sendMessage(IPipeMessage(note.getBody()));
					}
					catch(e:Error) 
					{
						
					}
					break;
				}
				case TTUConstants.MODULE_REMOVED:
				{
					disconnectModule();
					break;
				}
				default:
				{
					super.handleNotification(note);
					break;
				}
			}
			
		}
		
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(TTUConstants.MODULE_ADDED);
			interests.push(TTUConstants.SEND_MESSAGE_TO_MODULE);
			interests.push(TTUConstants.MODULE_REMOVED)
			return interests;
		}
		
		
		override public function handlePipeMessage(message:IPipeMessage):void
		{
			var moduleMessage:IModulePipeMessage = message as IModulePipeMessage;
			if(message || moduleMessage.action == PipeConstants.MODULE_TO_SHELL_PIPE)
			{
				switch(moduleMessage.contentType)
				{
					case MessageConstants.HIDE_MODULE:
					{
						sendNotification(TTUConstants.HIDE_MODULE);
						break;
					}
					case MessageConstants.SHOW_MODULE_HELP:
					{
						sendNotification(TTUConstants.SHOW_HELP, ModulePipeMessage(message).getBody()); 
						break;
					}
					case TTUConstants.MODULE_REMOVED:
					{
						//sendNotification(PlayerConstants.ACTIVATE_JS, false);
						break;
					}
					case  MessageConstants.SOUND_PLAY:
						//sendNotification(PlayerConstants.PLAY_SOUND, SoundMessage(message).sound);
						break;
					
					/*case  MessageConstants.SOUND_VOLUME:
						configProxy.volume 		= VolumeMessage(message).volume;
						configProxy.muted 		= VolumeMessage(message).muted;
						configProxy.soundSpeed 	= VolumeMessage(message).soundSpeed;
						configProxy.startScreenSoundMuted = VolumeMessage(message).startScreenSoundMuted;
						break;*/
					
					case MessageConstants.MODULE_DONE:
					case MessageConstants.MODULE_COMPLETED:
					case MessageConstants.MODULE_INCOMPLETE:
					case MessageConstants.MODULE_STARTED:
					{
						sendNotification(TTUConstants.HANDLE_MODULE_MESSAGE, message);
						break;
					}
					case MessageConstants.MODULE_ERROR:
					{
						createAndSendErrorNotification(TTUConstants.LOAD_ERROR, ModuleMessage(message).content as String);
						break;
					}
					case MessageConstants.FILE_LOAD_ERROR:
					{
						createAndSendErrorNotification(TTUConstants.FILE_LOAD_ERROR, ModuleMessage(message).content  as String);
						break;
					}
					case MessageConstants.ASSESSMENT_QUESTIONS:
					{
						var questions:ArrayCollection = ModuleMessage(message).content as ArrayCollection;
						if(assessmentProxy && questions)
							assessmentProxy.questions = questions.toArray();
						break;
					}
					/*case MessageConstants.SHOW_BROWSER_POPUP:
					{
						sendNotification(PlayerConstants.SHOW_BROWSER_POPUP, ActivityMessage(message).content);
						break;
					}*/
					case MessageConstants.MODULE_VERSION:
					{
						if(!moduleProxy)
							return;
						
						if (ModuleMessage(message).content.version && moduleProxy.currentModule) 
						{
							moduleProxy.currentModule.moduleVersion = ModuleMessage(message).content.version;
						}
						else if(moduleProxy.currentModule)
						{
							moduleProxy.currentModule.moduleVersion = "";
						}
						sendNotification(MessageConstants.MODULE_VERSION,  moduleProxy.currentModule.name + ": " + moduleProxy.currentModule.moduleVersion);
						break;
					}
					default:
					{
						sendNotification(ModuleMessage(message).contentType, ModuleMessage(message).content);
						break;
					}
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
		 * 
		 * @param module An activity module which needs to connect
		 * Registers pipes and connects module to application and notifies application
		 * that module is connected and can receive settings
		 * 
		 */		 
		public function connectModule(module:IModule):void
		{
			junction.registerPipe(PipeConstants.SHELL_TO_MODULE_PIPE, Junction.OUTPUT, new TeeSplit());
			junction.registerPipe(PipeConstants.MODULE_TO_SHELL_PIPE, Junction.INPUT, new TeeMerge());
			junction.addPipeListener(PipeConstants.MODULE_TO_SHELL_PIPE, this, handlePipeMessage);
			
			var moduleToShellPipe:Pipe = new Pipe();
			module.acceptOutputPipe(PipeConstants.MODULE_TO_SHELL_PIPE, moduleToShellPipe);
			var teeMerge:TeeMerge = junction.retrievePipe(PipeConstants.MODULE_TO_SHELL_PIPE) as TeeMerge;
			teeMerge.connectInput(moduleToShellPipe);
			
			
			var shellToModulePipe:Pipe = new Pipe();
			module.acceptInputPipe(PipeConstants.SHELL_TO_MODULE_PIPE, shellToModulePipe);
			var teeSplit:TeeSplit = junction.retrievePipe(PipeConstants.SHELL_TO_MODULE_PIPE) as TeeSplit;
			teeSplit.connect(shellToModulePipe);
			//Here we know that our module is connected and ready to receive message from us
			//therefore we send setting to module
			// 
			sendNotification(TTUConstants.SEND_MODULE_SETTINGS);
		}
		
		/**
		 * Disconnects module by removing incoming and outgoing pipes
		 */ 
		public function disconnectModule():void
		{
			junction.removePipe(PipeConstants.SHELL_TO_MODULE_PIPE);
			junction.removePipe(PipeConstants.MODULE_TO_SHELL_PIPE);
		}
		
		/**
		 *  @private
		 */
		/**
		 * Sends a message to module via pipe.
		 * @param msg Message object.
		 * 
		 */		
		private function sendMessage(message:IPipeMessage):void
		{
			junction.sendMessage(PipeConstants.SHELL_TO_MODULE_PIPE, message);
		}
		
		private function createAndSendErrorNotification(errorCode:String, text:String):void
		{
			/*var resourceProxy:ResourceProxy = facade.retrieveProxy(ResourceProxy.NAME) as ResourceProxy;
			var errorString:String;
			switch (errorCode)
			{
				case TTUConstants.FILE_LOAD_ERROR:
				{
					errorString = resourceProxy.getLocale("fileLoadError", [text])|| text;
					break;
				}
				case TTUConstants.LOAD_ERROR:
				{
					errorString = resourceProxy.getLocale("fileLoadError", [text])||text;
					break;
				}
			}*/
			sendNotification(TTUConstants.SHOW_ERROR_WINDOW, text);
		}
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