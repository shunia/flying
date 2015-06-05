package me.shunia.tcpip.http
{
	public class HttpHead
	{
		
		private var _method:String = "GET";
		private var _path:String = "/";
		private var _version:String = "HTTP/1.1";
		
		public function HttpHead(rawHead:Object)
		{
			_method = rawHead["__method__"];
			_version = rawHead["__version__"];
			_path = rawHead["__url__"];
			var p:Array = _path.split("?");
			if (_method.toLowerCase() == HttpEnum.GET && p.length > 1) {
				
			} else if (_method.toLowerCase() == HttpEnum.POST) {
				
			}
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