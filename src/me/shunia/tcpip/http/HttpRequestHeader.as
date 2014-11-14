package me.shunia.tcpip.http
{
	
	/**
	 * First line of http request header has been split into three final properties:</br>
	 * 	"method" stands for the request method: "GET" "POST" or other valid request method strings.</br>
	 * 	"uri" stands for the request url based on the service root.It's relitive and always starts from "/".</br>
	 * 	"version" stands for the request http version.Currentlly, "HTTP/1.0" and "HTTP/1.1" are the most common ones.</br>  
	 * @author 庆峰
	 */	
	public class HttpRequestHeader extends HttpHeader
	{
		
		public function HttpRequestHeader(req:HttpRequest)
		{
			super(null);
			
			_requestHeaderStr = requestHeader;
			_params = readParams(_requestHeaderStr) || {};
		}
		
		override protected function readHttpFirstLine(head:String):Object {
			var o:Object = super.readHttpFirstLine(head);
			
			// split with " " to seperate info in the line
			var m:Array = head.split(HttpEnum.SP);
			var method:String = m[0];
			var uri:String = m[1];
			var version:String = m[2];
			
			o["method"] = method;
			o["uri"] = uri;
			o["version"] = version;
			
			return o;
		}
		
		override public function toString():String {
			return "";
		}
		
	}
}