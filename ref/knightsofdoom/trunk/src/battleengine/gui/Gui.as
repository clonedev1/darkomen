package battleengine.gui 
{
	import battleengine.BattleScreen;
	import com.rnk.gui.MovieClipSwitchButton;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import popups.windows.Popups;
	import soundmanager.SoundManager;
	/**
	 * ...
	 * @author me
	 */
	public class Gui extends Sprite
	{
		private var bg:MovieClip;
		private var textField:TextField;
		private var soundMuteButton:MovieClipSwitchButton;
		private var musicMuteButton:MovieClipSwitchButton;
		public var papa:BattleScreen;
		
		public function Gui() 
		{
			bg = new ingame_gui();
			addChild(bg);
			
		}
		
		public function Init():void
		{
			//profiler texts
			/*textField = new TextField();
			addChild(textField);
			textField.mouseEnabled = false;
			textField.selectable = false;
			textField.textColor = 0xFFFFFF;
			textField.width = 800;
			textField.height= 700;*/
			
			soundMuteButton = new MovieClipSwitchButton(bg.soundbutton);
			musicMuteButton = new MovieClipSwitchButton(bg.musicbutton);
			
			soundMuteButton.enabled = !SoundManager.IsSoundMute();
			musicMuteButton.enabled = !SoundManager.IsMusicMute();
			
			SetListeners(true);
		}
		
		public function Die():void
		{
			SetListeners(false);
		}
		
		private function SetListeners(orly:Boolean):void
		{
			var buttons:Array = [bg.menuButton,soundMuteButton,musicMuteButton];
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
				case soundMuteButton:
					SoundManager.MuteSound(!soundMuteButton.enabled);
				break;
				case musicMuteButton:
					SoundManager.MuteMusic(!musicMuteButton.enabled);
				break;
				/*case bg.restartButton:
					papa.Restart();
				break;*/
			}
		}
		
		private function OnLevelMenuPopupCallback(result:int):void 
		{
			switch (result) 
			{
				case 1:
					papa.Restart();
				break;
				case 2:
					papa.screenManager.ShowScreen(Screens.MENU);
				break;
				case 3:
					papa.Restart();
				break;
			}
		}
		
		public function Update():void
		{
			/*var localObj:Object = Profiler.instance.tasks;
			textField.text = "";
			for each (var item:Object in localObj) 
			{
				textField.appendText(item.name + ": " + String(item.time) + " ms\n");
			}*/
			
			
			bg.w_text.text = papa.weaponsOnline?"1":"0";
			bg.p_text.text = String(papa.objectManager.pendingObjects);
			bg.ml_text.text = String(papa.objectManager.monstersCount);
			bg.mk_text.text = String(papa.objectManager.killedMonsters);
			bg.lg_text.text = String(papa.levelInfo.goals[0])+" "+String(papa.levelInfo.goals[1])+" "+String(papa.levelInfo.goals[2]);
		}
		
		
	}

}