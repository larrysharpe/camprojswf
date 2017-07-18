package com.capitalmark {
     
	import com.capitalmark.Messenger;
	
    import flash.media.Camera;
	import flash.media.Microphone;
    import flash.media.Video;
	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.utils.*
     
     
    public class WebCam extends Video {
     
        private var camera:Camera;
        private var camQuality:int = 80;
        private var fps:int = 30;
		private var camAllowed:Boolean;
		private var camTimeOut:int = 1000 * 60 * .5;
		private var camTimeOutId:uint;
		private var timeOutWarning:Boolean = false;
		private var timeOutCountDownId:uint;
		private var timeOutSeconds:int = 10;
		
		private var activityInitTimeout:uint;
		private var activityTimeOut:int = 1000 * 60 * .2;
		
		private var microphone:Microphone;
		
		private var connection:Connector;
		
		private var settings:Object;
         
        public function WebCam(settings:Object, w:Number = 640, h:Number = 480) {
			/* Set the width and height of the camera's display */
            this.width = w;
            this.height = h;
			this.settings = settings;
        }
		
		public function startWatching() {
			connection = new Connector(settings, camera, microphone);
			Messenger.message('start watching');
			connection.addEventListener(ConnectorEvent.ON_CONNECTFAIL, onConnectFail);
			connection.addEventListener(ConnectorEvent.ON_CONNECTSUCCESS, onConnectSuccess);
			connection.addEventListener(ConnectorEvent.ON_WATCHFAIL, onWatchFail);
			connection.addEventListener(ConnectorEvent.ON_WATCHSUCCESS, onWatchSuccess);			
			connection.connect();
		}
		
        public function startBroadcasting(e):void
        {
			
			dispatchEvent(new WebCamEvent('onConnectAttempt'));
			connection = new Connector(settings,camera,microphone);
			connection.addEventListener(ConnectorEvent.ON_CONNECTFAIL, onConnectFail);
			connection.addEventListener(ConnectorEvent.ON_CONNECTSUCCESS, onConnectSuccess);
			connection.addEventListener(ConnectorEvent.ON_PUBLISHFAIL, onPublishFail);
			connection.addEventListener(ConnectorEvent.ON_PUBLISHSUCCESS, onPublishSuccess);					
			connection.connect();
        }
		
		public function stopBroadcasting(e):void {
			this.attachCamera(null);
			this.clear();
			connection.disconnect();
			clearTimeout(camTimeOutId);
			clearInterval(timeOutCountDownId);			
			dispatchEvent(new WebCamEvent('onBroadcastingCancel'));
		}			
		
		/** Private Functions **/
		
			/** Event Monitors **/
			
				private function handleActivityTimeOut() {
					Messenger.message('Time out due to no initial activity. Cam may be in use by another application.', 'error');
					stopBroadcasting(0);
				}
			
				private function handleCamActivity(event:ActivityEvent):void {
					Messenger.message("activityHandler: " + event);
					if (!event.activating) {
						camTimeOutId = setTimeout(timeOutCamera, camTimeOut);
					} else {
						clearTimeout(activityInitTimeout);
						clearTimeout(camTimeOutId);
						clearInterval(timeOutCountDownId);
						if(timeOutWarning) dispatchEvent(new WebCamEvent('onTimeOutWarningCancel'));
					}
				}	
				
				private function handleCameraStatus(e:StatusEvent):void
				{
					switch (e.code)
					{
						case 'Camera.Muted':
						{
							camAllowed = false;
							Messenger.message("Camera muted");
							break;
						}
						case 'Camera.Unmuted':
						{
							camAllowed = true;
							Messenger.message("Camera unmuted");
							getLocalCamera();
							break;
						}
					}
				}				
		
			/** Events **/    	
				private function onConnectFail(e:ConnectorEvent) {
					this.attachCamera(null);
					this.clear();
					dispatchEvent(new WebCamEvent('onConnectFail'));			
				}
				
				private function onConnectSuccess(e:ConnectorEvent) {
					dispatchEvent(new WebCamEvent('onConnectSuccess'));	
					
					Messenger.message('On Connect success');
					if (settings.appmode == 'broadcast') { 
						activityInitTimeout = setTimeout(handleActivityTimeOut, activityTimeOut);
						getLocalCamera();
					}
					if (settings.appmode == 'watch') { 
						connection.watch();
					}
				}	
				
				private function onPublishFail(e:ConnectorEvent) {
					this.attachCamera(null);
					this.clear();
					dispatchEvent(new WebCamEvent('onPublishFail'));			
				}
				
				private function onPublishSuccess(e:ConnectorEvent) {
					Messenger.message('WebCam: Published Successfully');
					dispatchEvent(new WebCamEvent('onBroadcasting'));			
				}	

				private function onWatchFail(e:ConnectorEvent) {
					this.attachCamera(null);
					this.clear();
					dispatchEvent(new WebCamEvent('onWatchFail'));			
				}
				
				private function onWatchSuccess(e:ConnectorEvent) {
					Messenger.message('WebCam: Watching Successfully');
					dispatchEvent(new WebCamEvent('onWatchSuccess'));			
					this.attachNetStream(connection.watcher);
				}	
		
		
		private function getLocalCamera() {
			this.attachCamera(null);
			this.clear();
			camera = null;
			
            /* Get the default camera for the system */
            camera = Camera.getCamera();
			microphone = Microphone.getMicrophone();
			
			if( microphone != null){
				microphone.rate = 11;
				microphone.setSilenceLevel(0); 
			}
			
			if (camera != null) {
			   
				this.attachCamera(camera);
				Messenger.message('camera found');
		   
				if (camera.muted)
				{
					Messenger.message('camera muted');
					camera.addEventListener(StatusEvent.STATUS, handleCameraStatus, false, 0, true);
				}
				else
				{
					Messenger.message('camera not muted');
					camera.addEventListener(ActivityEvent.ACTIVITY, handleCamActivity);

					/* Set the bandwidth and camera image quality */
					camera.setQuality(0, camQuality);
					/* Set the size of the camera and frames per second */
					camera.setMode(this.width, this.height, fps);
					camera.setLoopback(true);
					camera.setMotionLevel(10);
					camera.setKeyFrameInterval(30);
					/* Attach the camera to the video object.. In this case the current class. */
					
					connection.broadcast();
					
				}
            } else {
                Messenger.message("You need a camera.");
            }			
		}
				
        		
		
		private function timeOutCamera(e = null) {
			timeOutWarning = true;
			dispatchEvent(new WebCamEvent('onTimeOutWarning'));
			timeOutCountDownId = setInterval(timeOutCameraCount, 1000);
		}
		
		private function timeOutCameraCount() {
			Messenger.message('timeOut Camera Count:' + timeOutSeconds);
			timeOutSeconds--;
			if (timeOutSeconds < 0) {
				clearInterval(timeOutCountDownId);
				stopCameraTimeOut();
				timeOutWarning = false;
			}
		}
		
		private function stopCameraTimeOut() {
			dispatchEvent(new WebCamEvent('onTimeOut'));
		}
		

		
    }
}