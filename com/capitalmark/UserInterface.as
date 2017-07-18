package com.capitalmark 
{
	
	import com.capitalmark.Messenger;
	import com.capitalmark.Text;
	import com.capitalmark.UI_Button;		
	import com.capitalmark.WebCam;
	import flash.display.Sprite;
		
	/**
	 * ...
	 * @author Larry Sharpe
	 */
	public class UserInterface extends Sprite 
	{
		var cam;
		var settings;
		
		/*
		var txt_msgBox2 = new Text('hello',30,600,0,75);
		var txt_msgBox3 = new Text('hello',30,600,0,100);
		var txt_msgBox4 = new Text('hello',30,600,0,125);
		*/
		
		var txt_msgBox = new Text('yo yo yo',30,600,0,25);
		var txt_statusBox;
		var btn_broadcast;
		var btn_stopbroadcast;
		var btn_cancelconnect;
		
		public function UserInterface(settings):void 
		{
			super();
			this.settings = settings;
			addCam();
			
			/*
			addChild(txt_msgBox2);
			addChild(txt_msgBox3);
			addChild(txt_msgBox4);
			txt_msgBox2.text = settings.loadedInfo.appmode;
			txt_msgBox3.text = settings.loadedInfo.broadcaster;
			txt_msgBox4.text = settings.loadedInfo.user;
			*/
			
			if(this.settings.appmode == 'broadcast') addButtons();
		}

		/** Private Functions **/
			private function addButtons():void {
				Messenger.message('Initializing Controls');			
				btn_broadcast = new UI_Button("Broadcast",cam.startBroadcasting);
				btn_stopbroadcast = new UI_Button("Stop Broadcasting", cam.stopBroadcasting, 120);
				btn_cancelconnect = new UI_Button("Cancel Connection",cam.stopBroadcasting,120);
				switchButtons(btn_broadcast);
			}
			
			private function addCam():void {			
				Messenger.message('Initializing Video');
				cam = new WebCam(this.settings);
				
				if(this.settings.appmode == 'broadcast')  {
					cam.addEventListener(WebCamEvent.ON_BROADCASTING,uiOnBroadcasting);
					cam.addEventListener(WebCamEvent.ON_BROADCASTINGCANCEL,uiOnBroadcastingCancel);
					cam.addEventListener(WebCamEvent.ON_CONNECTATTEMPT,uiOnConnectAttempt);
					cam.addEventListener(WebCamEvent.ON_CONNECTFAIL,uiOnConnectFail);
					cam.addEventListener(WebCamEvent.ON_CONNECTSUCCESS, uiOnConnectSuccess);
					cam.addEventListener(WebCamEvent.ON_PUBLISHFAIL,uiOnPublishFail);
					cam.addEventListener(WebCamEvent.ON_PUBLISHSUCCESS,uiOnPublishSuccess);			
					cam.addEventListener(WebCamEvent.ON_TIMEOUT, uiOnTimeOut);
					cam.addEventListener(WebCamEvent.ON_TIMEOUTWARNING,uiOnTimeOutWarning);
					cam.addEventListener(WebCamEvent.ON_TIMEOUTWARNINGCANCEL, uiOnTimeOutWarningCancel);
				}
				else if (this.settings.appmode == 'watch') {
					cam.startWatching();
					cam.addEventListener(WebCamEvent.ON_WATCHSUCCESS,uiOnWatchSuccess);
				}
			}		
			
			private function switchButtons(show:UI_Button):void {
				if(btn_broadcast.stage)removeChild(btn_broadcast);
				if(btn_stopbroadcast.stage)removeChild(btn_stopbroadcast);
				if(btn_cancelconnect.stage)removeChild(btn_cancelconnect);
				addChild(show);
			}
			
			/** Events **/
				private function uiOnBroadcasting(e:WebCamEvent):void {
					Messenger.message('Broadcasting: '+settings.camMode+' mode', 'success');
					switchButtons(btn_stopbroadcast);
					addChildAt(cam, 0);			
				}
				
				private function uiOnBroadcastingCancel(e:WebCamEvent):void {
					if (cam.stage) removeChild(cam);
					switchButtons(btn_broadcast);
					Messenger.message('Offline', 'notice');
				}
				
				private function uiOnConnectAttempt(e:WebCamEvent):void {
					Messenger.message('Connecting to our server', 'notice');			
					switchButtons(btn_cancelconnect);
				}
				
				private function uiOnConnectFail(e:WebCamEvent):void {
					Messenger.message('Could not connect to server.','error');
					cam.stopCamera(0);			
				}
				
				private function uiOnConnectSuccess(e:WebCamEvent):void {
					Messenger.message('Connected to our server', 'notice');
				}
				
				private function uiOnPublishFail(e:WebCamEvent):void {
					Messenger.message('Could Not Publish', 'error');
					cam.stopCamera(0);			
				}
				
				private function uiOnPublishSuccess(e:WebCamEvent):void {
					Messenger.message('Published', 'notice');			
				}
				
				private function uiOnTimeOut(e:WebCamEvent):void {
					Messenger.message('Cam Timed Out', 'error'); 
					cam.stopCamera(0);
				}

				private function uiOnTimeOutWarning(e:WebCamEvent):void {
					Messenger.message('Are You There?', 'error');
				}
				
				private function uiOnTimeOutWarningCancel(e:WebCamEvent):void {
					// --- message('Could Not Publish', 'error');
				}
				
				private function uiOnWatchSuccess(e:WebCamEvent):void {
					Messenger.message('Watching');
					addChildAt(cam, 0);
				}
		
	}

}