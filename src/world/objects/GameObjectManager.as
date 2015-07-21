package world.objects 
{
	import com.rnk.math.Amath;
	import flash.display.DisplayObjectContainer;
	import world.Game;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class GameObjectManager 
	{
		public var screen:DisplayObjectContainer;
		public var papa:Game;
		public var space:SpatialSpace;
		public var collisionSystem:CollisionSystem;
		public var objects:Vector.<GameObject>;
		
		
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
			
			//depth sorting
			LameDepthSortingAlgorythm(objects);
			
		}
		
		public function AddObject(obj:GameObject):GameObject
		{
			
			screen.addChild(obj);
			objects.push(obj);
			obj.Init(this);
			space.RegisterObject(obj);
			return obj;
		}
		
		private function _RemoveObject(obj:GameObject,idx:int):void
		{
			
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
		
		private function LameDepthSortingAlgorythm(gameObjects:Vector.<GameObject>):void 
		{
			//TODO отфильтровать невидимы объекты
			var listOfVisibleObjects:Vector.<GameObject> = gameObjects.slice(0, gameObjects.length);
			
			//sort by Y
			listOfVisibleObjects.sort(SortByY);
			function SortByY(a:GameObject, b:GameObject):Number
			{
				if (a.y == b.y)
				{
					if (a.uid > b.uid)
						return -1;
					else
						return 1;
						
					return 0;
				}
				
				if (a.y > b.y)
					return 1;
				else
					return -1;
			}
			
			//сортировать
			for (var i:int = 0; i < listOfVisibleObjects.length; i++)
			{
				screen.addChild(listOfVisibleObjects[i]);
			}
		}
		


	}

}