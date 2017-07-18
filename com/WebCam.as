package com
{
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author Larry Sharpe
	 */
	public class WebCam extends EventDispatcher
	{
		var camera:Camera;
		var camAllowed:Boolean = false;
		var microphone:Microphone;
		var vid:Video = new Video;
		
		public function WebCam()
		{
		}
		
		function start()
		{
			vid.clear();
			
			// get the default Flash camera and microphone
			camera = Camera.getCamera();
			microphone = Microphone.getMicrophone();
			
			vid.attachCamera(camera);
			
			if (camera != null)
			{
				if (camera.muted)
					camera.addEventListener(StatusEvent.STATUS, handleCameraStatus, false, 0, true);
				else
				{
					camera.setMode(240, 180, 15, false);
					camera.setQuality(0, 100);
					camera.setKeyFrameInterval(30);
				}
			}
			
			if (microphone != null)
			{
				microphone.rate = 11;
				microphone.setSilenceLevel(0);
			}
		}
		
		function stop() {
		   vid.attachCamera(null);
		   vid.clear();
		}
		
		private function handleCameraStatus(e:StatusEvent):void
		{
			switch (e.code)
			{
				case 'Camera.Muted': 
				{
					camAllowed = false;
					dispatchEvent(new WebCamEvent('onCamDenied'));
					break;
				}
				case 'Camera.Unmuted': 
				{
					camAllowed = true;
					dispatchEvent(new WebCamEvent('onCamAccepted'));
					start();
					break;
				}
			}
		}
	
	}

}