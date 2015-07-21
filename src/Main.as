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
		private var achievementsSystem:AchievementSystem
		public static var instance:Main;
		public static const SCREEN_WIDTH:int = 700;
		public static const SCREEN_HEIGHT:int = 600;
		
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
			config.addEventListener(Event.COMPLETE, 
				function(e:Event):void 
				{
					//cache anims
					Assets.CacheAnimations();
					
					//sound
					SoundManager.init();
					
					//game screen
					screenManager = new ScreenManager();
					addChild(screenManager);
					
					//popa screen
					popupsManager = new PopupManager();
					addChild(popupsManager);
					
					//start game
					screenManager.ShowScreen(Screens.GAME);
					//screenManager.ShowScreen(Screens.TEST);
					
					//sounds update
					addEventListener(Event.ENTER_FRAME, Update);
					
					//achievemnts
					achievementsSystem = new AchievementSystem();
					addChild(achievementsSystem);
					
					//its fucking stupid
					trace("yah its really stupid isnt it");
					
					
					
				}
			);
			
		}
		
		private function Update(e:Event):void
		{
			SoundManager.playPendingBoomSounds();
			
		}
	
	}

}