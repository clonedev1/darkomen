package popups.windows 
{
	import flash.events.MouseEvent;
	import popups.PopupWindow;
	/**
	 * ...
	 * @author 
	 */
	public class LevelWinPopup extends PopupWindow
	{
		
		public function LevelWinPopup() 
		{
			super(new level_win_popup());
		}
		
		override public function Init():void 
		{
			super.Init();
			
			SetListeners(true);
			
			mBg.leveltext.text = "Level " + String(mData.level);
			var medals:Array = ["Wood medal", "Iron medal", "Gold medal"];
			mBg.resulttext.text = medals[int(mData.result)];
			
		}
		
		override public function Die():void 
		{
			super.Die();
			
			SetListeners(false);
		}
		
		private function SetListeners(orly:Boolean):void 
		{
			var buttons:Array = [mBg.menubutton, mBg.upgbutton, mBg.nextbutton];
			addEventListener(MouseEvent.CLICK, OnButtonClick);
		}
		
		private function OnButtonClick(e:MouseEvent):void 
		{
			var result:int = 0;
			switch (e.target) 
			{
				case mBg.menubutton:
					result = 1;
				break;
				case mBg.upgbutton:
					result = 2;
				break;
				case mBg.nextbutton:
					result = 3;
				break;
			}
			mCallbackParams = [result];
			
			Close();
			
		}
		
		
		
	}

}