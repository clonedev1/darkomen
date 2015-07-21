package world 
{
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 
	 */
	public class Profiler 
	{
		public static var instance:Profiler;
		
		public var tasks:Object = { };
		
		public function Profiler() 
		{
			instance = this;
		}
		
		public function StartTask(taskName:String):void
		{
			
			if (!tasks[taskName]) 
			{
				tasks[taskName] = { name:taskName,start:getTimer(),time:"n/a"};
			}
			else
			{
				tasks[taskName].start = getTimer();
				//tasks[taskName].time = "n/a";
			}
		}
		
		public function EndTask(taskName:String):void
		{
			if (tasks[taskName])
			{
				tasks[taskName].end = getTimer();
				tasks[taskName].time = tasks[taskName].end - tasks[taskName].start;
			}
		}
		
	}

}