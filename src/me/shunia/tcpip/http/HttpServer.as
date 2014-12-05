package me.shunia.tcpip.http
{
	import me.shunia.tcpip.lib.Server;

	public class HttpServer
	{
		
		protected var _server:Server = null;
		protected var _host:String = "0.0.0.0";
		protected var _port:int = 6883;
		protected var _handler:Function = null;
		
		public function HttpServer(handler:Function)
		{
			this.handler = handler;
		}
		
		/**
		 * Call this method will accutally start the server on the given host and port.
		 *  
		 * @param host
		 * @param port
		 */		
		public function listen(port:int = 6883, host:String = "0.0.0.0"):void {
			this.host = host;
			this.port = port;
			
			if (!_server) {
				_server = new Server(_port, _host, HttpConnection, _handler);
			}
			
			trace("Http server listening on http://" + host + ":" + port);
		}
		
		public function close():void {
			if (_server) {
				_server.dispose();
				_server = null;
			}
			_host = "0.0.0.0";
			_port = 6883;
		}
		
		/**
		 * Listening port for this server.</br>
		 * The port create should be restricted to 0 ~ int.MAX_VALUE.But 1024 ~ int.MAX_VALUE is recommended.</br>
		 * Default is "6883". 
		 */
		public function get port():int
		{
			return _port;
		}

		/**
		 * @private
		 */
		public function set port(value:int):void
		{
			if (value < 0) return;
			
			_port = value;
		}

		/**
		 * Listening host for this server.</br>
		 * This parameter should be a validate host string according to the rfc needs.</br>
		 * Default is "locaohost". 
		 */
		public function get host():String
		{
			return _host;
		}

		/**
		 * @private
		 */
		public function set host(value:String):void
		{
			if (!value) return;
			
			_host = value;
		}

		/**
		 * Call back for handling request and reponde to client. 
		 */
		public function get handler():Function
		{
			return _handler;
		}

		/**
		 * @private
		 */
		public function set handler(value:Function):void
		{
			_handler = value;
		}


	}
}