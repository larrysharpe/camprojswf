package com.capitalmark 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Messenger 
	{
		
		public function Messenger() 
		{
			
		}
		
		public static function message(msg:String, status:String = null):void {
			//txt_msgBox.text = msg;
			
			var tracemsg:String = '>> ' + msg;
			if(status) tracemsg += ' >> '+status
			trace(tracemsg);
			
			//if (status == 'notice') txt_msgBox.textColor = 0xFFFFFF;
			//if (status == 'error') txt_msgBox.textColor = 0xFF5500;
			//if (status == 'success') txt_msgBox.textColor = 0x339933;			
		}
		
	}

}