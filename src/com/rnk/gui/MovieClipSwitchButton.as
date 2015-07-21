package com.rnk.gui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author puppetmaster
	 */
	public class MovieClipSwitchButton extends Sprite
	{
		private var mc:MovieClip;
		private var onClickCallback:Function;
		private var onClickParams:Array;
		private var _enabled:Boolean = true;
		
		public function MovieClipSwitchButton(mc:MovieClip,OnClickCallback:Function=null,OnClickParams:Array=null) 
		{
			this.onClickCallback = OnClickCallback;
			this.onClickParams= OnClickParams;
			this.mc = mc;
			
			if (mc.parent)
			{
				x = mc.x;
				y = mc.y;
				mc.x = 0;
				mc.y = 0;
				mc.parent.addChildAt(this,mc.parent.getChildIndex(mc));
			}
			
			addChild(mc);
			
			addEventListener(MouseEvent.CLICK, OnMouseClick, false, 0, true);
			enabled = true;
			
			buttonMode = true;
			useHandCursor = true;
			
			mc.mouseChildren = false;
			mc.mouseEnabled = false;
		}
		
		
		
		private function OnMouseClick(e:MouseEvent):void 
		{
			enabled = !enabled;
			
			if (Boolean(onClickCallback)) onClickCallback.apply(this,onClickParams);
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			mc.gotoAndStop(_enabled?1:2);
		}
		
		
		
	}

}