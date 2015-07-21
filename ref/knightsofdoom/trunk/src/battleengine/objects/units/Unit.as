package battleengine.objects.units 
{
	import battleengine.effects.Explosion;
	import battleengine.gui.HPbar;
	import battleengine.objects.GameObject;
	import com.rnk.animation.Animation;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class Unit extends GameObject
	{
		private var frozenAnimation:Animation;
		public var sprite:Animation;
		protected var speedX:Number=0;
		protected var speedY:Number=0;
		protected var hpBar:HPbar;
		public var hpMax:Number=1.0;
		public var hp:Number = 1.0;
		public var alive:Boolean = true;
		public var killTimer:int = 1;
		public var hitTimer:int = 0;
		public var hitTimerMax:int = 10;
		public var hurt:Boolean = false;
		public var mover:Mover;
		public var killByPlayer:Boolean=true;
		
		//freeze
		public var frozen:Boolean = false;
		public var frozenTimerMax:int = 180;
		public var frozenTimer:int = frozenTimerMax;
		
		//magnet
		public var magnet:Boolean = false;
		public var magnetTimerMax:int = 60;
		public var magnetTimer:int = magnetTimerMax;
		public var savedMover:Mover;
		
		public function Unit(sprite:Animation,startX:Number,startY:Number,hp:int=1.0) 
		{
			this.hp = hp;
			this.hpMax = hp;
			
			this.sprite = sprite;
			addChild(sprite);
			
			this.x = startX;
			this.y = startY;
			
			SetCollisionRadius(sprite.width / 2);
			
			//mover = new SinusoidaMover();
			//mover = new LinearMover(Math.random() * Math.PI * 2, 5 + Math.random() * 5.0);
			//mover = new BouncingMover(Math.random() * Math.PI * 2, 5 + Math.random() * 5.0);
			//SetMover(SinusoidaMover2);
			SetMover2( new BouncingMover(Math.random()*Math.PI*2,3+Math.random()*2));
			
			if (hpMax > 1.0)
			{
				hpBar = new HPbar(Math.floor(hpMax));
				hpBar.x = -hpBar.width / 2;
				hpBar.y = sprite.height/ 2+10;
				addChild(hpBar);
			}
		}
		
		public function Freeze(frozenTimerMax:int=180):void
		{
			this.frozenTimerMax = frozenTimerMax;
			frozen = true;
			frozenTimer = frozenTimerMax;
			
			if (!frozenAnimation)
			{
				frozenAnimation = Assets.GetAnimation(Assets.ANIM_FROZEN);
			}
			
			addChild(frozenAnimation);
			frozenAnimation.play(false);
			
			AddPendingValue();
			
		}
		
		private function UnFreeze():void
		{
			if (!frozen) throw new Error("halt");
			frozen = false;
			removeChild(frozenAnimation);
			frozenAnimation.stop();
			
			RemovePendingValue();
			
		}
		
		public function Hit(dmg:Number, ignoreHurt:Boolean = false ):void
		{
			if (!ignoreHurt && hurt || !alive) return;
			
			if (!ignoreHurt)
			{
				hurt = true;
				hitTimer = 0;
			}
			
			hp -= dmg;
			
			if (hp <= 0)
			{
				hp = 0;
				
				DrawHpBar();
				
				alive = false;
				//kill = true;
				
				AddPendingValue();
				
			}
		}
		
		override public function Update():void 
		{
			super.Update();
			
			DrawHpBar();
			
			if (frozen) 
			{
				frozenTimer--;
				if (frozenTimer <= 0)
				{
					UnFreeze();
				}
				
			}
			
			if (magnet)
			{
				magnetTimer--;
				if (magnetTimer <= 0)
				{
					Unmagnet();
				}
				
				//дублируем
				mover.Update();
			
				speedX = mover.velocity.x;
				speedY = mover.velocity.y;
				
				x += speedX;
				y += speedY;
				
				if (hurt)
				{
					hitTimer++;
					if (hitTimer >= hitTimerMax)
					{
						hitTimer = 0;
						hurt = false;
					}
				}
				
				if (!alive)
				{
					killTimer--;
					if (killTimer < 0)
					{
						//papa.pendingObjects--;
						kill = true;
						Explode();
					}
				}
			}
			
			if (frozen || magnet)
				return;
			
			mover.Update();
			
			speedX = mover.velocity.x;
			speedY = mover.velocity.y;
			
			x += speedX;
			y += speedY;
			
			if (x < 0-width)
			{
				x = 800+width;
			}
			if (x > 800+width)
			{
				x = -width;
			}
			if (y < 0-height)
			{
				y = 600 + height;
				x = Math.random() * Main.SCREEN_WIDTH;
			}
			if (y > 600+height)
			{
				y = -height;
				x = Math.random() * Main.SCREEN_WIDTH;
				//alive = false;
			}
			
			/*var whoWeCollided:Array = GetCollidedObjects();
			for each (var item:GameObject in whoWeCollided) 
			{
				if (item is Unit && !item.kill)
				{
					(item as Unit).Hit(1.0);
					Hit(1.0);
				}
			}*/
			
			if (hurt)
			{
				hitTimer++;
				if (hitTimer >= hitTimerMax)
				{
					hitTimer = 0;
					hurt = false;
				}
			}
			
			if (!alive)
			{
				killTimer--;
				if (killTimer < 0)
				{
					RemovePendingValue();
					kill = true;
					Explode();
				}
			}
			
		}
		
		protected function DrawHpBar():void 
		{
			
			if (!hpBar && hpMax > 1.0)
			{
				hpBar = new HPbar(Math.floor(hpMax));
				hpBar.x = -hpBar.width / 2;
				hpBar.y = sprite.height/ 2+10;
				addChild(hpBar);
			}
			
			if (hpBar)
			{
				hpBar.SetMaxHP(Math.floor(hpMax));
				hpBar.SetHP(Math.floor(hp));
				hpBar.x = -hpBar.width / 2;
			}
		
		}
		
		public function SetMover(moverClass:Class):void 
		{
			mover = new moverClass();
			mover.papa = this;
		}
		
		public function SetMover2(moverObject:Mover):void 
		{
			mover = moverObject;
			mover.papa = this;
		}
		
		public function Magnet(magnetX:Number, magnetY:Number, magnetPower:Number):void 
		{
			/*if (!magnet)
				AddPendingValue();*/
			
			magnet = true;
			magnetTimer = magnetTimerMax;
			var magnetMover:MagnetoMover = new MagnetoMover(magnetX, magnetY, magnetPower);
			savedMover = mover;
			SetMover2(magnetMover);
			
			
		}
		
		public function Unmagnet():void 
		{
			/*if (magnet)
				RemovePendingValue();*/
			
			magnet = false;
			SetMover2(savedMover);
			savedMover = null;
			
			
		}
		
		protected function Explode():void 
		{
			
		}
		
		
		
	}

}