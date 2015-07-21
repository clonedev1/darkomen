package
{
	import achievementsystem.AchievementSystem;
	import com.rnk.profiler.SWFProfiler;
	import com.rnk.screenmanager.ScreenManager;
	import data.Player;
	import flash.display.Sprite;
	import flash.events.Event;
	import popups.PopupManager;
	import soundmanager.SoundManager;
	import soundmanager.Sounds;
	
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class Main extends Sprite
	{
		
		public static var instance:Main;
		public static const SCREEN_WIDTH:int = 800;
		public static const SCREEN_HEIGHT:int = 600;
		private var achievementsSystem:AchievementSystem
		public var screenManager:ScreenManager;
		public var popupsManager:PopupManager;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
			
			instance = this;
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//profiler
			SWFProfiler.init(stage, this);
			
			//load config
			var config:Config = new Config();
			//temp
			config.addEventListener(
				Event.COMPLETE, 
				function(e:Event):void 
				{
					//cache anims
					Assets.CacheAnimations();
					
					//sound
					SoundManager.init();
					
					//game screen
					screenManager = new ScreenManager();
					addChild(screenManager);
					
					//popups
					opupsManager = new PopupManager();
					addChild(popupsManager);
					
					//sounds update
					addEventListener(Event.ENTER_FRAME, Update);
					
					//load saved profile
					Player.Load();
					
					//achievemnts
					achievementsSystem = new AchievementSystem();
					addChild(achievementsSystem);
					
					//SoundManager.PlayMusic(Sounds.MUSIC_MENU);
					
					//start game
					screenManager.ShowScreen(Screens.MENU);
				
				}
			);
			
		}
		
		private function Update(e:Event):void
		{
			SoundManager.playPendingBoomSounds();
			
		}
	
	}

}