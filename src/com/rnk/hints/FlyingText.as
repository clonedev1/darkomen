package client.game.gui.hints 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author 
	 */
	public class FlyingText extends Sprite
	{
		private var txtFld:TextField;
		public var style:Object;
		public var text:String;
		
		public function FlyingText(text:String , style:Object = null) 
		{
			this.style = (style == null)?FlyingTextStyles.DEFAULT:style;
			this.text = text;
			
		}
		
		public function Init():void
		{
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.color = style.color == undefined?0xFFFFFF:style.color;
			textFormat.font = style.font == undefined?CONFIGURABLE.FONT:style.font;
			textFormat.size = style.size == undefined?22:style.size;
			textFormat.align = TextFormatAlign.LEFT;
			
			txtFld = new TextField();
			txtFld.defaultTextFormat = textFormat;
			txtFld.text = text;
			txtFld.autoSize = TextFieldAutoSize.LEFT;
			addChild(txtFld);
			txtFld.x = -txtFld.getLineMetrics(0).width / 2;
			txtFld.y = -txtFld.getLineMetrics(0).height / 2;
			txtFld .embedFonts = true;
			
			filters = [new GlowFilter(0x000000,0.5,3.0,3.0)];
			
			/*var redDot:Sprite = new Sprite();
			redDot.graphics.lineStyle(1.0, 0xFF0000);
			redDot.graphics.beginFill(0xFF0000);
			redDot.graphics.drawCircle(0, 0, 5);
			redDot.graphics.endFill();
			addChild(redDot);*/
			
			TweenLite.to(txtFld, 5.0, { y: txtFld.y - 100, alpha: 0.0, onComplete:OnComplete } );
		}
		
		private function OnComplete():void
		{
			Die();
		}
		
		public function Die():void
		{
			if (parent)
				parent.removeChild(this);
			TweenLite.killTweensOf(txtFld);
		}
		
	}

}