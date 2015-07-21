package world.objects.actors 
{
	import com.rnk.animation.Animation;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import world.objects.GameObject;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class Actor extends GameObject
	{
		public var sprite:DisplayObject;
		
		public function Actor(sprite:DisplayObject,startX:Number,startY:Number) 
		{
			this.sprite = sprite;
			if (sprite)
			{
				addChild(sprite);
				SetCollisionRadius(sprite.width / 2);
			}
			
			this.x = startX;
			this.y = startY;
			
			
			
		}
		
		override public function Update():void 
		{
			super.Update();
			
			
		}
		
	}

}