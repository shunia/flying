package me.shunia.tcpip.lib
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;

	public class ServerConnection implements IServerConnection
	{
		
		protected var _client:Socket = null;
		protected var _onComplete:Function = null;
		protected var _onData:Function = null;
		
		public function ServerConnection(client:Socket = null)
		{
			this.client = client;
		}
		
		protected function onClose(event:Event):void {
			close();
		}
		
		protected function onSocketData(event:ProgressEvent):void {
			trace("Client sending data from: " + _client.remoteAddress + ":" + _client.remotePort + ", incoming data: " + event.bytesLoaded);
			onRead(_client);
		}
		
		public function onRead(input:Socket):void
		{
			// empty for override
		}
		
		public function set client(value:Socket):void
		{
			if (!value) return;
			
			_client = value;
			_client.addEventListener(Event.CLOSE, onClose);
			_client.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		public function set onData(value:Function):void {
			_onData = value;
		}
		
		public function set onComplete(value:Function):void
		{
			_onComplete = value;
		}
		
		public function close():void
		{
			if (_client) {
				_client.removeEventListener(Event.CLOSE, onClose);
				_client.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				_client.close();
			}
			if (_onComplete != null) {
				_onComplete.apply(null, [_client]);
			}
			_onComplete = null;
			_client = null;
		}
		
	}
}