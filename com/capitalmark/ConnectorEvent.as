package com.capitalmark 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ConnectorEvent extends Event
	{
		public static const ON_CONNECTFAIL:String = "onConnectFail";
		public static const ON_CONNECTSUCCESS:String = "onConnectSuccess";
		public static const ON_PUBLISHFAIL:String = "onPublishFail";
		public static const ON_PUBLISHSUCCESS:String = "onPublishSuccess";
		public static const ON_WATCHFAIL:String = "onWatchFail";
		public static const ON_WATCHSUCCESS:String = "onWatchSuccess";
		
		public function ConnectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}