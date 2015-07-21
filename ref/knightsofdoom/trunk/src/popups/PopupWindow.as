package popups 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Sulus Ltd.
	 */
	public class PopupWindow extends Sprite
	{
		
		public var mBg:MovieClip;
		public var mData:Object;
		public var mCallback:Function;
		public var mCallbackParams:Array;
		public var mPapa:PopupManager;
		public var active:Boolean = false;
		public var modal:Boolean = true;
		
		public var isInited:Boolean = false;
		
		public function PopupWindow(bg:MovieClip) 
		{
			mBg = bg;
			addChild(mBg);
		}
		
		public function SetPapa(papa:PopupManager,data:Object,callback:Function):void
		{
			mPapa = papa;
			mData = data;
			mCallback = callback;
			mCallbackParams = null;
		}
		
		public function Init():void
		{
			isInited = true;
		}
		
		public function Pause():void
		{
			
		}
		
		public function UnPause():void
		{
			
		}
		
		public function Die():void
		{
			
		}
		
		protected function Close():void
		{
			mPapa.ClosePopup();
		}

		
	}

}