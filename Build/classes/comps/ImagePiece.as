package comps{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import comps.images.*;
	import comps.loader.*;
	import tools.*;

	public class ImagePiece extends Sprite {

		//Object preplace
		private var loader:ClipLoader=new ClipLoader();
		private var loader_ui:ClipLoaderUI=new ClipLoaderUI();
		private var outline:ImageOutline=new ImageOutline();
		private var img_rollover:ImageRollOver=new ImageRollOver();
		private var mask_area:AreaSprite=new AreaSprite();

		//variable preplace
		private var listenerCheck:Boolean=false;

		public function ImagePiece() {
			this.mouseEnabled=false;
			listenerCheck=false;
		}
		public function setup(pm_src:String="",pm_border:int=1,pm_w:int=0,pm_h:int=0):void {
			if (pm_src!="") {
				addChild(mask_area);
				addChild(img_rollover);

				mask_area.set(pm_w-ImageOutline.getBorder*2,pm_h-ImageOutline.getBorder*2,ImageOutline.getBorder,ImageOutline.getBorder);
				Align.same(mask_area,img_rollover);

				addChild(outline);

				if (pm_border!=0) {
					outline.setup(pm_w,pm_h);
					outline.visible=true;
					img_rollover.visible=true;
				} else {
					outline.visible=false;
					img_rollover.visible=false;
				}
				
				addListeners();
				loader.load(pm_src);
				
				addChildAt(loader_ui,1);
				addChildAt(loader,0);
				loader.alpha=0;
				loader.mask=mask_area;
				Align.heart(loader_ui,mask_area)

				this.addEventListener(Event.REMOVED,removed);
			}
		}
		private function loadingHandler(event:Event):void {

			switch (event.type) {
				case ClipLoader.LOAD_COMPLETE :
					removeChild(loader_ui);
					addImage();
					break;
				case ClipLoader.ON_ERROR :
					loader_ui.setError();
					break;
				case ClipLoader.ON_PROGRESS :
					loader_ui.setPercent(loader.getPercent);
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
			addEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			addEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			listenerCheck=true;
		}
		private function mouseHandler(event:MouseEvent):void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER :
					img_rollover.animOver();
					break;
				case MouseEvent.ROLL_OUT :
					img_rollover.animOut();
					break;
			}
		}
		private function removed(event:Event):void {
			if (event.target==this) {
				
				this.removeEventListener(Event.REMOVED,removed);
				
				loader.skipClip();
				removeListeners();

				for (var i:int=this.numChildren-1; i>=0; i--) {
					this.removeChildAt(0);
				}
				if (listenerCheck) {
					removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
					removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
					listenerCheck=false;
				}
			}
		}
	}
}