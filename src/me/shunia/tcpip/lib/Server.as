package me.shunia.tcpip.lib
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class Server extends EventDispatcher
	{
		
		private static const RETRY_TIMES:int = 10;
		private static const RETRY_INTERVAL:int = 1000;
		
		protected var _serverSocket:ServerSocket = null;
		protected var _connectionCls:Class = null;
		protected var _host:String = "0.0.0.0";
		protected var _port:int = 0;
		protected var _handler:Function = null;
		protected var _connections:Dictionary = new Dictionary();
		private var _retry:int = 0;
		
		public function Server(port:int, host:String = "0.0.0.0", connectionCls:Class = null, handler:Function = null)
		{
			_port = port;
			_host = host;
			_connectionCls = connectionCls ? connectionCls : ServerConnection;
			_handler = handler;
			
			if (validHost() && validPort()) {
				createSocket();
			} else {
				throw new Error("Given port/host is not valid!");
			}
		}
		
		protected function validHost():Boolean {
			return _host;
		}
		
		protected function validPort():Boolean {
			return _port;
		}
		
		protected function createSocket():void {
			try {
				if (!_serverSocket) {
					_serverSocket = new ServerSocket();
					_serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
					_serverSocket.addEventListener(Event.CLOSE, onClose);
					_serverSocket.bind(_port, _host);
				}
				_serverSocket.listen();
			} catch (e:Error) {
				dispose();
				throw new Error("Server socket create failed: " + e.message);
			};
		}
		
		public function dispose():void {
			_host = "0.0.0.0";
			_port = 0;
			_handler = null;
			_retry = 0;
			for (var s:Socket in _connections) {
				if (s && s.connected) {
					s.close();
				}
			}
			_connections = new Dictionary();
			if (_serverSocket) {
				_serverSocket.removeEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
				_serverSocket.removeEventListener(Event.CLOSE, onClose);
				_serverSocket.close();
				_serverSocket = null;
			}
		}
		
		protected function onClose(event:Event):void {
			if (_retry < RETRY_TIMES) {
				_retry ++;
				var interval:uint = setInterval(function ():void {
					clearInterval(interval);
					
					createSocket();
				}, RETRY_INTERVAL);
			} else {
				dispose();
			}
		}
		
		protected function onConnect(event:ServerSocketConnectEvent):void {
			var client:Socket = event.socket;
			trace("Client connected: " + client.remoteAddress + ":" + client.remotePort);
			
			if (!_connections.hasOwnProperty(client)) {
				var conn:IServerConnection = new _connectionCls(client);
				conn.onData = _handler;
				conn.onComplete = onClientDisconnect;
				_connections[client] = conn;
			}
		}
		
		protected function onClientDisconnect(client:Socket):void {
			trace("Client disconnected");
			if (_connections.hasOwnProperty(client)) {
				_connections[client].dispose();
				delete _connections[client];
			}
		}
		
		public function get activeConnections():Dictionary {
			return _connections;
		}
		
		public function get host():String {
			return _host;
		}
		
		public function get port():int {
			return _port;
		}
		
	}
}