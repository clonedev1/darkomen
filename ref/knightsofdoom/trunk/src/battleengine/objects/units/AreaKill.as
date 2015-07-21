package battleengine.objects.units 
{
	import battleengine.effects.Explosion;
	import battleengine.gui.HPbar;
	import battleengine.objects.GameObject;
	import com.rnk.animation.Animation;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class AreaKill extends GameObject
	{
		public var damage:Number = 1.0;
		public var killTimer:int = 1;
		public var deadly:Boolean = true;
		private var hitMonsters:Dictionary;
		private var ignoreHurt:Boolean;
		
		public function AreaKill(radius:Number,startX:Number,startY:Number,damage:Number,time:int=1,ignoreHurt:Boolean=false) 
		{
			
			this.damage = damage;
			this.x = startX;
			this.y = startY;
			this.ignoreHurt = ignoreHurt;
			this.killTimer = time;
			
			SetCollisionRadius(radius);
			
			AddPendingValue();
		}
		
		override public function Update():void 
		{
			super.Update();
			
			var whoWeCollided:Array = GetCollidedObjects();
			for each (var item:GameObject in whoWeCollided) 
			{
				if (item is Unit && (item as Unit).alive)
				{
					(item as Unit).Hit(damage,ignoreHurt);
					
				}
			}
			
			killTimer--;
			if (killTimer < 0)
			{
				kill = true;
				
			}
			
		}
		
		
	}

}