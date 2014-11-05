package me.shunia.tcpip.http
{
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * A http message is defined by rfc2616 sec4.3: </br>
	 * 	&nbsp&nbsp http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.3 </br>
	 * Genericlly a http message is composed by three parts: </br>
	 * 	&nbsp&nbsp start-line (Request-Line[Request] | Status-Line[Response]) </br>
	 * 	&nbsp&nbsp message-header (generic-header | request-header[Reqeust]/reponse-header[Response] | entity-header) </br>
	 * 	&nbsp&nbsp CRLF </br>
	 * 	&nbsp&nbsp CRLF </br>
	 * 	&nbsp&nbsp message-body </br>
	 * @author 庆峰
	 */	
	public class HttpMessage
	{
		
		protected var _source:Socket = null;
		protected var _header:HttpHeader = null;
		protected var _body:ByteArray = null;
		
		public function HttpMessage(source:Socket, params:Object = null)
		{
			_source = source;
		}

		/**
		 * Message original source, which is the actual socket instance that has connected, to provide low level access to connected client. 
		 */
		public function get source():Socket
		{
			return _source;
		}

		/**
		 * Request or reponse header of the message. 
		 */
		public function get header():HttpHeader
		{
			return _header;
		}

		/**
		 * Request or response body of the message. 
		 */
		public function get body():ByteArray
		{
			return _body;
		}
		
		public function toString():String {
			var str:String = "";
			str += _header ? _header.toString() : "";	// header has contained the first line of request or response.
			str += HttpEnum.CRLF;
			str += HttpEnum.CRLF;
			str += _body ? _body.toString() : "";
			return str;
		}

	}
}