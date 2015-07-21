package achievementsystem 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	/**
	 * ...
	 * @author me
	 */
	public class AchievementVisualisator 
	{
		private var bg:DisplayObjectContainer;
		private var queue:Array = [];
		private var currentAchievement:Sprite;
		
		public function AchievementVisualisator(bg:DisplayObjectContainer) 
		{
			this.bg = bg;
			
		}
		
		public function ShowAcvhievement(achiName:String):void
		{
			queue.push(achiName);
			NextAchievement();
			
		}
		
		private function NextAchievement():void 
		{
			
			if (currentAchievement || queue.length==0)
			{
				return;
			}
			
			var achiName:String = queue.shift();
			
			currentAchievement = new Sprite();
			var txt:TextField = new TextField();
			txt.text = achiName;
			txt.textColor = 0xFFFFFF;
			currentAchievement.addChild(txt);
			bg.addChild(currentAchievement);
			currentAchievement.x = Main.SCREEN_WIDTH - (txt.textWidth + 50);
			currentAchievement.y = Main.SCREEN_HEIGHT - (txt.textHeight + 50)
			currentAchievement.alpha = 1.0;
			currentAchievement.filters = [new GlowFilter(0xFF0000)];
			TweenLite.from(currentAchievement, 0.5, { alpha:0.0, y:Main.SCREEN_HEIGHT, onComplete:OnAppear } );
			
			function OnAppear():void
			{
				TweenLite.to(currentAchievement, 0.5, { alpha:0.0, y:Main.SCREEN_HEIGHT, delay:1, onComplete:OnDisappear } );
			}
			
			function OnDisappear():void
			{
				bg.removeChild(currentAchievement);
				currentAchievement = null;
				NextAchievement();
			}
		}
		
	}

}