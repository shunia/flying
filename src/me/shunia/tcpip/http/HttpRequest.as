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
		}
		
		internal function init():HttpMessage {
			_header = new HttpRequestHeader(this);
			return this;
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
		
	}
}