package me.shunia.tcpip.http
{
	import flash.net.Socket;

	public class HttpRequest extends HttpMessage
	{
		
		private var _requestStr:String = null;
		
		public function HttpRequest(source:Socket, reqString:String)
		{
			super(source, reqString);
			_requestStr = reqString;
			_header = new HttpHeader(_requestStr);
		}
		
		/**
		 * Implements of toString method to output raw string content for this request.
		 *  
		 * @return 
		 */		
		override public function toString():String {
			return _requestStr;
		}
		
		public function dispose():void {
			_source = null;
			_header = null;
		}
		
	}
}