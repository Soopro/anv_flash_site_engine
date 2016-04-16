package comps{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import comps.loader.*;
	import tools.*;

	public class IconPiece extends Sprite {

		//Object preplace
		private var loader:ClipLoader=new ClipLoader();

		public function IconPiece() {
			this.mouseChildren=false;
			this.mouseEnabled=false;
		}
		public function setup(pm_src:String="",pm_w:int=0,pm_h:int=0):void {

			if (pm_src!="") {
				
				addListeners();
				loader.load(pm_src);
				
				addChild(loader);
				loader.alpha=0;
				this.addEventListener(Event.REMOVED,removed);
			}
		}
		private function loadingHandler(event:Event):void {

			switch (event.type) {
				case ClipLoader.LOAD_COMPLETE :
					addImage();
					break;
				case ClipLoader.ON_ERROR :
					//trace("error");
					break;
				case ClipLoader.ON_PROGRESS :
					//trace("progress");
					break;
				case ClipLoader.ON_SKIP :
					//trace("unloaded");
					break;
			}
			if (event.type!=ClipLoader.ON_PROGRESS) {
				removeListeners();
			}
		}
		private function addListeners():void {
			loader.addEventListener(ClipLoader.LOAD_COMPLETE,loadingHandler);
			loader.addEventListener(ClipLoader.ON_ERROR,loadingHandler);
			loader.addEventListener(ClipLoader.ON_PROGRESS,loadingHandler);
			loader.addEventListener(ClipLoader.ON_SKIP,loadingHandler);
		}
		private function removeListeners():void {
			loader.removeEventListener(ClipLoader.LOAD_COMPLETE,loadingHandler);
			loader.removeEventListener(ClipLoader.ON_ERROR,loadingHandler);
			loader.removeEventListener(ClipLoader.ON_PROGRESS,loadingHandler);
			loader.removeEventListener(ClipLoader.ON_SKIP,loadingHandler);
		}
		private function addImage():void {
			Anim.fadeIn(loader);
			loader.addClip();

		}

		private function removed(event:Event):void {
			if (event.target==this) {
				
				this.removeEventListener(Event.REMOVED,removed);
				
				loader.skipClip();
				removeListeners();

				for (var i:int=this.numChildren-1; i>=0; i--) {
					this.removeChildAt(0);
				}
			}
		}
	}
}