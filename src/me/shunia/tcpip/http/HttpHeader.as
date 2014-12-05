package me.shunia.tcpip.http
{
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	use namespace flash_proxy;

	/**
	 * @author 庆峰
	 */	
	public dynamic class HttpHeader extends Proxy
	{
		
		/**
		 * Hold the message instance. 
		 */		
		protected var _message:HttpMessage = null;
		
		protected var _params:Object = {};
		protected var _exports:Dictionary = new Dictionary();
		
		public function HttpHeader(message:HttpMessage)
		{
			_message = message;
		}
		
		/**
		 * Follow the common http request content parsing rules.
		 * Because the hyper text transfer protocol are based on text,so all parse process is easy to handle with string operations.
		 *  
		 * @param str
		 * @return 
		 */		
		protected function readParams(str:String):Object {
			if (!validStr(str)) return null;
			var o:Object = {};
			
			// split by CRLF 
			var splits:Array = str.split(HttpEnum.CRLF);
			// The first line of http request is really special and it will be handled seperately.
			var firstLine:Object = readHttpFirstLine(splits.shift());
			for (var k:String in firstLine) {
				o[k] = firstLine[k];
			}
			// other head info
			if (splits && splits.length > 0) {
				for each (var line:String in splits) {
					var lineObject:Object = readLine(line);
					if (lineObject && lineObject["key"]) {
						o[lineObject["key"]] = lineObject["value"];
					}
				}
			}
			
			return o;
		}
		
		/**
		 * Read http request method and http version
		 *  
		 * @param head
		 * @return 
		 */		
		protected function readHttpFirstLine(head:String):Object {
			return {};
		}
		
		/**
		 * Read and parse every line of http request content.
		 * 
		 * @param line
		 * @return 
		 */		
		protected function readLine(line:String):Object {
			if (!validStr(line)) return null;
			// split with ": " to seperate the request key and value
			var m:Array = line.split(": ");
			var key:String = m[0];
			var value:String = m[1];
			
			var o:Object = {};
			o["key"] = key;
			o["value"] = value;
			
			return o;
		}
		
		////////////////////////
		//
		// override proxy functions to accept dynamic property get/set or function call.
		//
		///////////////////////
		override flash_proxy function getProperty(name:*):* {
			return getPropertyInternal(qName(name));
		}
		
		override flash_proxy function setProperty(name:*, value:*):void {
			setPropertyInternal(qName(name), value);
		}
		
		override flash_proxy function callProperty(name:*, ...args):* {
			return callPropertyInternal(qName(name), args);
		}
		
		override flash_proxy function hasProperty(name:*):Boolean {
			return hasPropertyInternal(qName(name));
		}
		
		///////////////////////
		//
		// internal functions to deal with property get/set and function calls.
		// accepts name as string parameters not the QName instance
		//
		///////////////////////
		protected function getPropertyInternal(name:String):* {
			var result:String = hasPropertyInternal(name) ? _params[name] : "";
			return result;
		}
		
		protected function hasPropertyInternal(name:String):Boolean {
			return _params && _params.hasOwnProperty(name);
		}
		
		protected function setPropertyInternal(name:String, value:*):void {
			_params && (_params[name] = value);
		}
		
		protected function callPropertyInternal(name:String, ...args):* {
			switch (name) {
				case "get" : 
					return getPropertyInternal(args[0]);
					break;
				case "add" : 
					setPropertyInternal(args[0], args[1]);
					return null;
					break;
			}
		}
		
		public function toString():String {
			return "";
		}
		
		/**
		 * To prevent empty string in http request header.
		 *  
		 * @param str
		 * @return 
		 */		
		protected function validStr(str:String):Boolean {
			return str != null && str.length > 0;
		}
		
		protected function qName(name:*):String {
			if(name is QName) 
				return name.localName;
			else 
				return String(name);
		}
		
	}
}