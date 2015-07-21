package world.objects 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class GameObject extends Sprite
	{
		public var papa:GameObjectManager;
		public var kill:Boolean = false;
		public var collisionInfo:ObjectCollisionInfo = new ObjectCollisionInfo();
		public static var next_uid:int = 0;
		public var uid:int = 0;
		
		public function GameObject() 
		{
			uid = next_uid++;
		}
		
		public function Init(objectManager:GameObjectManager):void
		{ 
			this.papa = objectManager;
		}
		
		public function Die():void
		{
			
		}
		
		public function Update():void
		{
			
		}
		
		public function GetCollidedObjects():Array
		{
			return papa.collisionSystem.CheckCollisions(this);
		}
		
		public function SetCollisionRadius(r:Number):void
		{
			collisionInfo.r = r;
		}
	}

}