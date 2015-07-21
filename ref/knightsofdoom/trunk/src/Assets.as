package  
{
	import com.rnk.animation.Animation;
	import com.rnk.animation.AnimationLibrary;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author me
	 */
	public class Assets 
	{
		
		
		static public const ANIM_BULLET:String="BULLET";
		static public const ANIM_EXPLOSION1:String="EXPLOSION1";
		static public const ANIM_EXPLOSION2:String="EXPLOSION2";
		static public const ANIM_EXPLOSION3:String = "EXPLOSION3";
		
		private static var ANIMATIONS:Object={};
		
		public static function CacheAnimations():void
		{
			var time:int = getTimer();
			
			ANIMATIONS[ANIM_EXPLOSION1] = new Animation(explosion1,1.0, 24);
			ANIMATIONS[ANIM_EXPLOSION2] = new Animation(explosion2, 1.0, 24);
			ANIMATIONS[ANIM_EXPLOSION3] = new Animation(explosion3, 1.0, 24);
			ANIMATIONS[ANIM_BULLET] = new Animation(bullet_mc);
			
			trace("caching animations took",(getTimer()-time)/1000,"s");
		}
		
		public static function GetAnimation(name:String):Animation
		{
			return ANIMATIONS[name].clone();
		}
		
	}

}