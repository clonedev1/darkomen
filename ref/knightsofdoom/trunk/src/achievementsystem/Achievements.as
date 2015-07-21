package achievementsystem 
{
	/**
	 * ...
	 * @author me
	 */
	public class Achievements 
	{
		
		public static const KILLED_MONSTER:String = "KILLED_MONSTER";
		public static const KILLED_3_MONSTER:String = "KILLED_3_MONSTER";
		public static const KILLED_10_MONSTER:String = "KILLED_10_MONSTER";
		public static const KILLED_20_MONSTER:String = "KILLED_20_MONSTER";
		public static const KILLED_30_MONSTER:String = "KILLED_30_MONSTER";
		public static const KILLED_40_MONSTER:String = "KILLED_40_MONSTER";
		public static const KILLED_50_MONSTER:String = "KILLED_50_MONSTER";
		
		
		public static function Init():void
		{
			AchievementSystem.instance.AddAchievement(KILLED_MONSTER, 1);
			AchievementSystem.instance.AddAchievement(KILLED_3_MONSTER, 3);
			AchievementSystem.instance.AddAchievement(KILLED_10_MONSTER, 10);
			AchievementSystem.instance.AddAchievement(KILLED_20_MONSTER, 20);
			AchievementSystem.instance.AddAchievement(KILLED_30_MONSTER, 30);
			AchievementSystem.instance.AddAchievement(KILLED_40_MONSTER, 40);
			AchievementSystem.instance.AddAchievement(KILLED_50_MONSTER, 50);
		}
		
	}

}