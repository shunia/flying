package me.shunia.tcpip.http
{
	public class HttpHeader
	{
		
		private var _method:String = "GET";
		private var _path:String = "/";
		private var _version:String = "HTTP/1.1";
		
		public function HttpHeader(params:String)
		{
		}
		
		public function get method():String
		{
			return _method;
		}

		public function get path():String
		{
			return _path;
		}

		public function get version():String
		{
			return _version;
		}
		
	}
}