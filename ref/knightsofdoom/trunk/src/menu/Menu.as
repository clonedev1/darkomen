package menu 
{
	import com.rnk.screenmanager.Screen;
	import data.Player;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author me
	 */
	public class Menu extends Screen
	{
		private var bg:MovieClip;
		
		public function Menu() 
		{
			bg = addChild(new menu_bg()) as MovieClip;
			
		}
		
		override public function Init():void 
		{
			SetListeners(true);
			
		}
		
		override public function Die():void 
		{
			SetListeners(false);
		}
		
		private function OnButtonClick(e:MouseEvent):void 
		{
			switch (e.target) 
			{
				case bg.newgame_button:
					
					Player.New();
					screenManager.ShowScreen(Screens.UPGRADE);
					
				break;
				case bg.continue_button:
					//screenManager.ShowScreen(Screens.GAME, [1]);
					screenManager.ShowScreen(Screens.UPGRADE);
				break;
				case bg.moregames_button:
					
				break;
				case bg.credits_button:
					
				break;
			}
		}
		
		private function SetListeners(orly:Boolean):void 
		{
			var buttons:Array = [bg.newgame_button, bg.continue_button, bg.moregames_button, bg.credits_button];
			for (var i:int = 0; i < buttons.length; i++) 
			{
				if (orly)
					buttons[i].addEventListener(MouseEvent.CLICK, OnButtonClick);
				else
					buttons[i].removeEventListener(MouseEvent.CLICK, OnButtonClick);
			}
		}
		
		
		
	}

}