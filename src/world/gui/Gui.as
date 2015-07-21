package world.gui 
{
	import com.rnk.gui.MovieClipSwitchButton;
	import data.Player;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import popups.windows.Popups;
	import soundmanager.SoundManager;
	import world.Game;
	/**
	 * ...
	 * @author me
	 */
	public class Gui extends Sprite
	{
		private var bg:MovieClip;
		public var papa:Game;
		
		public function Gui() 
		{
			//bg = new ingame_gui();
			//addChild(bg);
			
		}
		
		public function Init():void
		{
			
			SetListeners(true);
		}
		
		public function Die():void
		{
			SetListeners(false);
		}
		
		private function SetListeners(orly:Boolean):void
		{
			var buttons:Array = [];
			for (var i:int = 0; i < buttons.length; i++) 
			{
				buttons[i].useHandCursor = buttons[i].buttonMode = orly;
				(orly?buttons[i].addEventListener:buttons[i].removeEventListener)(MouseEvent.CLICK, OnButtonClick);
			}
			
			
		}
		
		private function OnButtonClick(e:MouseEvent):void 
		{
			switch (e.target) 
			{
				/*case bg.restartButton:
					papa.Restart();
				break;*/
			}
		}
		
		public function Update():void
		{
			
		}
		
		
	}

}