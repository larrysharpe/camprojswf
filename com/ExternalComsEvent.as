package com 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ExternalComsEvent extends Event
	{
		public static const ON_CALLGOLIVE:String = "onCallGoLive";
		public static const ON_CALLGOAWAY:String = "onCallGoAway";
		public static const ON_CALLGOOFFLINE:String = "onCallGoOffline";

		public function ExternalComsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}