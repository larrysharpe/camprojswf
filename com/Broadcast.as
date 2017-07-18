package com
{

	import com.ExternalComs;
	import com.ExternalComsEvent;
	import com.WebCam;
	import com.ScreenMsg;
	import flash.display.MovieClip;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.*;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author Larry Sharpe
	 */
	public class Broadcast extends MovieClip
	{
		// var nc:NetConnection = null;
		// var camera:Camera;
		// var microphone:Microphone;
		// var nsPublish:NetStream = null;
        var connector:Connector;
        var camAllowed:Boolean = false;
		var external:ExternalComs = new ExternalComs();
		var publisher:Publisher;
        var screenMsg:ScreenMsg = new ScreenMsg('Connecting', 110, 300, 0, 0, 0xcc0000);
		var settings:Settings;
		var webcam:WebCam;

		public function Broadcast()
		{
			this.settings = new Settings(loaderInfo);
			initConnector();
			initUI();
		}
		
		private function initConnector()
		{
			this.connector = new Connector(settings);
			connector.addEventListener(ConnectorEvent.ON_DISCONNECT, onDisconnect);
			connector.addEventListener(ConnectorEvent.ON_SUCCESS, onConnect);
			connector.addEventListener(ConnectorEvent.ON_FAIL, onConnectFail);
			connector.addEventListener(ConnectorEvent.ON_REJECT, onConnectReject);
			connector.connect();


            external.addEventListener(ExternalComsEvent.ON_CALLGOLIVE, connector.connect);
			external.addEventListener(ExternalComsEvent.ON_CALLGOOFFLINE, connector.disconnect);
		}
		
		function initCamera()
		{
			if (!webcam)
			{
				webcam = new WebCam();
				webcam.addEventListener(WebCamEvent.ON_CAMDENIED, onCamDenied);
				webcam.addEventListener(WebCamEvent.ON_CAMACCEPTED, onCamAccepted);
			}
			addChildAt(webcam.vid, 0);
			webcam.start();
		}
		
		private function initPublish()
		{
			publisher = new Publisher(connector, webcam);
			goAway.addEventListener(MouseEvent.CLICK, publisher.goAway);
            external.addEventListener(ExternalComsEvent.ON_CALLGOAWAY,  publisher.goAway);
            publisher.addEventListener(PublisherEvent.ON_PUBLISH, onPublish);
			publisher.addEventListener(PublisherEvent.ON_UNPUBLISH, onUnPublish);
			publisher.publish();
		}
		
		
		function initUI()
		{
			addChild(screenMsg);		
			goLive.addEventListener(MouseEvent.CLICK, connector.connect);
			goOffline.addEventListener(MouseEvent.CLICK, connector.disconnect);
		}
		
		/** Event Responses **/ /** Connection Events **/
		private function onDisconnect(e = null)
		{
			webcam.stop();
			removeChild(webcam.vid);
			screenMsg.text = 'Disconnected';
			goLive.visible = true;
			goAway.visible = goOffline.visible = false;
			this.external.disconnected();
		}
		
		private function onConnect(e = null)
		{
			if (camAllowed)publisher.publish();
			initCamera();
		}
		private function onConnectFail(e = null) {
			screenMsg.text = 'Unavailable';
            external.setStatus('Unavailable');
			trace('Connection Failed. Server not found.')
		}
		private function onConnectReject(e = null){}
		
		/** Cam Events **/
		private function onCamDenied(e = null){}
		private function onCamAccepted(e = null) {
			camAllowed = true;
			initPublish();
		}
		
		/** Publish Events **/
		private function onPublish(e = null) {
			goAway.visible = goOffline.visible = true;
			goLive.visible = false;
			screenMsg.text = 'Live';
            external.setStatus('Live');
		}
		
		private function onUnPublish(e = null){
			goOffline.visible = goLive.visible = true;
			goAway.visible = false;
			screenMsg.text = 'Away';
            external.setStatus('Away');
		}
	}
}