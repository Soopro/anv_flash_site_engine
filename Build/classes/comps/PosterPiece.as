package comps{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import comps.images.*;
	import comps.loader.*;
	import tools.*;


	public class PosterPiece extends Sprite {

		//Object preplace
		private var loader:ClipLoader=new ClipLoader;
		private var loader_ui:ClipLoaderUI=new ClipLoaderUI;
		private var outline:ImageOutline=new ImageOutline;
		private var mask_area:AreaSprite=new AreaSprite;
		private var poster_Rect:Rectangle=new Rectangle;

		//variable preplace


		public function PosterPiece() {
			this.mouseEnabled=false;
		}
		public function setup(pm_xml:XML=null):void {
			if (pm_xml != null) {
				poster_Rect=new Rectangle(pm_xml.@x,pm_xml.@y,pm_xml.@w,pm_xml.@h);

				addChild(mask_area);

				mask_area.set(poster_Rect.width - ImageOutline.getBorder*2,poster_Rect.height - ImageOutline.getBorder*2,ImageOutline.getBorder,ImageOutline.getBorder);

				addChild(outline);

				if (pm_xml.@border != 0) {
					outline.setup(poster_Rect.width,poster_Rect.height);
					outline.visible=true;
				} else {
					outline.visible=false;
				}

				if (pm_xml.@src != "") {
					
					addListeners();
					loader.load(pm_xml.@src);
					
					addChildAt(loader_ui,1);
					addChildAt(loader,0);
					loader.alpha=0;
					loader.mask=mask_area;
					Align.heart(loader_ui,mask_area)
				}
				setPos();
				Anim.fadeIn(this);
				this.addEventListener(Event.REMOVED,removed);
			}
		}
		private function setPos():void {
			this.x=poster_Rect.x;
			this.y=poster_Rect.y;
		}
		private function loadingHandler(event:Event):void {

			switch (event.type) {
				case ClipLoader.LOAD_COMPLETE :
					removeChild(loader_ui);
					addPoster();
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
			if (event.type != ClipLoader.ON_PROGRESS) {
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
		private function addPoster():void {
			Anim.fadeIn(loader);
			loader.addClip();
		}
		private function removed(event:Event):void {
			if (event.target == this) {
				this.removeEventListener(Event.REMOVED,removed);
				loader.skipClip();
				removeListeners();

				for (var i:int=this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(0);
				}		
			}
		}
	}
}