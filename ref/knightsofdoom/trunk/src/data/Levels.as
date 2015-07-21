package data 
{
	
	/**
	 * ...
	 * @author me
	 */
	public class Levels 
	{
		
		public static function LoadFromConfig():void
		{
			/*LIST = [];
			for (var i:int = 0; i < Config.xml.levels.level.length(); i++) 
			{
				var monsterList:Object = { };
				for (var j:int = 0; j < Config.xml.levels.level[i].monsters.monster.length(); j++) 
				{
					monsterList[String(Config.xml.levels.level[i].monsters.monster[j].@id)] = int(Config.xml.levels.level[i].monsters.monster[j].@count);
				}
				
				var goals:Array = String(Config.xml.levels.level[i].@goals).split(",");
				for (var k:int = 0; k < goals.length; k++) 
				{
					goals[k] = int(goals[k]);
				}
				
				
				LIST.push( { monsterList:monsterList, goals:goals } );*/
			}
		}
		
		public static var LIST:Array = [];
		
	}

}