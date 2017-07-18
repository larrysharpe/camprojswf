package com.capitalmark {
	
    import com.capitalmark.Settings;
	import com.capitalmark.UserInterface;
    
    import flash.display.Sprite;
	    
    public class ComeWatchLive extends Sprite {
		
		var settings;
		var ui;
			
		public function ComeWatchLive() {
			settings = new Settings(loaderInfo);			
			ui = new UserInterface(settings);
			addChild(ui);
		}
		
	
    }
	
}
