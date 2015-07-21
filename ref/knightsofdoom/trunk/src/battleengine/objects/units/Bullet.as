package battleengine.objects.units 
{
	import battleengine.effects.Explosion;
	import battleengine.objects.GameObject;
	import com.rnk.animation.Animation;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import soundmanager.SoundManager;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class Bullet extends GameObject
	{
		private var sprite:Animation;
		private var speed:Number = 10.0;
		private var speedX:Number;
		private var speedY:Number;
		private var delay:int;
		private var customExplosionAnim:Animation;
		private var customSound:int;
		private var hitMultipleTargets:Boolean;
		//private var hitMonsters:Dictionary;
		public var damage:Number = 1.0;
		public var delayed:Boolean = false;
		public var boundsKill:Boolean = false;
		
		
		public function Bullet(
								startX:Number, 
								startY:Number, 
								angle:Number, 
								damage:Number = 1, 
								speed:Number=10.0,
								delay:int = 0,
								customAnim:Animation = null,
								customExplosionAnim:Animation = null,
								customSound:int = -1,
								hitMultipleTargets:Boolean = false,
								customCollisionRadius:Number = -1,
								boundsIgnoreFirst:Boolean=false

		)
		{
			this.boundsKill = !boundsIgnoreFirst;
			this.hitMultipleTargets = hitMultipleTargets;
			this.customSound = customSound;
			this.customExplosionAnim = customExplosionAnim;
			
			if (customAnim)
				sprite = customAnim;
			else
				sprite = Assets.GetAnimation(Assets.ANIM_BULLET);
			addChild(sprite);
			
			sprite.play();
			
			this.x = startX;
			this.y = startY;
			this.damage = damage;
			this.delay = delay;
			this.speed = speed;
			delayed = delay > 0;
			
			speedX = Math.cos(angle)*speed;
			speedY = Math.sin(angle)*speed;
			
			if (customCollisionRadius<0)
				SetCollisionRadius(sprite.width / 2);
			else
				SetCollisionRadius(customCollisionRadius);
			
			//hitMonsters = new Dictionary(true);
			
			AddPendingValue();
			
		}
		
		override public function Update():void 
		{
			if (delayed)
			{
				delay--;
				if (delay < 0)
				{
					delayed = false;
				}
				if (delayed)
					return;
			}
			
			super.Update();
			
			x += speedX;
			y += speedY;
			
			var xBoundsOkay:Boolean = false;
			var yBoundsOkay:Boolean = false;
			
			if (x < 0-width)
			{
				if (boundsKill)
				kill = true;
			} else
			if (x > Main.SCREEN_WIDTH+width)
			{
				if (boundsKill)
				kill = true;
			} else
			{
				xBoundsOkay = true;
			}
			
			if (y < 0-height)
			{
				if (boundsKill)
				kill = true;
			} else
			if (y > Main.SCREEN_HEIGHT+height)
			{
				if (boundsKill)
				kill = true;
			} else
			{
				yBoundsOkay = true;
			}
			
			if (xBoundsOkay && yBoundsOkay)
				boundsKill = true;
			
			var hitMonster:Boolean = false;
			var whoWeCollided:Array = GetCollidedObjects();
			for each (var item:GameObject in whoWeCollided) 
			{
				if (!kill /*&& !hitMonsters[item] */&& item is Unit && (item as Unit).alive)
				{
					(item as Unit).Hit(damage,!hitMultipleTargets);
					//hitMonsters[item] = true;
					if (!hitMultipleTargets)
						kill = true;
					
					hitMonster = true;
					
				}
			}
			
			if (hitMonster && kill && customExplosionAnim)
			{
				if (customSound >= 0)
					SoundManager.addBoomSoundByPos(customSound, x, SoundManager.BOOM_PRI_0_LOW);
				
				var explosion:Explosion = new Explosion(customExplosionAnim);
				explosion.x = x;
				explosion.y = y;
				papa.screen.addChild(explosion);
			}
			
			
			
		}
		
		
		
	}

}