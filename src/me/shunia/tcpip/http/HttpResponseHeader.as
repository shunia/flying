package me.shunia.tcpip.http
{
	public class HttpResponseHeader extends HttpHeader
	{
		public function HttpResponseHeader(req:HttpResponse)
		{
			super(req);
		}
		
		override protected function readFirstLine(head:String):Object {
			var o:Object = super.readFirstLine(head);
			
			
			
			return o;
		}
		
	}
}