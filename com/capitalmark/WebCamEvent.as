package com.capitalmark 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Larry Sharpe
	 */
	public class WebCamEvent extends Event 
	{
		public static const ON_BROADCASTING:String = "onBroadcasting";
		public static const ON_BROADCASTINGCANCEL:String = "onBroadcastingCancel";
		public static const ON_CONNECTFAIL:String = "onConnectFail";
		public static const ON_CONNECTSUCCESS:String = "onConnectSuccess";
		public static const ON_PUBLISHFAIL:String = "onPublishFail";
		public static const ON_PUBLISHSUCCESS:String = "onPublishSuccess";		
		public static const ON_CONNECTATTEMPT:String = "onConnectAttempt";
		public static const ON_TIMEOUTWARNING:String = "onTimeOutWarning";
		public static const ON_TIMEOUTWARNINGCANCEL:String = "onTimeOutWarningCancel";
		public static const ON_TIMEOUT:String = "onTimeOut";
		public static const ON_WATCHSUCCESS:String = "onWatchSuccess";
		
		public function WebCamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}