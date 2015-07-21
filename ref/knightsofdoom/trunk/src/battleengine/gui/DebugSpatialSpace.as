package battleengine.gui 
{
	import battleengine.objects.GameObject;
	import battleengine.objects.SpatialSpace;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author ...
	 */
	public class DebugSpatialSpace extends Sprite
	{
		private var space:SpatialSpace;
		private var screen:Bitmap;
		private var bmd:BitmapData;
		private var txt:TextField;
		private var sectorTemplate:Sprite;
		private var screenRect:Rectangle;
		
		public function DebugSpatialSpace(space:SpatialSpace) 
		{
			this.space = space;
			
			screen = new Bitmap();
			addChild(screen);
			bmd = new BitmapData(800, 600);
			screen.bitmapData = bmd;
			
			txt = new TextField();
			txt.textColor = 0x00FF00;
			var txtFormat:TextFormat = txt.getTextFormat();
			txtFormat.size = 36;
			txtFormat.align = TextFormatAlign.CENTER;
			txt.setTextFormat(txtFormat);
			
			sectorTemplate = new Sprite();
			sectorTemplate.graphics.lineStyle(1.0, 0x00FF00, 0.7);
			sectorTemplate.graphics.drawRect(0, 0, SpatialSpace.SECTOR_WIDTH, SpatialSpace.SECTOR_HEIGHT);
			
			screenRect = new Rectangle(0, 0, 800, 600);
			
			DrawSpace();
			
			
		}
		
		public function Update():void
		{
			DrawSpace();
		}
		
		private function DrawSpace():void 
		{
			bmd.fillRect(screenRect, 0x00000000);
			
			var sectors:Object = space.sectorsObjects;
			
			if (!sectors) return;
			
			
			
			var rect:Rectangle = new Rectangle();
			for each (var obj:GameObject in space.objects) 
			{
				var r:Number = obj.collisionInfo.r;
				rect.x = obj.x - r;
				rect.y = obj.y - r;
				rect.width = r*2;
				rect.height= r*2;
				bmd.fillRect(rect, 0x5000FF00);
			}
			
			
			var mtx:Matrix = new Matrix();
			var textMtx:Matrix = new Matrix();
			textMtx.scale(5.0,5.0);
			for (var secName:String in sectors) 
			{
				var si:Array = secName.split("_");
				var sx:Number = si[0] * SpatialSpace.SECTOR_WIDTH;
				var sy:Number = si[1] * SpatialSpace.SECTOR_HEIGHT;
				
				mtx.tx = sx;
				mtx.ty = sy;
				bmd.draw(sectorTemplate,mtx);
				
				
				var secObjects:Array = sectors[secName] as Array;
				if (secObjects && secObjects.length > 0)
				{
					txt.text = String(secObjects.length);
					textMtx.tx = sx + 20;
					textMtx.ty = sy + 20;
					bmd.draw(txt, textMtx);
					
				}
				
				
			}
			
		}
		
		
		
		
		
	}

}