package com {
	
	import flash.net.NetConnection;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	import flash.events.EventDispatcher;
	import flash.events.Event;	
	import com.Connector;
	
	
	/**
	 * ...
	 * @author Larry Sharpe
	 */
	public class Publisher extends EventDispatcher{
		
		var connection:Connector;
		var stream:NetStream;
		var camera;
		var microphone
		
		public function Publisher(connection, webcam) {
			if (connection) this.connection = connection;
			if (webcam.camera) this.camera = webcam.camera;
			if (webcam.microphone) this.microphone = webcam.microphone;
		}
		
		public function publish() {
			stream = new NetStream(connection.nc);
			stream.addEventListener(NetStatusEvent.NET_STATUS, nsPublishOnStatus);
			stream.bufferTime = 0; // set the buffer time to zero since it is chat		
			trace(connection.settings.broadcaster);
			stream.publish(connection.settings.broadcaster); // publish the stream by name
			
			var metaData:Object = new Object();
			metaData["description"] = "Chat using VideoChat example."
			stream.send("@setDataFrame", "onMetaData", metaData);
			trace('Meta data sent');
			
			stream.attachCamera(camera);
			stream.attachAudio(microphone);
		}
		
		function goAway(e = null) {
			
			
			var metaData:Object = new Object();
			metaData["description"] = "User set away status."
			stream.send("@setDataFrame", "onMetaData", metaData);
			trace('Meta data sent');
			
			
			//this.stop();
		}
		
		function stop(e = null) {
			
			stream.send('stopvideo', 'stopcam');
			
			stream.attachCamera(null);
			stream.attachAudio(null);
			stream.publish("null");
			stream.close();
		}
		
		private function nsPublishOnStatus(infoObject:NetStatusEvent)
		{
			//trace("nsPublish: "+infoObject.info.code+" ("+infoObject.info.description+")");
			if (infoObject.info.code == "NetStream.Publish.Start") {  trace('Publishing');  
				dispatchEvent(new PublisherEvent('onPublish'));
			}
			if (infoObject.info.code == "NetStream.Unpublish.Success") {  trace('Not Publishing');  
				dispatchEvent(new PublisherEvent('onUnPublish'));
			}			
			 
			if (infoObject.info.code == "NetStream.Play.StreamNotFound") {}
			if (infoObject.info.code == "NetStream.Play.Failed") trace(infoObject.info.description);
		}
	}
}