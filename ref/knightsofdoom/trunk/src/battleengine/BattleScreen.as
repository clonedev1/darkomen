package battleengine 
{
	import achievementsystem.Achievements;
	import achievementsystem.AchievementSystem;
	import battleengine.gui.DebugSpatialSpace;
	import battleengine.gui.Gui;
	import battleengine.objects.GameObjectManager;
	import battleengine.objects.units.*;
	import com.pixelwelders.fx.Earthquake;
	import com.rnk.screenmanager.Screen;
	import data.Levels;
	import data.Player;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import popups.windows.Popups;
	import soundmanager.SoundManager;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class BattleScreen extends Screen
	{
		public var objectManager:GameObjectManager;
		private var objectsLayer:Sprite;
		private var gui:Gui;
		private var bg:MovieClip;
		
		//debug
		public static const DEBUG_DRAW_SPATIAL:Boolean = false;
		public var debugSpace:DebugSpatialSpace;
		
		
		private var _paused:Boolean = false;
		
		
		public function BattleScreen() 
		{
			
		}
		
		override public function Init():void 
		{
			//profiler
			//new Profiler();
			
			
			//display layers:
			//background layer
			if (!DEBUG_DRAW_SPATIAL)
			{
				bg = new game_bg();
				addChild(bg);
			}
			
			//objects layer
			objectsLayer = new Sprite();
			addChild(objectsLayer);
			objectsLayer.mouseChildren = false;
			objectsLayer.mouseEnabled = false;
			
			//gui layer
			gui = new Gui();
			addChild(gui);
			gui.papa = this;
			gui.Init();
			
			//objectmanager
			objectManager = new GameObjectManager();
			objectManager.Init(this, objectsLayer);
			objectManager.onMonsterKill = OnMonsterKill;
			
			//debug
			if (DEBUG_DRAW_SPATIAL)
			{
				debugSpace = new DebugSpatialSpace(objectManager.space);
				addChild(debugSpace);
			}
			
			//create level
			CreateLevel();
		}
		
		public function Restart():void 
		{
			paused = false;
			screenManager.ShowScreen(Screens.GAME);
		}
		
		private function CreateLevel():void 
		{
			//получить список монстер:колво
			var monsterList:Object = levelInfo.monsterList;
			
			
			//сгенерировать в рандомных местах экрана
			for (var name:String in monsterList) 
			{
				var count:int = monsterList[name];
				for (var i:int = 0; i < count; i++) 
				{
					var x:Number = Main.SCREEN_WIDTH * Math.random();
					var y:Number = Main.SCREEN_HEIGHT* Math.random();
					objectManager.CreateMonster(MonsterTypes.classes[name], x, y);
				}
			}
			
		}
		
		override public function Die():void 
		{
			gui.Die();
			objectManager.Die();
			SoundManager.stopMissionSounds();
			
		}
		
		override public function Update(e:Event = null):void 
		{
			//Profiler.instance.StartTask("FRAME TOTAL");
			
			if (paused) 
			{
				//Profiler.instance.EndTask("FRAME TOTAL");
				return;
			}
			
			//Profiler.instance.StartTask("objectManager.Update");
			//make all objects move
			objectManager.Update();
			//Profiler.instance.EndTask("objectManager.Update");
			
			//Profiler.instance.StartTask("gui.Update");
			//update gui info
			gui.Update();
			//Profiler.instance.EndTask("gui.Update");
			
			//debug
			if (DEBUG_DRAW_SPATIAL)
			{
				debugSpace.Update();
			}
			
			//Profiler.instance.EndTask("FRAME TOTAL");
		}
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		public function set paused(value:Boolean):void 
		{
			_paused = value;
			
			mouseCursor.Enabled(!value);
		}
		
		
	}

}