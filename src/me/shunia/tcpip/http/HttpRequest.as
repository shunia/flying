package me.shunia.tcpip.http
{
	import flash.net.Socket;

	public class HttpRequest extends HttpMessage
	{
		
		private var _requestStr:String = null;
		
		public function HttpRequest(source:Socket, reqString:String)
		{
			super(source);
			_requestStr = reqString;
			
			_header = new HttpRequestHeader(this);
		}
		
		public function get(key:String):String {
			return _header ? _header.get(key) : "";
		}
		
		public function get raw():String {
			return _requestStr;
		}
		
		/**
		 * output raw string content for this request.
		 *  
		 * @return 
		 */		
		override public function toString():String {
			return raw;
		}
		
		public function dispose():void {
			_source = null;
			_header = null;
		}
		
	}
}