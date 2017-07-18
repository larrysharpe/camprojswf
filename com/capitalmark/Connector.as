package com.capitalmark 
{
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Connector extends EventDispatcher
	{
		var camera;
		var microphone;
		var nc:NetConnection;
		var publisher:NetStream;
		var settings:Object;
		var watcher:NetStream;
		
		public function Connector(settings,camera = null,microphone = null) {
			this.settings = settings;
		}
		
		public function connect() 
		{
			
			Messenger.message('connecting to nc');
			nc = new NetConnection();
			nc.connect(settings.connecturl);
			nc.addEventListener(NetStatusEvent.NET_STATUS, ncOnStatus);
		}
		
		public function disconnect() {
			if(publisher) publisher.attachCamera(null);
			if(publisher) publisher.attachAudio(null);
			if(publisher) publisher.publish("null");
			if(publisher) publisher = null;
			nc.close();
			nc = null;
		}
		
		public function watch() {
			
			Messenger.message('Starting Watch');
			watcher = new NetStream(nc);
			watcher.addEventListener(NetStatusEvent.NET_STATUS, nsPlayOnStatus);
			
			// set the buffer time to zero since it is chat
			watcher.bufferTime = 0;
			
			// subscribe to the named stream
			watcher.play(this.settings.broadcaster);
			
			var nsPlayClientObj:Object = new Object();
			watcher.client = nsPlayClientObj;
			nsPlayClientObj.onMetaData = function(infoObject:Object) 
			{
				trace("onMetaData");
				
				// print debug information about the metaData
				for (var propName:String in infoObject)
				{
					trace("  "+propName + " = " + infoObject[propName]);
				}
			};	
			
			Messenger.message('Dispatching Watch Success');
			dispatchEvent(new ConnectorEvent('onWatchSuccess'));
		}
		
		private function nsPlayOnStatus(infoObject:NetStatusEvent)
		{
			trace("nsPlay: " + infoObject.info.code + " (" + infoObject.info.description + ")");

			if (infoObject.info.code == "NetStream.Play.StreamNotFound" || infoObject.info.code == "NetStream.Play.Failed")
				Messenger.message(infoObject.info.description);
		}
		
		public function broadcast() {
			publisher = new NetStream(nc);
			publisher.addEventListener(NetStatusEvent.NET_STATUS, nsPublishOnStatus);
			publisher.bufferTime = 0;
		
			// publish the stream by name
			publisher.publish(settings.broadcaster);	
			publisher.attachCamera(camera);
			publisher.attachAudio(microphone);			
		}
		
		function nsPublishOnStatus(infoObject:NetStatusEvent)
		{
			trace("nsPublish: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetStream.Play.StreamNotFound" || infoObject.info.code == "NetStream.Play.Failed"){
				trace(infoObject.info.description);
				dispatchEvent(new ConnectorEvent('onPublishFail'));
			} else {
				dispatchEvent(new ConnectorEvent('onPublishSuccess'));
			}
				
		}		
		
		function ncOnStatus(infoObject:NetStatusEvent)
		{
			trace(infoObject.info.code)
			if (infoObject.info.code == "NetConnection.Connect.Failed"){
				dispatchEvent(new ConnectorEvent('onConnectFail'));
			} else if (infoObject.info.code == "NetConnection.Connect.Success") {
				dispatchEvent(new ConnectorEvent('onConnectSuccess'));
			} else if (infoObject.info.code == "NetConnection.Connect.Rejected"){
			}
		}		
		
	}

}