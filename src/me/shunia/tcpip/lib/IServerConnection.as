package me.shunia.tcpip.lib
{
	import flash.net.Socket;

	public interface IServerConnection
	{
		
		function set client(value:Socket):void;
		
		function set onData(value:Function):void;
		
		function set onComplete(value:Function):void;
		
		function onRead(input:Socket):void;
		
		function close():void;
		
	}
}