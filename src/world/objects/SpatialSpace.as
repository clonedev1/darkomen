package world.objects 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class SpatialSpace 
	{
		public var sectorsObjects:Object = { };
		public var objectsSectors:Dictionary = new Dictionary(true);
		public var objects:Array = [];
		
		public static const SECTOR_WIDTH:Number = 128;
		public static const SECTOR_HEIGHT:Number = 128;
		
		public function SpatialSpace() 
		{
			
		}
		
		public function Init():void
		{
			objects = [];
			sectorsObjects = { };
			objectsSectors = new Dictionary(true);
		}
		
		public function Die():void
		{
			objects = [];
			sectorsObjects = { };
			objectsSectors = new Dictionary(true);
		}
		
		public function RegisterObject(obj:GameObject):void
		{
			objects.push(obj);
			CalcSectors(obj);
		}
		
		public function UnRegisterObject(obj:GameObject):void
		{
			var objectSectors:Array = objectsSectors[obj];
			for (var i:int = 0; i < objectSectors.length; i++) 
			{
				var sectorObjects:Array = sectorsObjects[objectSectors[i]] as Array;
				if (sectorObjects)
				{
					sectorObjects.splice(sectorObjects.indexOf(obj),1);
				}
			}
			objectsSectors[obj] = null;
			objects.splice(objects.indexOf(obj),1);
		}
		
		public function Update():void
		{
			sectorsObjects = { };
			objectsSectors = new Dictionary(true);
			
			for each (var obj:GameObject in objects) 
			{
				CalcSectors(obj);
			}
		}
		
		public function GetObjectsFromSectors(sectorNames:Array,excludeObject:GameObject = null):Array
		{
			var result:Array = [];
			
			var objFlags:Dictionary = new Dictionary(true);
			
				for each (var secName:String in sectorNames) 
				{
					var objInSector:Array = sectorsObjects[secName] as Array;
					if (objInSector)
					{
						for each (var objTemp:GameObject in objInSector) 
						{
							if (objFlags[objTemp] || (excludeObject && excludeObject == objTemp)) continue;
							result.push(objTemp);
							objFlags[objTemp] = true;
						}
						
					}
				}
			
			return result;
		}
		
		public function GetNeighbours(obj:GameObject):Array
		{
			var result:Array = [];
			
			if (!objectsSectors[obj]) return null;
			
			var sectorNames:Array = objectsSectors[obj] as Array;
			if (sectorNames)
			{
				result = GetObjectsFromSectors(sectorNames,obj);
			}
			
			return result;
		}
		
		private function CalcSectors(obj:GameObject):void
		{
			
			var r:Number = obj.collisionInfo.r;
			var x:Number = obj.x;
			var y:Number = obj.y;
			
			var x1:Number = x - r;
			var x2:Number = x + r;
			var y1:Number = y - r;
			var y2:Number = y + r;
			
			var sx1:int = Math.floor(x1 / SECTOR_WIDTH);
			var sx2:int = Math.floor(x2 / SECTOR_WIDTH);
			var sy1:int = Math.floor(y1 / SECTOR_HEIGHT);
			var sy2:int = Math.floor(y2 / SECTOR_HEIGHT);
			
			for (var sx:int = sx1; sx <= sx2; sx++) 
			{
				for (var sy:int = sy1; sy <= sy2; sy++) 
				{
					var secName:String = String(sx) + "_" + String(sy);
					if (!sectorsObjects[secName])
						sectorsObjects[secName] = [];
					sectorsObjects[secName].push(obj);
					
					if (!objectsSectors[obj])
						objectsSectors[obj] = [];
						
					objectsSectors[obj].push(secName);
				}
			}
		}
		
		
	}

}