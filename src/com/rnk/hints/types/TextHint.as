package client.game.gui.hints.types 
{
	import client.game.gui.hints.*;
	import client.resourcemanager.ResourceManager;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author 
	 */
	public class TextHint extends Hint
	{
		private var bg:MovieClip;
		
		public function TextHint() 
		{
			bg = ResourceManager.instance.GetAsset("hints", "balloons.texthint");
			addChild(bg);
		}
		
		override public function Init():void 
		{
			var txtFld:TextField = bg.txt as TextField;
			txtFld.autoSize = TextFieldAutoSize.LEFT;
			if (data.textWidth != undefined)
			{
				txtFld.width = data.textWidth;
				txtFld.wordWrap = true;
			} else
			{
				
				txtFld.wordWrap = false;
			}
			txtFld.text = String(data.text);
			var txtRect:Rectangle = txtFld.getBounds(txtFld);
			
			
			var bg:MovieClip = bg.bg as MovieClip;
			bg.width = txtRect.width;
			bg.height = txtRect.height;
			
		}
		
		
		
	}

}