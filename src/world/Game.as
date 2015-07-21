package world 
{
	import achievementsystem.Achievements;
	import achievementsystem.AchievementSystem;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import com.pixelwelders.fx.Earthquake;
	import com.rnk.screenmanager.Screen;
	import com.rnk.screenshaker.ScreenShaker;
	import data.Player;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import popups.windows.Popups;
	import soundmanager.SoundManager;
	import world.gui.DebugSpatialSpace;
	import world.gui.Gui;
	import world.objects.actors.Soldier;
	import world.objects.actors.Squad;
	import world.objects.GameObjectManager;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class Game extends Screen
	{
		public var objectManager:GameObjectManager;
		private var objectsLayer:Sprite;
		private var gui:Gui;
		private var bg:MovieClip;
		private var _paused:Boolean = false;
		
		//debug
		public static const DEBUG_DRAW_SPATIAL:Boolean = false;
		public var debugSpace:DebugSpatialSpace;
		
		//bounds
		public var scale:Number = 1.0;
		public var WIDTH:Number = 0;
		public var HEIGHT:Number = 0;
		
		
		public function Game() 
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
			
			//get scale from level data
			//scale = 1.0;
			WIDTH = Main.SCREEN_WIDTH;// / scale;
			HEIGHT = Main.SCREEN_HEIGHT;// / scale;
			
			//objects layer
			objectsLayer = new Sprite();
			addChild(objectsLayer);
			objectsLayer.mouseChildren = false;
			objectsLayer.mouseEnabled = false;
			//objectsLayer.scaleX = objectsLayer.scaleY = scale;
			
			//gui layer
			gui = new Gui();
			addChild(gui);
			gui.papa = this;
			gui.Init();
			
			//objectmanager
			objectManager = new GameObjectManager();
			objectManager.Init(this, objectsLayer);
			
			//debug
			if (DEBUG_DRAW_SPATIAL)
			{
				debugSpace = new DebugSpatialSpace(objectManager.space);
				addChild(debugSpace);
			}
			
			paused = false;
			
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
			/*for (var i:int = 0; i < 100; i++) 
			{
				var zoldaten:Soldier = new Soldier(700 * Math.random(), 600 * Math.random());
				objectManager.AddObject(zoldaten);
			}*/
			
			var squad:Squad = new Squad(300, 300);
			objectManager.AddObject(squad);
			squad.soldiers.push(objectManager.AddObject(new Soldier(300, 300)));
			squad.soldiers.push(objectManager.AddObject(new Soldier(300, 300)));
			squad.soldiers.push(objectManager.AddObject(new Soldier(300, 300)));
			squad.soldiers.push(objectManager.AddObject(new Soldier(300, 300)));
			squad.soldiers.push(objectManager.AddObject(new Soldier(300, 300)));
			squad.soldiers.push(objectManager.AddObject(new Soldier(300, 300)));
			
			squad.AssembleSoldiers();
			
		}
		
		override public function Die():void 
		{
			gui.Die();
			objectManager.Die();
			SoundManager.stopMissionSounds();
			ScreenShaker.cleanup();
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
		
		public function ShakeIt(radius:Number = 25, seconds:Number = 0.3, count:int = 5):void 
		{
			ScreenShaker.go(objectsLayer, radius, seconds,count);
		}
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		public function set paused(value:Boolean):void 
		{
			_paused = value;
			
		}
		
		
	}

}