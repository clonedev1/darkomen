package battleengine.objects 
{
	import com.rnk.math.Amath;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class CollisionSystem 
	{
		public var space:SpatialSpace;
		public var papa:GameObjectManager;
		private var cachedResults:Dictionary;
		private var cachedPairs:Dictionary;
		
		
		public function CollisionSystem() 
		{
			cachedResults = new Dictionary(true);
			cachedPairs = new Dictionary(true);
		}
		
		public function Init(papa:GameObjectManager):void
		{
			this.papa = papa;
			space = papa.space;
		}
		
		public function Die():void 
		{
			
		}
		
		public function Update():void
		{
			cachedResults = new Dictionary(true);
			cachedPairs = new Dictionary(true);
			
		}
		
		public function CheckCollisions(obj:GameObject):Array
		{
			//check cache
			if (cachedResults[obj])
				return cachedResults[obj];
			
			//check against neighbours
			var result:Array = [];
			var neighbours:Array = space.GetNeighbours(obj);
			for each (var neighbour:GameObject in neighbours) 
			{
				if (CheckPair(obj, neighbour))
					result.push(neighbour);
			}
			
			//cache results
			cachedResults[obj] = result;
			
			return result;
		}
		
		
		
		private function CheckPair(obj1:GameObject,obj2:GameObject):Boolean
		{
			//check cache
			if (cachedPairs[obj1] && cachedPairs[obj1][obj2])
			{
				return cachedPairs[obj1][obj2];
			}
			if (cachedPairs[obj2] && cachedPairs[obj2][obj1])
			{
				return cachedPairs[obj2][obj1];
			}
			
			//check stage 1
			var obj1r:Number = obj1.collisionInfo.r;
			var obj2r:Number = obj2.collisionInfo.r;
			if (Math.abs(obj1.x - obj2.x) > obj1r + obj2r || Math.abs(obj1.y - obj2.y) > obj1r + obj2r)
			{
				//update cache
				return CachedResult(false);
			}
			
			//check stage 2
			var dist:Number = Amath.distance(obj1.x, obj1.y, obj2.x, obj2.y);
			if (dist > obj1r + obj2r) 
			{
				//update cache
				return CachedResult(false);
			}
			
			
			//update cache
			return CachedResult(true);
			
			function CachedResult(result:Boolean):Boolean
			{
				if (!cachedPairs[obj1])
					cachedPairs[obj1] = new Dictionary(true);
				cachedPairs[obj1][obj2] = result;
					
				if (!cachedPairs[obj2])
					cachedPairs[obj2] = new Dictionary(true);
				cachedPairs[obj2][obj1] = result;
				
				return result;
			}
		}
		
	}

}