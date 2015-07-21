package popups.windows 
{
	import flash.events.MouseEvent;
	import popups.PopupWindow;
	/**
	 * ...
	 * @author 
	 */
	public class LevelLosePopup extends PopupWindow
	{
		
		public function LevelLosePopup() 
		{
			super(new level_lose_popup());
		}
		
		override public function Init():void 
		{
			super.Init();
			
			SetListeners(true);
		}
		
		override public function Die():void 
		{
			super.Die();
			
			SetListeners(false);
		}
		
		private function SetListeners(orly:Boolean):void 
		{
			var buttons:Array = [mBg.menubutton, mBg.upgbutton, mBg.retrybutton];
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
				case mBg.retrybutton:
					result = 3;
				break;
			}
			mCallbackParams = [result];
			
			Close();
			
		}
		
		
		
	}

}