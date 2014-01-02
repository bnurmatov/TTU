////////////////////////////////////////////////////////////////////////////////
// Copyright Mar 4, 2013, Tajik Technical University
// All Rights Reserved.
// TTU Confidential Information
////////////////////////////////////////////////////////////////////////////////

package tj.ttu.moduleUtility.view.components
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.IFlexModuleFactory;
	import mx.core.IStateClient;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.resources.ResourceManager;
	import mx.states.State;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	
	import spark.events.ElementExistenceEvent;
	import spark.modules.Module;
	
	import tj.ttu.base.constants.FontConstants;
	import tj.ttu.base.constants.ResourceConstants;
	import tj.ttu.base.utils.MemoryLeakImport;
	import tj.ttu.moduleUtility.constants.ModuleConstants;
	import tj.ttu.moduleUtility.view.interfaces.IModule;
	
	/**
	 * Skin state for start screen view.
	 */	
	[SkinState("startScreen")]
	
	/**
	 * Skin state for content view.
	 */	
	[SkinState("content")]
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Event is dispatched when module is pispose.
	 * 
	 *  @eventType dispose
	 */	
	[Event(name="dispose", type="flash.events.Event")]
	
	[Frame(factoryClass="mx.core.FlexModuleFactory")]
	/**
	 * ActivityModule.
	 * 
	 * A base class for all activity modules.
	 * 
	 * Important! Always override "facade" property in subclasses.
	 */
	public class ActivityModule extends Module implements IPipeAware, IModule, IEventDispatcher, IStateClient
	{
		
		//----------------------------------------------------------------------
		//
		//  Class constants
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Class methods
		//
		//----------------------------------------------------------------------
		
		//----------------------------------------------------------------------
		//
		//  Constructor
		//
		//----------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 *  Add event listener for <code>FlexEvent.INITIALIZE</code> event.
		 * 
		 *  @see FlexEvent.INITIALIZE
		 */		
		public function ActivityModule()
		{
			super();
			addEventListener(FlexEvent.INITIALIZE, initializeHandler);
			resourceManager.addEventListener("change", onResourceChange);
		}
		
		private function onResourceChange(event:Event):void
		{
			
		}
		
		//----------------------------------------------------------------------
		//
		//  Skin parts
		//
		//----------------------------------------------------------------------
		
		[SkinPart(required="false")]
		/**
		 *  Reference to start screen skin part, that defines in skin class. 
		 */		
		public var startScreen:*;
		
		[SkinPart(required="false")]
		/**
		 *  Reference to content skin part, that defines in skin class. 
		 */		
		public var content:*;
		
		//----------------------------------------------------------------------
		//
		//  Variables
		//
		//----------------------------------------------------------------------
		
		public var facadeName:String = "";
		private var imports:MemoryLeakImport;
		//----------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//----------------------------------------------------------------------
		
		override public function get states():Array
		{
			return super.states.concat(
				[new State({"name":ActivityModuleState.START_SCREEN}),
					new State({"name":ActivityModuleState.CONTENT})]
			);
		}
		/**
		 * @inheritDoc
		 */
		override public function set currentState(value:String):void
		{
			super.currentState = value;
			
			if (skin)
				skin.currentState = value;
			
			invalidateSkinState();
		}
		
		//----------------------------------------------------------------------
		//
		//  Properties
		//
		//----------------------------------------------------------------------
		
		//--------------------------------------
		//  facade
		//--------------------------------------
		
		protected var _facade:IFacade;
		
		public function get facade():IFacade
		{
			return _facade;
		}
		
		public function set facade(value:IFacade):void
		{
			_facade = value;
		}
		
		//--------------------------------------
		//  activityMode
		//--------------------------------------
		
		/**
		 * Activity mode the module is made for. Used for 
		 * assessment, REP and other versions of activity.
		 */
		public function get activityMode():String
		{
			return "";
		}
		
		//----------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//----------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function setFocus():void
		{
			if (content)
			{
				content.setFocus();
			}
			else if (startScreen)
			{
				startScreen.setFocus();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getCurrentSkinState():String
		{
			if (!skin)
				return "";
			
			return skin.currentState;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			var event:ElementExistenceEvent = 
				new ElementExistenceEvent(ElementExistenceEvent.ELEMENT_ADD,
					true, false, instance as IVisualElement);
			this.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function partRemoved(partName:String, instance:Object):void
		{
			var event:ElementExistenceEvent = 
				new ElementExistenceEvent(ElementExistenceEvent.ELEMENT_REMOVE,
					true, false, instance as IVisualElement);
			this.dispatchEvent(event);
			
			super.partRemoved(partName, instance);
		}
		
		
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();
			var fontName:String = resourceManager.getString(ResourceConstants.FONT, FontConstants.UI_FONT);
			if(fontName && String(getStyle("fontFamily")) !=  fontName)
			{
				setStyle("fontFamily", fontName);
				setGlobalStyle(fontName);
			}
		}
		//----------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------
		private function setGlobalStyle(fontName:String):void
		{
			var cssCustom:CSSStyleDeclaration;
			var styleChanged:Boolean = false;
			var toolTipCSS:CSSStyleDeclaration = styleManager.getMergedStyleDeclaration("mx.controls.ToolTip");
			if(toolTipCSS)
			{
				if(toolTipCSS.getStyle("fontFamily") != fontName)
				{
					toolTipCSS.setStyle( "fontFamily", fontName );
				}
			}
			
				try
				{
					cssCustom = styleManager.getMergedStyleDeclaration("spark.components.Label");
					if(cssCustom)
					{
						styleChanged = false;
						if(cssCustom.getStyle("fontFamily") != fontName)
						{
							styleChanged = true;
							cssCustom.setStyle( "fontFamily", fontName );
						}
						if(styleChanged)
							styleManager.setStyleDeclaration("spark.components.Label", cssCustom, true);
					}
					else if(!cssCustom)
					{
						cssCustom = new CSSStyleDeclaration("spark.components.Label");
						cssCustom.setStyle( "fontFamily", fontName );
						styleManager.setStyleDeclaration("spark.components.Label", cssCustom, true);
					}
				}
				catch(e:Error){}
				try
				{
					cssCustom = styleManager.getMergedStyleDeclaration(".uiFont");
					if(cssCustom)
					{
						styleChanged = false;
						if(cssCustom.getStyle("fontFamily") != fontName)
						{
							styleChanged = true;
							cssCustom.setStyle( "fontFamily", fontName );
						}
						if(styleChanged)
							styleManager.setStyleDeclaration(".uiFont", cssCustom, true);
					}
					else if(!cssCustom)
					{
						cssCustom = new CSSStyleDeclaration(".uiFont");
						cssCustom.setStyle( "fontFamily", fontName );
						styleManager.setStyleDeclaration(".uiFont", cssCustom, true);
					}
				}
				catch(e:Error){}
		}
		

		/**
		 * Accept an input pipe.
		 * 
		 * <p>Registers an input pipe with this module's Junction.</p>
		 */
		public function acceptInputPipe(name:String, pipe:IPipeFitting):void
		{
			if (facade)
			{
				facade.sendNotification(JunctionMediator.ACCEPT_INPUT_PIPE, pipe, name);
			}
		}
		
		/**
		 * Accept an output pipe.
		 * 
		 * <p>Registers an input pipe with this module's Junction.</p>
		 */
		public function acceptOutputPipe(name:String, pipe:IPipeFitting):void
		{
			if (facade)
			{
				facade.sendNotification(JunctionMediator.ACCEPT_OUTPUT_PIPE, pipe, name);
			}					
		}
		
		/**
		 * Dispatches DISPOSE event, to tell that it is ready for GC.
		 */
		public function dispose():void
		{
			dispatchEvent(new Event(ModuleConstants.DISPOSE));
			
			_facade = null;
		}
		
		//----------------------------------------------------------------------
		//
		//  Handlers
		//
		//----------------------------------------------------------------------
		
		/**
		 * As usual don't override.
		 */
		protected function initializeHandler(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.INITIALIZE, initializeHandler);
			invalidateSkinState();
			/*if (!facade)
			{
				// Note: Exception is for developers only
				throw new Error("The \"facade\" property of ActivityModule returns null! " + 
								"Override this getter in your module subclass.");
								//... to return appropriate Facade instance
			}*/
		}
		
	}
}