package poster{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Video;
	
	public class PosterClip extends MovieClip{
		Video
		//object preplace
		private var targetObj:Object=new Object;
		
		public function PosterClip(){
			this.addEventListener(Event.REMOVED,removed)
		}
		public function setup(obj:Object):void{
			
		}
		
		private function mouseHandler(event:MouseEvent):void{
			trace("Poster clip actived")
		}
		
		private function removed(event:Event):void{
			if(event.target==this){
				this.removeEventListener(Event.REMOVED,removed)
				
				//video.clear () 

				this.stop();
				//trace(targetObj)
				//trace("Poster clip removed")
			}
		}
		
	}
	
}