package popups 
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	
	/**
	 * ...
	 * @author Sulus Ltd.
	 */
	public class PopupManager extends Sprite
	{
		private var SCREENWIDTH:Number;
		private var SCREENHEIGHT:Number;
		
		//normal popup
		public var mCurrentPopupWindow:PopupWindow;
		private var mPendingPopupWindows:Array;
		
		//black bg
		private var mBlackScreen:Sprite;
		private var blackScreenPrepared:Boolean = false;
		
		public function PopupManager() 
		{
			
			SCREENWIDTH = Main.SCREEN_WIDTH;
			SCREENHEIGHT = Main.SCREEN_HEIGHT;
			
			mPendingPopupWindows = [];
			
			mBlackScreen = new Sprite();
			mBlackScreen.graphics.beginFill(0x000000, 0.3);
			mBlackScreen.graphics.drawRect(0, 0, SCREENWIDTH, SCREENHEIGHT);
			mBlackScreen.graphics.endFill();
		}
		
		public function Popup(
									popupWindowClass:Class,
									data:Object = null,
									callback:Function = null,
									highPriority:Boolean = false,
									modalWindow:Boolean = true
								):void
		{
			var newPopupWindow:PopupWindow = new popupWindowClass();
			newPopupWindow.SetPapa(this, data, callback);
			newPopupWindow.modal = modalWindow;
			
			if (mCurrentPopupWindow) 
			{
				if (highPriority)
				{
					if (mCurrentPopupWindow.modal)
						newPopupWindow.modal = mCurrentPopupWindow.modal;
					
					mPendingPopupWindows.unshift(mCurrentPopupWindow);
					mPendingPopupWindows.unshift(newPopupWindow);
					ClosePopup(true);
					return;
				} else
				{
					mPendingPopupWindows.push(newPopupWindow);
					return;
				}
				
				
			} 
			SetCurrentPopupWindow(newPopupWindow);
		}
		
		private function SetCurrentPopupWindow(popa:PopupWindow):void
		{
			if (popa.modal)
				PrepareBlackScreen();
			
			mCurrentPopupWindow = popa;
			addChild(mCurrentPopupWindow);
			
			mCurrentPopupWindow.x = (SCREENWIDTH - mCurrentPopupWindow.width) / 2;
			mCurrentPopupWindow.y = -mCurrentPopupWindow.height;
			mCurrentPopupWindow.alpha = 0.0;
			mCurrentPopupWindow.active = true;
			//mCurrentPopupWindow.y = (SCREENHEIGHT - mCurrentPopupWindow.height) / 2;
			
			TweenLite.to(mCurrentPopupWindow, 0.5, 
				{ 
					ease:Quad.easeOut/*Bounce.easeOut*/, 
					y:(SCREENHEIGHT - mCurrentPopupWindow.height) / 2 ,
					alpha:1.0
				} 
			);
			
			if (!mCurrentPopupWindow.isInited)
			{
				mCurrentPopupWindow.Init();
				mCurrentPopupWindow.isInited = true;
			} else
			{
				mCurrentPopupWindow.UnPause();
			}
			
		}
		
		private function PrepareBlackScreen():void 
		{
			if (blackScreenPrepared) return;
			
			var gh:int = SCREENHEIGHT;
			var gw:int = SCREENWIDTH;
			mBlackScreen.width = ((stage.displayState == StageDisplayState.FULL_SCREEN) ? stage.fullScreenWidth : gw);
			mBlackScreen.height = ((stage.displayState == StageDisplayState.FULL_SCREEN) ? stage.fullScreenHeight : gh);
			mBlackScreen.x = ((stage.displayState == StageDisplayState.FULL_SCREEN) ? -(stage.fullScreenWidth - gw) / 2 : 0);
			mBlackScreen.y = ((stage.displayState == StageDisplayState.FULL_SCREEN) ? -(stage.fullScreenHeight - gh) / 2 : 0);
			mBlackScreen.alpha = 0.0;
			
			addChild(mBlackScreen);
			TweenLite.to(mBlackScreen, 0.5, 
				{ 
					ease:Quad.easeOut/*Bounce.easeOut*/, 
					alpha:1.0
				} 
			);
			
			blackScreenPrepared = true;
		}
		
		private function RemoveBlackScreen():void 
		{
			if (!blackScreenPrepared) return;
			removeChild(mBlackScreen);
			blackScreenPrepared = false;
		}
		
		//dont use softclose from public its only for internal use
		public function ClosePopup(softClose:Boolean=false):void
		{
			if (!mCurrentPopupWindow) return;
			var savedWindow:PopupWindow = mCurrentPopupWindow;
			mCurrentPopupWindow.active = false;
			
			if (!softClose)
				mCurrentPopupWindow.Die();
			else
				mCurrentPopupWindow.Pause();
			
			if (savedWindow.modal)
				RemoveBlackScreen();
			//removeChild(mCurrentPopupWindow);
			
			TweenLite.to(savedWindow, 0.5, 
				{ 
					ease:Quad.easeIn/*Bounce.easeOut*/,
					y:0 - mCurrentPopupWindow.height,
					alpha:0.0,
					onComplete: function():void
						{
							removeChild(savedWindow);
							if (Boolean(savedWindow.mCallback))
								savedWindow.mCallback.apply(savedWindow, savedWindow.mCallbackParams);
						}
				} 
			);
			
			mCurrentPopupWindow = null;
			
			if (mPendingPopupWindows.length > 0)
			{
				SetCurrentPopupWindow(mPendingPopupWindows.shift());
			}
			
		}
		
		public function SwitchFullScreen(fullScr:Boolean):void
		{
			var gh:int = SCREENHEIGHT;
			var gw:int = SCREENWIDTH;
			mBlackScreen.width = ((stage.displayState == StageDisplayState.FULL_SCREEN) ? stage.fullScreenWidth : gw);
			mBlackScreen.height = ((stage.displayState == StageDisplayState.FULL_SCREEN) ? stage.fullScreenHeight : gh);
			mBlackScreen.x = ((stage.displayState == StageDisplayState.FULL_SCREEN) ? -(stage.fullScreenWidth - gw) / 2 : 0);
			mBlackScreen.y = ((stage.displayState == StageDisplayState.FULL_SCREEN) ? -(stage.fullScreenHeight - gh) / 2 : 0);
			
		}
		
	}

}