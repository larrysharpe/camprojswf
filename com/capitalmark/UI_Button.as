package com.capitalmark 
{
	
	
	import fl.controls.Button;
	
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Larry Sharpe
	 */
	public class UI_Button extends Button 
	{
		
		public function UI_Button(label:String, action = null, width:int = 100, height:int = 20, x:int = 0, y:int = 0 ) 
		{
			super();
			this.label = label;
			this.width = width;
			this.height = height;
			this.x = x;
			this.y = y;
			
			if (action) { this.addEventListener(MouseEvent.CLICK, action); }
			
		}
		
		
	}

}