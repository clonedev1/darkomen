package battleengine.effects 
{
	import com.rnk.animation.Animation;
	import com.rnk.math.Amath;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class Lightning extends Sprite
	{
		private var delay:int = 0;
		
		public function Lightning(x1:Number,y1:Number,x2:Number,y2:Number,delay:int=1) 
		{
			var light:MovieClip = new test_ray();
			
			var dist:Number = Amath.distance(x1, y1, x2, y2);
			var angle:Number = Amath.getAngleDeg(x1, y1, x2, y2);
			
			light.width = dist;
			light.x = x1;
			light.y = y1;
			light.rotation = angle;
			
			x = 0;
			y = 0;
			
			addChild(light);
			
			addEventListener(Event.REMOVED_FROM_STAGE, OnAnimationFinish);
			
			{
				this.delay = Math.max(1,delay);
				addEventListener(Event.ENTER_FRAME, OnEnterFrame);
			}
			
		}
		
		private function OnEnterFrame(e:Event):void 
		{
			delay--;
			if (delay < 0)
			{
				removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
				OnAnimationFinish();
			}
		}
		
		private function OnAnimationFinish(e:Event=null):void 
		{
			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
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