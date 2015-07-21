package achievementsystem 
{
	import data.Player;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author me
	 */
	public class AchievementSystem extends Sprite
	{
		private var visualisator:AchievementVisualisator;
		
		public static var instance:AchievementSystem;
		public var achievements:Object = { };
		
		public function AchievementSystem() 
		{
			instance = this;
			Achievements.Init();
			Player.LoadAchievements();
			
			visualisator = new AchievementVisualisator(this);
		}
		
		public function AddAchievement(achiName:String,count:int=1):void
		{
			achievements[achiName] = { current:0, max:count };
		}
		
		public function Achieve(achiName:String,count:int=1):void
		{
			if (!achievements[achiName] || achievements[achiName].completed) return;
			
			achievements[achiName].current += count;
			
			if (achievements[achiName].current >= achievements[achiName].max)
			{
				//do something
				achievements[achiName].completed = true;
				visualisator.ShowAcvhievement(achiName);
			}
			
			
		}
		
		public function ClearAchievements():void
		{
			for each (var item:Object in achievements) 
			{
				item.completed = false;
				item.current = 0;
			}
		}
		
	}

}