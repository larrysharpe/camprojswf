package com 
{
	/**
	 * ...
	 * @author Larry Sharpe
	 */
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ScreenMsg extends TextField
	{
		
		var format:TextFormat = new TextFormat();
		var arial:Arial = new Arial();		
		
		public function ScreenMsg(text:String, h:int = 30, w:int = 100, x:int = 0, y:int = 0, color:int = 0xFFFFFF, alpha:int = 1, background = null, align:String = 'CENTER') 
		{
			super();

			format.size = 24;
			format.align = TextFormatAlign[align];
			format.font = arial.fontName;
			
			
			this.defaultTextFormat = format;
			
			this.text = text;
			this.textColor = color;
			if (background){
				this.background = true;
				this.backgroundColor = background;
			}
			
			this.selectable = false;
			this.alpha = alpha;
			
			this.width = w;
			this.height = h;
			this.x = x;
			this.y = y;	
		}
		
	}

}