package client.game.gui.hints 
{
	import client.game.Game;
	import client.game.GameScreenModes;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 
	 */
	public class HintManager extends Sprite
	{
		
		//config
		private static const APPEAR_TIME:Number = 0.7;
		private static const APPEAR_TIME_PAUSE:Number = 0.1;
		private static const DX:Number = 20;
		private static const DY:Number = 20;
		
		private var hints:Array = [];
		private var hintSpriteHolder:Sprite = new Sprite();
		private var flyingTextSpriteHolder:Sprite = new Sprite();
		private var currentHint:Hint;
		private var registeredHintObjects:Dictionary = new Dictionary();
		public static var instance:HintManager;
		
		//appear timer
		private var appear_timer:Timer;
		private var appear_timer_mode:int = 0;
		
		public function HintManager() 
		{
			mouseChildren = mouseEnabled = false;
			instance = this;
			
			flyingTextSpriteHolder.mouseChildren = flyingTextSpriteHolder.mouseEnabled = false;
			addChild(flyingTextSpriteHolder);
			
			hintSpriteHolder.mouseChildren = hintSpriteHolder.mouseEnabled = false;
			addChild(hintSpriteHolder);
			
		}
		
		public function Init():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			
			hintSpriteHolder.x = stage.mouseX;
			hintSpriteHolder.y = stage.mouseY;
			
			appear_timer = new Timer(APPEAR_TIME*1000,1);
			appear_timer.addEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
			
		}
		
		public function Die():void
		{
			//clear main mouse listener
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
			
			//clear hint balloons
			for each (var item:Hint in hints) 
			{
				item.Die();
			}
			hints = [];
			
			//clear registered hint objects
			for (var dsp:Object in registeredHintObjects) 
			{
				dsp.removeEventListener(MouseEvent.MOUSE_OVER, OnMouseOutHintObject);
			}
			
			registeredHintObjects = new Dictionary();
			
			//clear flying texts
			while (flyingTextSpriteHolder.numChildren)
			{
				var fl:FlyingText = flyingTextSpriteHolder.getChildAt(0) as FlyingText;
				if (fl)
					fl.Die();
			}
			
			//timer
			appear_timer.reset();
			appear_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
		}
		
		private function OnTimerComplete(e:TimerEvent):void 
		{
			//appear
			if (appear_timer_mode == 0)
			{
				hintSpriteHolder.visible = true;
				
			}
			else
			if (appear_timer_mode == 1)
			{
				appear_timer_mode = 0;
			}
		}
		
		private function OnMouseMove(e:MouseEvent):void 
		{
			hintSpriteHolder.x = stage.mouseX;
			hintSpriteHolder.y = stage.mouseY;
			
			CurrentHintPositioning();
		}
		
		public function RegisterHintObject(dsp:DisplayObject, hintType:Class, hintParams:Object = null, hintData:Object = null):void
		{
			UnregisterHintObject(dsp);
			dsp.addEventListener(MouseEvent.MOUSE_OVER, OnMouseOverHintObject);
			dsp.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOutHintObject);
			registeredHintObjects[dsp] = { dsp:dsp, hintType:hintType, hintParams:hintParams, hintData:hintData };
		}
		
		private function OnMouseOverHintObject(e:MouseEvent):void 
		{
			var hObj:Object = registeredHintObjects[e.currentTarget];
			if (hObj)
			{
				hObj.hint = ShowHint(hObj.hintType, hObj.hintParams, hObj.hintData);
			}
		}
		
		public function UnregisterHintObject(dsp:DisplayObject):void
		{
			var hObj:Object = registeredHintObjects[dsp];
			if (hObj)
			{
				HideHint(hObj.hint);
				hObj.dsp.removeEventListener(MouseEvent.MOUSE_OVER, OnMouseOverHintObject);
				hObj.dsp.removeEventListener(MouseEvent.MOUSE_OUT, OnMouseOutHintObject);
			}
			
			registeredHintObjects[dsp] = null;
		}
		
		private function OnMouseOutHintObject(e:MouseEvent):void 
		{
			var hObj:Object = registeredHintObjects[e.currentTarget];
			if (hObj)
			{
				HideHint(hObj.hint);
			}
		}
		
		public function AddFlyingText(x:Number, y:Number, text:String, style:Object = null):FlyingText
		{
			var txt:FlyingText = new FlyingText(text, style);
			txt.x = x;
			txt.y = y;
			flyingTextSpriteHolder.addChild(txt);
			txt.Init();
			return txt;
		}
		
		public function ShowHint(hintType:Class, hintParams:Object = null, hintData:Object = null):Hint
		{
			//change current hint and return its ref
			var hint:Hint = new hintType();
			hint.papa = this;
			hint.params = hintParams;
			hint.data = hintData;
			hints.unshift(hint);
			hint.Init();
			return SetNextActiveHint();
			
			//test usage:
			//ShowHint(HintTypes.TEXT_HINT,{align:"right-top",bounds:true},{text:"hallo thare"});
		}
		
		public function HideHint(specific:Hint = null):void
		{
			//if non specific then hide whatever current is
			var hintToRemove:Hint = (specific == null?currentHint:specific);
			if (!hintToRemove)
			{
				return;
			}
			
			RemoveHint(hintToRemove, false);
			
			SetNextActiveHint();
		}
		
		private function SetNextActiveHint():Hint
		{
			if (hints.length == 0) return null;
			
			RemoveHint(currentHint, true);
			
			currentHint = hints[0];
			currentHint.active = true;
			currentHint.Show();
			
			hintSpriteHolder.addChild(currentHint);
			
			CurrentHintPositioning();
			
			//timer
			if (!appear_timer.running)
			{
				if (appear_timer_mode == 0)
				{
					appear_timer.reset();
					appear_timer.delay = APPEAR_TIME * 1000;
					appear_timer.start();
					hintSpriteHolder.visible = false;
				} else
				{
					
				}
			} else
			{
				if (appear_timer_mode == 1)
				{
					appear_timer.reset();
				}
			}
			
			return currentHint;
		}
		
		private function RemoveHint(hint:Hint,onlyHide:Boolean=false):void 
		{
			if (hints.indexOf(hint) < 0) return;
			
			hintSpriteHolder.removeChild(hint);
			hint.active = false;
			hint.Hide();
			
			if (!onlyHide)
			{
				hints.splice(hints.indexOf(hint), 1);
				hint.Die();
			}
			
			if (hint == currentHint)
			{
				
				currentHint = null;
			}
			
			if (appear_timer_mode == 0)
				{
					if (!appear_timer.running)
					{
						appear_timer_mode = 1;
						appear_timer.reset();
						appear_timer.delay = APPEAR_TIME_PAUSE * 1000;
						appear_timer.start();
					}
				} else
				if (appear_timer_mode == 1)
				{
					if (!appear_timer.running)
					{
						appear_timer.reset();
						appear_timer.delay = APPEAR_TIME_PAUSE * 1000;
						appear_timer.start();
					}
				}
		}
		
		private function CurrentHintPositioning():void 
		{
			if (!currentHint) return;
			
			//params
			var drect:Rectangle = new Rectangle(0,0,currentHint.width,currentHint.height);
			var align:String = HintAlignMode.right_bottom;
			
			if (currentHint.params && currentHint.params.align!=undefined)
				align = currentHint.params.align;
			
			CalcDxDy();
			
			//check bounds
			var bounds:Boolean = true;
			if (currentHint.params && currentHint.params.bounds!=undefined)
				bounds = currentHint.params.bounds;
				
			if (bounds)
			{
				//make bounds rect
				var boundsRect:Rectangle = currentHint.getBounds(currentHint);
				//check if we go out of screen
				//change align accordingly
				
				var screenRect:Rectangle = new Rectangle();
				if (Game.instance.screenMode == GameScreenModes.FULLSCREEN_MODE)
				{
					screenRect = Game.instance.fullScrRect.clone();
				} else
				{
					screenRect.x = screenRect.y = 0;
					screenRect.width = CONFIGURABLE.SCREEN_WIDTH;
					screenRect.height = CONFIGURABLE.SCREEN_HEIGHT;
				}
				
				if (hintSpriteHolder.x + drect.left<screenRect.left || hintSpriteHolder.x + drect.right>screenRect.right)
				{
					var new_align:String = InvertAlign(align, HintAlignMode.right_top, HintAlignMode.left_top);
					if (new_align == "")
						new_align  = InvertAlign(align, HintAlignMode.right_bottom, HintAlignMode.left_bottom);
					align = new_align;
				}
				if (hintSpriteHolder.y + drect.top<screenRect.top || hintSpriteHolder.y + drect.bottom>screenRect.bottom)
				{
					new_align = InvertAlign(align, HintAlignMode.right_top, HintAlignMode.right_bottom);
					if (new_align == "")
						new_align  = InvertAlign(align, HintAlignMode.left_top, HintAlignMode.left_bottom);
					align = new_align;
				}
				
				CalcDxDy();
				
				function InvertAlign(old_align:String,align1:String,align2:String):String
				{
					return align == align1?align2:(align == align2?align1:"");
				}
			}
			
			currentHint.x = drect.x;
			currentHint.y = drect.y;
			
			
			function CalcDxDy():void
			{
				var dx:Number = DX;
				var dy:Number = DY;
				
				switch (align)
				{
					case HintAlignMode.right_top:
						drect.x = dx;
						drect.y = -dy - currentHint.height;
					break;
					case HintAlignMode.left_top:
						drect.x = -dx - currentHint.width;
						drect.y = -dy - currentHint.height;
					break;
					case HintAlignMode.left_bottom:
						drect.x = -dx - currentHint.width;
						drect.y = dy;
					break;
					case HintAlignMode.right_bottom:
					default:
						drect.x = dx;
						drect.y = dy;
					break;
				}
			}
		}
	}

}