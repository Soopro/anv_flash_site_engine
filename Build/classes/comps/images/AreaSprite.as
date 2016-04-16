package comps.images{
	import flash.display.Sprite;

	public class AreaSprite extends Sprite {


		//object preplace
		private var child:Sprite = new Sprite();

		//variable preplace

		public function AreaSprite(w:int=0,h:int=0,px:int=0,py:int=0) {

			child.mouseEnabled=false;
			this.mouseChildren=false;
			this.alpha=0;
			draw(child)
			addChild(child);
			set(w,h,px,py)
		}
		private function draw(sprite:Sprite):void {
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawRect(0, 0, 1, 1);
			sprite.graphics.endFill();
		}
		public function set(w:int=0,h:int=0,px:int=0,py:int=0):void {

			this.width=w;
			this.height=h;
			this.x=px;
			this.y=py;
		}
	}
}