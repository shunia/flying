package me.shunia.tcpip.http
{
	public class HttpHeader
	{
		
		protected var _raw:Array = null;
		
		public function HttpHeader()
		{
			_raw = [];
		}
		
		public function addRawHeader(pair:Array):void {
			if (pair && pair.length == 2) 
				_raw.push(pair);
		}
		
		public function g(k:String):Array {
			var arr:Array = [];
			
			for (var i:int = 0; i < _raw.length; i ++) {
				if (_raw[i][0].toLowerCase() == k.toLowerCase()) 
					arr.push(_raw[i].concat());
			}
			
			return arr;
		}
		
	}
}