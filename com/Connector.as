package com 
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	/**
	 * ...
	 * @author Larry Sharpe
	 */
	public class Connector extends EventDispatcher
	{
		
		var nc:NetConnection;
		var connected:Boolean = false;
		var settings:Settings;
		
		public function Connector(settings){
			this.settings = settings;
		}
		
		public function disconnect(e = null){
			nc.close();
			nc = null;
			connected = false;
			dispatchEvent(new ConnectorEvent('onDisconnect'));
		}
		
		public function connect(e = null){
			if (!connected) { 
				nc = new NetConnection();
				trace(settings.connecturl);
				nc.connect(settings.connecturl);
				nc.addEventListener(NetStatusEvent.NET_STATUS, ncOnStatus);	
			} else {
				dispatchEvent(new ConnectorEvent('onSuccess'));
			}
		}
		
		public function ncOnStatus(infoObject:NetStatusEvent){
			//trace("nc: " + infoObject.info.code + " (" + infoObject.info.description + ")");
			if (infoObject.info.code == "NetConnection.Connect.Success") {
				connected = true;
				dispatchEvent(new ConnectorEvent('onSuccess'));
			}
			else if (infoObject.info.code == "NetConnection.Connect.Failed"){
				trace("Connection failed: Try rtmp://[server-ip-address]/videochat");
				connected = false;
				dispatchEvent(new ConnectorEvent('onFail'));
			}
			else if (infoObject.info.code == "NetConnection.Connect.Rejected"){
				trace(infoObject.info.description);
				connected = false;
				dispatchEvent(new ConnectorEvent('onReject'));
			}
		}
		
	}

}