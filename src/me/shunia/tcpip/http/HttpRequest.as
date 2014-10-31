package me.shunia.tcpip.http
{
	import flash.net.Socket;

	public class HttpRequest
	{
		
		private var _source:Socket = null;
		private var _requestStr:String = null;
		private var _params:Object = null;
		
		public function HttpRequest(source:Socket, requestStr:String)
		{
			_requestStr = requestStr;
			_source = source;
			_params = readParams(requestStr);
		}
		
		/**
		 * Request parameters.
		 * 
		 * First line of http request header has been split into three final properties:</br>
		 * 	"_http_method" stands for the request method: "GET" "POST" or other valid request method strings.</br>
		 * 	"_http_url" stands for the request url based on the service root.It's relitive and always starts from "/".</br>
		 * 	"_http_version" stands for the request http version.Currentlly, "HTTP/1.0" and "HTTP/1.1" are the most common ones.</br>
		 *  
		 * @return 
		 */		
		public function get params():Object {
			return _params;
		}
		
		/**
		 * Original connection socket.
		 *  
		 * @return 
		 */		
		public function get source():Socket {
			return _source;
		}
		
		/**
		 * Implements of toString method to output raw string content for this request.
		 *  
		 * @return 
		 */		
		public function toString():String {
			return _requestStr;
		}
		
		/**
		 * Follow the common http request content parsing rules.
		 * Because the hyper text transfer protocol are based on text,so all parse process is easy to handle with string operations.
		 *  
		 * @param str
		 * @return 
		 */		
		protected function readParams(str:String):Object {
			var o:Object = {};
			
			// split by CRLF 
			var splits:Array = str.split(HttpEnum.CRLF);
			// The first line of http request is really special and it will be handled seperately.
			var headObject:Object = readHttpFirstLine(splits.shift());
			for (var k:String in headObject) {
				o[k] = headObject[k];
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
			// split with " " to seperate info in the line
			var m:Array = head.split(HttpEnum.SPACER);
			var method:String = m[0];
			var url:String = m[1];
			var version:String = m[2];
			
			var o:Object = {};
			o["_http_method"] = method;
			o["_http_url"] = url;
			o["_http_version"] = version;
			
			return o;
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
		
		/**
		 * To prevent empty string in http request header.
		 *  
		 * @param str
		 * @return 
		 */		
		protected function validStr(str:String):Boolean {
			return str != null && str.length > 0;
		}
		
		public function dispose():void {
			_source = null;
			_params = null;
		}
		
	}
}