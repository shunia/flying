package me.shunia.tcpip.http
{
	public class HttpResponseHeader extends HttpHeader
	{
		public function HttpResponseHeader(req:HttpResponse)
		{
			super(req);
		}
		
		override protected function readHttpFirstLine(head:String):Object {
			var o:Object = super.readHttpFirstLine(head);
			
			
			
			return o;
		}
		
	}
}