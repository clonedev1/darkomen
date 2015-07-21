package popups.windows 
{
	import flash.events.MouseEvent;
	import popups.PopupWindow;
	/**
	 * ...
	 * @author 
	 */
	public class LevelMenuPopup extends PopupWindow
	{
		
		public function LevelMenuPopup() 
		{
			super(new level_menu_popup());
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
			var buttons:Array = [mBg.menu, mBg.restart, mBg.moar];
			addEventListener(MouseEvent.CLICK, OnButtonClick);
		}
		
		private function OnButtonClick(e:MouseEvent):void 
		{
			var result:int = 0;
			switch (e.target) 
			{
				case mBg.restart:
					result = 1;
				break;
				case mBg.menu:
					result = 2;
				break;
				case mBg.moar:
					result = 3;
				break;
				default:
				return;
			}
			mCallbackParams = [result];
			
			Close();
			
		}
		
		
		
	}

}