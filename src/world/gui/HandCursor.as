package world.gui 
{
	import chainreaction.Game;
	import com.rnk.animation.Animation;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class HandCursor extends Sprite
	{
		private var handSprite:Animation;
		public var papa:Game;
		public var hitFunc:Function;
		private var radiusSprite:Sprite;
		private var spriteHolder:Sprite;
		
		public function HandCursor() 
		{
			
		}
		
		public function Init(papa:Game):void
		{
			this.papa = papa;
			
			spriteHolder = new Sprite();
			addChild(spriteHolder);
			
			radiusSprite = new Sprite();
			spriteHolder.addChild(radiusSprite);
			
			SetRadius(100);
			
			//handSprite = Assets.GetAnimation(Assets.ANIM_HAND_CURSOR);
			spriteHolder.addChild(handSprite);
			handSprite.stop();
			
			SetListeners(true);
			Mouse.hide();
			
			mouseChildren = false;
			mouseEnabled = false;
			
			handSprite.addEventListener(Animation.START, OnStartPlayingAnimation);
			handSprite.addEventListener(Animation.STOP, OnFinishPlayingAnimation);
			handSprite.addEventListener(Animation.FINISH, OnFinishPlayingAnimation);
			
			spriteHolder.x = stage.mouseX;
			spriteHolder.y = stage.mouseY;
			
		}
		
		public function Enabled(orly:Boolean):void
		{
			spriteHolder.visible = orly;
			
			SetListeners(orly);
			if (orly)
				Mouse.hide();
			else
				Mouse.show();
		}
		
		private function OnStartPlayingAnimation(e:Event):void 
		{
			radiusSprite.visible = false;
		}
		
		private function OnFinishPlayingAnimation(e:Event):void 
		{
			radiusSprite.visible = true;
		}
		
		public function Die():void
		{
			handSprite.removeEventListener(Animation.START, OnStartPlayingAnimation);
			handSprite.removeEventListener(Animation.STOP, OnFinishPlayingAnimation);
			handSprite.removeEventListener(Animation.FINISH, OnFinishPlayingAnimation);
			Mouse.show();
			SetListeners(false);
		}
		
		private function SetListeners(orly:Boolean):void 
		{
			(orly?stage.addEventListener:stage.removeEventListener)(MouseEvent.MOUSE_DOWN, OnMouseDown);
			(orly?stage.addEventListener:stage.removeEventListener)(MouseEvent.MOUSE_UP, OnMouseUp);
			(orly?stage.addEventListener:stage.removeEventListener)(MouseEvent.MOUSE_MOVE, OnMouseMove);
			(orly?stage.addEventListener:stage.removeEventListener)(MouseEvent.MOUSE_OUT, OnMouseOut);
			
			(orly?handSprite.addFrameListener:handSprite.removeFrameListener)(10, OnAnimationHitFrame);
		}
		
		private function OnAnimationHitFrame():void 
		{
			if (Boolean(hitFunc))
			{
				hitFunc(spriteHolder.x, spriteHolder.y);
			}
		}
		
		private function OnMouseDown(e:MouseEvent):void 
		{
			if (papa.paused) return;
			
			if (!handSprite.isPlaying || handSprite.currentFrame > 10)
			{
				handSprite.play(false);
			}
		}
		
		private function OnMouseUp(e:MouseEvent):void 
		{
			
		}
		
		private function OnMouseMove(e:MouseEvent):void 
		{
			spriteHolder.x = e.stageX;
			spriteHolder.y = e.stageY;
		}
		
		private function OnMouseOut(e:MouseEvent):void 
		{
			
		}
		
		public function SetRadius(inPixels:Number):void 
		{
			radiusSprite.graphics.clear();
			radiusSprite.graphics.lineStyle(1.0, 0xFFFFFF, 0.7);
			radiusSprite.graphics.beginFill(0xFFFFFF, 0.1);
			radiusSprite.graphics.drawCircle(0, 0, inPixels);
		}
		
	}

}