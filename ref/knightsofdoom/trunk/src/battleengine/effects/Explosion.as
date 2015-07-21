package battleengine.effects 
{
	import com.rnk.animation.Animation;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class Explosion extends Sprite
	{
		private var anime:Animation;
		private var delay:int = 0;
		
		public function Explosion(anime:Animation,delay:int=0) 
		{
			this.anime = anime;
			addChild(anime);
			anime.addEventListener(Animation.FINISH, OnAnimationFinish);
			addEventListener(Event.REMOVED_FROM_STAGE, OnAnimationFinish);
			
			if (delay > 0)
			{
				this.delay = delay;
				addEventListener(Event.ENTER_FRAME, OnEnterFrame);
				anime.visible = false;
			}
			else
			anime.play(false);
		}
		
		private function OnEnterFrame(e:Event):void 
		{
			delay--;
			if (delay < 0)
			{
				removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
				anime.visible = true;
				anime.play(false);
			}
		}
		
		private function OnAnimationFinish(e:Event):void 
		{
			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			anime.removeEventListener(Animation.FINISH, OnAnimationFinish);
			removeEventListener(Event.REMOVED_FROM_STAGE, OnAnimationFinish);
			Die();
		}
		
		public function Die():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
	}

}