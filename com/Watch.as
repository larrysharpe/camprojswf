package com 
{
	import com.Settings;
	import flash.display.MovieClip;
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;

	/**
	 * ...
	 * @author Larry Sharpe
	 */
	public class Watch extends MovieClip
	{

		var nsPlay:NetStream = null;                      
		var settings:Settings;
		var connector:Connector;
		
		public function Watch(){
			settings = new Settings(loaderInfo);
			initConnector();
			initUI();
		}
		
		function initUI() {
			txt_offline.visible = txt_away.visible = false;
		}
		
		private function initConnector()
		{
			this.connector = new Connector(settings);
			connector.addEventListener(ConnectorEvent.ON_DISCONNECT, onDisconnect);
			connector.addEventListener(ConnectorEvent.ON_SUCCESS, onConnect);
			connector.connect();
		}
		
		private function onDisconnect(e = null)
		{
			
		}
		
		private function onConnect(e = null)
		{
			subscribe();
		}

		function nsPlayOnStatus(infoObject:NetStatusEvent)
		{
			trace("nsPlay: " + infoObject.info.code + " (" + infoObject.info.description + ")");
			
			if (infoObject.info.code == 'NetStream.Play.PublishNotify') {}
			if (infoObject.info.code == 'NetStream.Play.Reset') {}
			if (infoObject.info.code == 'NetStream.Play.Start') {
				trace('Broadcaster is Broadcasting.');
				txt_offline.visible = false;
				txt_away.visible = false;
			}			
			if (infoObject.info.code == 'NetStream.Play.UnpublishNotify') {
				trace('Broadcaster Has Stopped Broadcasting.');
				txt_offline.visible = false;
				txt_away.visible = true;
			}
			if (infoObject.info.code == "NetStream.Play.StreamNotFound") {
				trace('Broadcaster Is Offline.');
				txt_offline.visible = true;
				txt_away.visible = false;
			}
			if (infoObject.info.code == "NetStream.Play.Failed") {
				trace('Broadcaster Status is unknown please check again.');
				txt_offline.visible = true;
				txt_away.visible = false;
			}		
		}

		function subscribe(event = null)
		{
				nsPlay = new NetStream(connector.nc);
				nsPlay.addEventListener(NetStatusEvent.NET_STATUS, nsPlayOnStatus);
				nsPlay.bufferTime = 0;
				
			var nsPlayClientObj:Object = new Object();
		nsPlay.client = nsPlayClientObj;
		nsPlayClientObj.onMetaData = function(infoObject:Object) 
		{
			trace("onMetaData");
			
			// print debug information about the metaData
			for (var propName:String in infoObject)
			{
				trace("  "+propName + " = " + infoObject[propName]);
			}
		};		

				
				nsPlay.play(settings.broadcaster);
				videoRemote.attachNetStream(nsPlay);
		}
			
		
		
	}
}