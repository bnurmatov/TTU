////////////////////////////////////////////////////////////////////////////////
// Copyright 2011, Transparent Language, Inc..
// All Rights Reserved.
// Transparent Language Confidential Information
////////////////////////////////////////////////////////////////////////////////
package tj.ttu.modulePlayer.view.mediators.startscreen
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	import mx.events.EffectEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.effects.Fade;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.modulePlayer.view.components.startscreen.AssessmentStartScreen;
	import tj.ttu.modulePlayer.view.interfaces.IAssessmentStartScreen;
	import tj.ttu.moduleUtility.constants.MessageConstants;
	import tj.ttu.moduleUtility.constants.PipeConstants;
	import tj.ttu.moduleUtility.utils.messages.ModulePipeMessage;
	
	/**
	 * StartScreenMediator class 
	 */
	public class AssessmentStartScreenMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "AssessmentStartScreenMediator";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var hideFade:Fade;
		private var showFade:Fade;
		private var activityUrl:String; 
		
		private var isHide:Boolean;
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
		 * StartScreenMediator 
		 */
		public function AssessmentStartScreenMediator( viewComponent:IAssessmentStartScreen )
		{
			super( NAME, viewComponent );
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component() : IAssessmentStartScreen
		{
			return viewComponent as IAssessmentStartScreen;
		}
		
		//-----------------------------------
		//	ModuleProxy
		//-----------------------------------
		private var _moduleProxy:ModuleProxy;
		
		private function get moduleProxy():ModuleProxy
		{
			if(!_moduleProxy)
				_moduleProxy = facade.retrieveProxy(ModuleProxy.NAME) as ModuleProxy;
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
		
		
		/**
		 *  @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();
			
			if( component )
			{
				component.addEventListener( AssessmentStartScreen.START_LEARNING, onStartLearningHandler );
			}
		}
		/**
		 *  @inheritDoc
		 */
		override public function onRemove():void
		{
			if(hideFade)
			{
				if(hideFade.isPlaying)
				{
					hideFade.stop();
				}
				hideFade = null;
			}
			if(showFade)
			{
				if(showFade.isPlaying)
				{
					showFade.stop();
				}
				showFade=null;
			}
			
			if( component )
			{
				component.removeEventListener( AssessmentStartScreen.START_LEARNING, onStartLearningHandler );
			}
			super.onRemove();
		}		
		/**
		 *  @inheritDoc
		 */
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.LOAD_MODULE,
				TTUConstants.SHOW_ASSESSMENT_START_SCREEN,
				TTUConstants.LOAD_MODULE,
				TTUConstants.UNLOAD_MODULE,
				TTUConstants.MODULE_ADDED,
				TTUConstants.SHOW_MODULE
				];
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function handleNotification(note:INotification):void
		{
			switch ( note.getName() )
			{
				case TTUConstants.UNLOAD_MODULE:
				{
					if(hideFade && hideFade.isPlaying)
					{
						hideFade.removeEventListener( EffectEvent.EFFECT_END, onHideEffectEnd);
						hideFade.end();
						hideFade = null;
						if(component.x != -(component.stageWidth))
							component.x = -(component.stageWidth);
					}
					else
					{
						component.x = -(component.stageWidth);
						component.alpha = 0;
						component.visible  = false;
					}
					break;
				}
					
				case TTUConstants.LOAD_MODULE:
				{
					hide(false);
					sendNotification(TTUConstants.REMOVE_ACTIVITY_COMPLETE_WINDOW);
					break;
				}
				case TTUConstants.SHOW_ASSESSMENT_START_SCREEN:
					moduleProxy.isUnitHome = true;
					sendNotification(TTUConstants.UNLOAD_MODULE);
					activityUrl = note.getBody() as String;
					component.visible  			= true;
					component.x		   			=  0;
					component.isPassed			= assessmentProxy.isPassed;
					var status:String			= assessmentProxy.status;
					component.activityState		= status;
					component.isResume			= status == ModuleStatus.FAILED || status == ModuleStatus.PASSED;
					component.title 			= assessmentProxy.name;
					component.score 			= Math.max(assessmentProxy.percentAchived, assessmentProxy.initScore);
					
					if(component.alpha == 0)
					{
						show(false);
					}
					break;
				default:
					break;	
			}
		}		
		
		
		
		//-------------------------------------------------------------------
		// Overriden methods : Event handlers
		//-------------------------------------------------------------------
		
		/**
		 * @private
		 * Handles <code>StartScreen.START_LEARNING</code> event
		 */
		
		private function onStartLearningHandler( event:Event = null ) : void
		{
			if(assessmentProxy && moduleProxy)
			{
				assessmentProxy.setAssessmentData(moduleProxy.lesson);
				assessmentProxy.resetAnswerSelected();
			}
			moduleProxy.isUnitHome = false;
			moduleProxy.isPaused = false;
			hide(true);
		}
		
		
		/**
		 * @private
		 */
		
		private function onEffectEndHandler( event:EffectEvent ) : void
		{
			//UIComponent(component).enabled = false;
		}
		/**
		 * @private
		 */
		
		private function onHideEffectEnd( event:EffectEvent ) : void
		{
			component.x = -(component.stageWidth);
			if(!isHide)
				return;
			
			moduleProxy.isUnitHome = false;
			moduleProxy.isPaused = false;
			sendNotification(TTUConstants.LOAD_MODULE, moduleProxy.currentModule.moduleURL);
			//sendNotification(TTUConstants.ACTIVITY_SELECT,activityUrl);
		}
		
		
		
		
		
		/**
		 * @private
		 */
		
		private function sendPauseResumeMessage(isPaused:Boolean=false):void
		{
			if(moduleProxy.isPaused == isPaused)
				return;
			
			moduleProxy.isPaused = isPaused;
			var message:ModulePipeMessage = 
				new ModulePipeMessage(PipeConstants.MODULE_TO_SHELL_MESSAGE, 
					MessageConstants.PAUSE_MODULE, isPaused);
			
			sendNotification(TTUConstants.SEND_MESSAGE_TO_MODULE, message);
		}
		
		
		/**
		 * @private
		 */
		
		private function onKeyPressedHandler( event:KeyboardEvent ) : void
		{
			if( event && event.keyCode == Keyboard.ENTER )
				onStartLearningHandler();
		}		
		
		
		/**
		 * @private
		 */
		
		private function hide(hasListener:Boolean = false) : void
		{
			if(hideFade && hideFade.isPlaying)
				return;
			
			UIComponent(component).enabled = false;
			component.x = -(component.stageWidth);
			if(component.alpha != 0)
			{
				isHide = hasListener
				hideFade = new Fade( component );
				hideFade.alphaFrom = 1;
				hideFade.alphaTo = 0;
				hideFade.duration = 800;
				hideFade.addEventListener( EffectEvent.EFFECT_END, onHideEffectEnd);
				hideFade.play();
				
			}
			
			
		}
		
		/**
		 * 
		 * @private
		 * 
		 */
		
		private function show(hasListener:Boolean = false) : void
		{
			if(showFade && showFade.isPlaying)
				return;
			component.x = 0;
			if(component.alpha == 0)
			{
				UIComponent(component).enabled = true;
				showFade = new Fade( component );
				showFade.alphaFrom = 0;
				showFade.alphaTo = 1;
				showFade.duration = 800;
				if(hasListener)
					showFade.addEventListener( EffectEvent.EFFECT_END, onEffectEndHandler );
				showFade.play();
			}
			sendPauseResumeMessage(true);
		}
	}
}