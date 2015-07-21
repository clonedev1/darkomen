package  
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author me
	 */
	public class Config extends EventDispatcher
	{
		[Embed(source = "../bin/config.xml", mimeType = "application/octet-stream")] private static const embedXml:Class;
		
		public static var xml:XML;
		
		public function Config() 
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event):void 
				{ 
					trace("config.xml found"); 
					try 
					{
						xml = new XML(e.target.data); 
						ConfigLoaded();
					}
					catch (e:Error)
					{
						LoadEmbed();
					}
					
			} );
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void 
				{ 
					trace("config.xml not found"); 
					LoadEmbed();
					
			} );
			loader.load(new URLRequest("config.xml"));
			
			
			
		}
		
		private function ConfigLoaded():void
		{
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function LoadEmbed():void 
		{
			var byteArray:ByteArray = new embedXml();
			xml = new XML(byteArray.readUTFBytes(byteArray.length));
			ConfigLoaded();
		}
	}

}