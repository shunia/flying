package me.shunia.tcpip.http
{
	import flash.net.Socket;

	public class HttpRequest
	{
		
		protected var _source:Socket = null;
		protected var _requestStr:String = null;
		protected var _params:Object = null;
		protected var _header:HttpHeader = null;
		protected var _head:HttpHead = null;
		
		public function HttpRequest(source:Socket, requestStr:String)
		{
			_requestStr = requestStr;
			_source = source;
			read(requestStr);
		}
		
		/**
		 * Request parameters.
		 * 
		 * First line of http request header has been split into three final properties:</br>
		 * 	"__method__" stands for the request method: "GET" "POST" or other valid request method strings.</br>
		 * 	"__url__" stands for the request url based on the service root.It's relitive and always starts from "/".</br>
		 * 	"__version__" stands for the request http version.Currentlly, "HTTP/1.0" and "HTTP/1.1" are the most common ones.</br>
		 *  
		 * @return 
		 */		
		public function get params():Object {
			return _params;
		}
		
		/**
		 * Http request head content: </br>
		 * 
		 *  "__method__" stands for the request method: "GET" "POST" or other valid request method strings.</br>
		 * 	"__url__" stands for the request url based on the service root.It's relitive and always starts from "/".</br>
		 * 	"__version__" stands for the request http version.Currentlly, "HTTP/1.0" and "HTTP/1.1" are the most common ones.</br>
		 *  
		 * @return 
		 */		
		public function get head():HttpHead {
			return _head;
		}
		
		public function get header():HttpHeader {
			return _header;
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
		protected function read(str:String):void {
			// split by CRLF 
			var splits:Array = str.split(HttpEnum.CRLF);
			// The first line of http request is really special and it will be handled seperately.
			_head = new HttpHead(readHttpFirstLine(splits.shift()));
			// http headers
			_header = new HttpHeader();
			// other head info
			while (splits.length) {
				_header.addRawHeader(readLine(splits.shift()));
			}
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
			o["__method__"] = method;
			o["__url__"] = url;
			o["__version__"] = version;
			
			return o;
		}
		
		/**
		 * Read and parse every line of http request content.
		 * 
		 * @param line String that contains key/value pairs.
		 * @return Key/value pairs.
		 */		
		protected function readLine(line:String):Array {
			if (!validStr(line)) return null;
			// split with ": " to seperate the request key and value
			var m:Array = line.split(HttpEnum.KV_SEPERATER);
			var key:String = m[0];
			var value:String = m[1];
			
			return [key, value];
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