package battleengine.objects 
{
	import battleengine.BattleScreen;
	import battleengine.objects.units.Unit;
	import battleengine.Profiler;
	import com.rnk.math.Amath;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class GameObjectManager 
	{
		public var screen:DisplayObjectContainer;
		public var papa:BattleScreen;
		public var space:SpatialSpace;
		public var collisionSystem:CollisionSystem;
		private var objects:Vector.<GameObject>;
		
		public var monstersCount:int = 0;
		public var killedMonsters:int = 0;
		public var onMonsterKill:Function;
		public var pendingObjects:int = 0;
		
		public function GameObjectManager() 
		{
			
		}
		
		public function Init(papa:Game,screen:DisplayObjectContainer):void
		{
			this.papa = papa;
			this.screen = screen;
			
			objects = new Vector.<GameObject>();
			space = new SpatialSpace();
			space.Init();
			
			collisionSystem = new CollisionSystem();
			collisionSystem.Init(this);
			
		}
		
		public function Die():void
		{
			collisionSystem.Die();
			space.Die();
			for each (var item:GameObject in objects) 
			{
				item.Die();
			}
			
		}
		
		public function Update():void
		{
			//Profiler.instance.StartTask("objects update");
			//update
			for (var i:int = 0; i < objects.length; i++) 
			{
				objects[i].Update();
				
				//check if out of bounds, flag for remove if yes
				
			}
			//Profiler.instance.EndTask("objects update");
			
			
			
			//kills
			//Profiler.instance.StartTask("objects kill");
			for (i = objects.length-1; i >=0; i--) 
			{
				var item:GameObject = objects[i];
				if (item.kill)
				{
					_RemoveObject(item, i);
					item.kill = false;
					
				}
			}
			//Profiler.instance.EndTask("objects kill");
			
			//Profiler.instance.StartTask("spatial space update");
			//spatial space
			space.Update();
			//Profiler.instance.EndTask("spatial space update");
			
			
			//Profiler.instance.StartTask("collision update");
			//collisions
			collisionSystem.Update();
			//Profiler.instance.EndTask("collision update");
			
		}
		
		public function AddObject(obj:GameObject):void
		{
			if (obj is Unit) monstersCount++;
			
			pendingObjects += obj.pendingValue;
			
			screen.addChild(obj);
			objects.push(obj);
			obj.Init(this);
			space.RegisterObject(obj);
		}
		
		private function _RemoveObject(obj:GameObject,idx:int):void
		{
			if (obj is Unit) 
			{
				monstersCount--;
				
				if ((obj as Unit).killByPlayer)
				{
					killedMonsters++;
					if (Boolean(onMonsterKill))
						onMonsterKill(obj);
				}
			}
			
			pendingObjects -= obj.pendingValue;
			
			obj.Die();
			screen.removeChild(obj);
			objects.splice(idx,1);
			space.UnRegisterObject(obj);
		}
		
		public function RemoveObject(obj:GameObject):void
		{
			var idx:int = objects.indexOf(obj);
			_RemoveObject(obj,idx);
		}
		
		public function GetRandomMonsters(howmany:int, filterArray:Array = null):Array
		{
			var monsters:Array = [];
			for each (var item:GameObject in objects) 
			{
				if (filterArray)
				{
					if (item is Unit && filterArray.indexOf(item) < 0)
						monsters.push(item);
				} else
				if (item is Unit)
					monsters.push(item);
			}
			
			howmany = Math.min(monsters.length, howmany);
			var picked:Array = [];
			
			for (var i:int = 0; i < howmany; i++) 
			{
				var rdx:int = Amath.random(0, monsters.length-1);
				picked.push(monsters[rdx]);
				monsters.splice(rdx,1);
			}
			
			return picked;
		}
		
		public function GetObjectsInRadius(x:Number, y:Number, r:Number):Array
		{
			var result:Array = [];
			
			for each (var item:GameObject in objects) 
			{
				if (Math.abs(item.x - x) > r || Math.abs(item.y - y) > r) continue;
				
				var dist:Number = Amath.distance(item.x, item.y, x, y);
				if (dist > r + item.collisionInfo.r) continue;
				
				result.push(item);
			}
			
			return result;
		}
		
		public function CreateMonster(monsterClass:Class,x:Number,y:Number):Unit 
		{
			var monster:Unit = new monsterClass(x, y);
			this.AddObject(monster);
			return monster;
		}

	}

}