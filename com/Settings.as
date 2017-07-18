package com {
     
	import flash.system.Capabilities;
	
    public class Settings {
        
        var appmode:String = 'broadcast';
        var broadcaster:String = 'performer1';
        var camMode:String = 'Public';
		var connecturl:String =  //'rtmp://localhost/videochat';
								'rtmp://54.152.198.195:1935/live';
		var loadedInfo:Object;
		var playerVersion:String;
		var uiMode:String = 'internal';
		var user:String = 'user1';
     
        public function Settings(loaderInfo:Object) {
            playerVersion = Capabilities.version + " (Flash-AS3)";
			this.loadedInfo = loaderInfo.parameters;
			if (this.loadedInfo.broadcaster) this.broadcaster = this.loadedInfo.broadcaster;
			if (this.loadedInfo.appmode) this.appmode = this.loadedInfo.appmode;
			if (this.loadedInfo.user) this.user = this.loadedInfo.user;			
        }
    
    }
}