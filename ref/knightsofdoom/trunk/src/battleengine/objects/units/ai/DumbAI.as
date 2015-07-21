package battleengine.objects.units.ai 
{
	/**
	 * ...
	 * @author me
	 */
	public class DumbAI extends AI
	{
		
		
		public function DumbAI(angle:Number,speed:Number) 
		{
			velocity.x = Math.cos(angle) * speed;
			velocity.y = Math.sin(angle) * speed;
		}
		
		override public function Update():void 
		{
			
		}
		
	}

}