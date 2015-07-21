package  
{
	import com.rnk.animation.Animation;
	import com.rnk.animation.AnimationHolder;
	import com.rnk.animation.AnimationLibrary;
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author me
	 */
	public class Assets 
	{
		
		//anims here
		static public const SOLDIER:String = "SOLDIER";
		static public const ORC:String = "ORC";
		
		//donttocuh
		private static var ANIMATIONS:Object={};
		
		public static function CacheAnimations():void
		{
			var time:int = getTimer();
			
			var animHolder:AnimationHolder = new AnimationHolder();
			ANIMATIONS[SOLDIER] = animHolder;
			animHolder.AddAnimation("stand", new Animation(landsknecht_standing,1.0,10));
			animHolder.AddAnimation("run", new Animation(landskneht_moving,1.0,10));
			//animHolder.AddAnimation("fight", new Animation(soldier_fighting_animation,1.0,16));
			//animHolder.AddAnimation("die", new Animation(soldier_die_animation,1.0,16));
			
			//ANIMATIONS[ORC] = new Animation(orc_animation);
			
			
			trace("caching animations took",(getTimer()-time)/1000,"s");
		}
		
		public static function GetAnimation(name:String):DisplayObject
		{
			return ANIMATIONS[name].clone();
		}
		
	}

}