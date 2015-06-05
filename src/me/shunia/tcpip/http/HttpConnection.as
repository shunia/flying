package me.shunia.tcpip.http
{
	import flash.net.Socket;
	
	import me.shunia.tcpip.lib.ServerConnection;
	
	public class HttpConnection extends ServerConnection
	{
		
		private var _request:HttpRequest = null;
		private var _response:HttpResponse = null;
		
		public function HttpConnection(client:Socket=null)
		{
			super(client);
		}
		
		override public function onRead(input:Socket):void {
			super.onRead(input);
			
			if (!input.bytesPending) {
				// read request data
				var requestStrings:String = input.readMultiByte(input.bytesAvailable, "utf-8");
				// parse it into HttpRequest instance
				_request = new HttpRequest(input, requestStrings);
				// create a new HttpResponse instance for response
				_response = new HttpResponse(input);
				// call back to start deal with http data, then responde to client request with reponse instance
				if (_onData != null) {
					_onData.apply(this, [_request, _response]);
				}
			}
		}
		
		override public function close():void {
			super.close();
			if (_request) _request.dispose();
			if (_response) _response.dispose();
		}
		
	}
}