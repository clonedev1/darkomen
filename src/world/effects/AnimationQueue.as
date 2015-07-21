package world.effects 
{
	import com.rnk.animation.Animation;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class AnimationQueue extends Sprite
	{
		private var anims:Array;
		private var loopCounts:Array;
		private var currentAnimIndex:int = 0;
		private var currentLoopCount:int = 0;
		private var anime:Animation;
		
		public function AnimationQueue(anims:Array,loopCounts:Array=null) 
		{
			this.loopCounts = loopCounts;
			this.anims = anims;
			
			addEventListener(Event.REMOVED_FROM_STAGE, RemovedFromStage);
			
			StartAnimation();
			
		}
		
		private function RemovedFromStage(e:Event=null):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, RemovedFromStage);
			if (anime)
				anime.removeEventListener(Animation.FINISH, OnAnimationFinish);
			Die();
		}
		
		private function OnAnimationFinish(e:Event):void 
		{
			if (loopCounts)
			{
				currentLoopCount++;
				if (currentLoopCount < loopCounts[currentAnimIndex])
				{
					StartAnimation();
					return;
				}
			}
			anime.removeEventListener(Animation.FINISH, OnAnimationFinish);
			currentAnimIndex++;
			if (currentAnimIndex < anims.length)
			{
				currentLoopCount = 0;
				StartAnimation();
				return;
			}
			
			RemovedFromStage();
		}
		
		private function StartAnimation():void 
		{
			var addChildFlag:Boolean = false;
			if (anime && anime != anims[currentAnimIndex])
			{
				while (numChildren) removeChildAt(0);
				addChildFlag = true;
			}
			
			if (!anime)
				addChildFlag = true;
			
			anime = anims[currentAnimIndex];
			if (addChildFlag)
			{
				addChild(anime);
				
			}
			if (currentLoopCount==0)
				anime.addEventListener(Animation.FINISH, OnAnimationFinish);
			
			anime.play(false);
		}
		
		public function Die():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
	}

}