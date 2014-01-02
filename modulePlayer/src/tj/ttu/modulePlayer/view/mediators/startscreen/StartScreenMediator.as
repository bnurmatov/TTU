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
	
	import mx.events.EffectEvent;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.effects.Fade;
	
	import tj.ttu.base.constants.ModuleStatus;
	import tj.ttu.base.constants.TTUConstants;
	import tj.ttu.base.vo.ModuleVO;
	import tj.ttu.modulePlayer.model.ModuleProxy;
	import tj.ttu.modulePlayer.model.assessment.AssessmentProxy;
	import tj.ttu.modulePlayer.view.components.startscreen.StartScreen;
	import tj.ttu.modulePlayer.view.interfaces.IStartScreen;
	
	/**
	 * StartScreenMediator class 
	 */
	public class StartScreenMediator extends Mediator
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 */
		public static const NAME:String = "StartScreenMediator";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var hideFade:Fade;
		private var showFade:Fade;
		private var isShowPending:Boolean;
		
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
		public function StartScreenMediator( viewComponent:IStartScreen )
		{
			super( NAME, viewComponent );
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		public function get component() : IStartScreen
		{
			return viewComponent as IStartScreen;
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
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		override public function setViewComponent(viewComponent:Object):void
		{
			super.setViewComponent(viewComponent);
			if( component )
			{
				component.addEventListener( StartScreen.START_LEARNING, onStartLearningHandler );
				if(isShowPending)
				{
					isShowPending = false;
					component.visible = true;
					component.enabled = true;
					component.alpha = 0;
					component.title 		= moduleProxy.lessonName;
					component.description	= moduleProxy.lessonDescription;
					component.setFocus();
					show(false);
				}
			}
		}
		
		/**
		 *  @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();
			if( component )
			{
				component.addEventListener( StartScreen.START_LEARNING, onStartLearningHandler );
			}
		}
		/**
		 *  @inheritDoc
		 */
		override public function onRemove():void
		{
			if(hideFade && hideFade.isPlaying)
			{
				hideFade.stop();
			}
			if(showFade && showFade.isPlaying)
			{
				showFade.stop();
			}
			
			if( component )
			{
				component.removeEventListener( StartScreen.START_LEARNING, onStartLearningHandler );
			}
			super.onRemove();
		}		
		/**
		 *  @inheritDoc
		 */
		override public function listNotificationInterests():Array
		{
			return [TTUConstants.LOAD_MODULE,
				TTUConstants.SHOW_START_SCREEN,
				TTUConstants.HIDE_START_SCREEN,
				TTUConstants.SHOW_ASSESSMENT_START_SCREEN,
				TTUConstants.LOAD_MODULE,
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
				case TTUConstants.SHOW_ASSESSMENT_START_SCREEN:
				case TTUConstants.HIDE_START_SCREEN:
				case TTUConstants.LOAD_MODULE:
				{
					hide();
					break;
				}
				case TTUConstants.SHOW_START_SCREEN:
					moduleProxy.isUnitHome = true;
					moduleProxy.isPaused = true;
					if(component)
					{
						component.visible = true;
						component.enabled = true;
						component.alpha = 0;
						component.isResume		= ( moduleProxy.status != ModuleStatus.NOT_ATTEMPTED );
						component.title 		= moduleProxy.lessonName;
						component.description	= moduleProxy.lessonDescription;
						component.setFocus();
						show(false);
					}
					else
					{
						isShowPending = true;
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
			moduleProxy.isUnitHome = false;
			moduleProxy.isPaused = false;
			hide();
			onUnitState();
		}
		
		
		/**
		 * @private
		 */
		
		private function onEffectEndHandler( event:EffectEvent ) : void
		{
			component.enabled = false;
			onUnitState();
		}
		/**
		 * @private
		 */
		
		private function onHideEffectEnd( event:EffectEvent ) : void
		{
			if(assessmentProxy && assessmentProxy.isAssessment && (assessmentProxy.status == ModuleStatus.FAILED ||assessmentProxy.status == ModuleStatus.PASSED))
			{
				sendNotification(TTUConstants.SHOW_ASSESSMENT_START_SCREEN);	
			}
			else
			{
				if(assessmentProxy && !assessmentProxy.isAssessment)
					sendNotification(TTUConstants.SHOW_MODULE);
				component.x = -(component.stageWidth);
				component.visible = false;
				moduleProxy.isUnitHome = false;
				moduleProxy.isPaused = false;
			}
			
		}
		
		
		/**
		 * @private
		 */	
		
		private function onUnitState() : void
		{
			var noteType:String = TTUConstants.SHOW_MODULE;
			var actVo:ModuleVO;
			
			moduleProxy.currentModuleIndex = isNaN(moduleProxy.currentModuleIndex) ? 0 : moduleProxy.currentModuleIndex; 
			actVo = moduleProxy.currentModule;
			
			if(moduleProxy.currentModule.name == "Assessment")
			{
				assessmentProxy.isAssessment = true;
				sendNotification(TTUConstants.HIDE_START_SCREEN);
				sendNotification(TTUConstants.SHOW_ASSESSMENT_START_SCREEN, moduleProxy.currentModule.moduleURL);
			}
			else
				sendNotification(TTUConstants.LOAD_MODULE, moduleProxy.currentModule? moduleProxy.currentModule.moduleURL : null);
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
		
		private function hide() : void
		{
			if(hideFade && hideFade.isPlaying)
				return;
			
			if(component.alpha != 0)
			{
				hideFade = new Fade( component );
				hideFade.alphaFrom = 1;
				hideFade.alphaTo = 0;
				hideFade.duration = 800;
				hideFade.addEventListener( EffectEvent.EFFECT_END, onHideEffectEnd);
				hideFade.play();
			}
			else
				component.visible = false;	
			
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
				showFade = new Fade( component );
				showFade.alphaFrom = 0;
				showFade.alphaTo = 1;
				showFade.duration = 800;
				if(hasListener)
					showFade.addEventListener( EffectEvent.EFFECT_END, onEffectEndHandler );
				showFade.play();
			}
		}
	}
}