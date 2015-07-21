package com.rnk.screenshaker
{
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class ScreenShaker
	{
		private static var image			: DisplayObject;
		private static var originalX		: int;
		private static var originalY		: int;
		static private var seconds:Number;
		static private var count:int;
		static private var radius:Number;
		static private var _count:int;
		
		
		public function ScreenShaker()
		{
			// static class - do not instantiate
		}
		
		// === A P I ===
		public static function go( image:DisplayObject, radius:Number = 10, seconds:Number = 1, count:int = 3 ): void
		{
			cleanup();
			
			ScreenShaker.radius = radius;
			ScreenShaker.count = count;
			ScreenShaker._count = count;
			ScreenShaker.seconds = seconds;
			
			ScreenShaker.image = image;
			originalX = image.x;
			originalY = image.y;
			
			shake();
		}
		
		// === ===
		private static function shake( ): void
		{
			_count--;
			
			var angle:Number = Math.random() * Math.PI * 2;
			radius = radius / 1.2;
			
			var newX:int = originalX + Math.cos(angle)*radius;
			var newY:int = originalY + Math.sin(angle)*radius;
			
			if (_count <= 0)
				TweenLite.to(image, seconds / count, { x:originalX, y:originalY, onComplete:resetImage ,ease:Sine.easeOut} );
			else
				TweenLite.to(image, seconds / count, { x:newX, y:newY, onComplete:shake,ease:Sine.easeOut } );
		}
		
		private static function resetImage(): void
		{
			cleanup();
		}
		
		public static function cleanup(): void
		{
			if (image)
			{
				image.x = originalX;
				image.y = originalY;
			}
			
			TweenLite.killTweensOf(image);
			image = null;
		}
		

	}
}