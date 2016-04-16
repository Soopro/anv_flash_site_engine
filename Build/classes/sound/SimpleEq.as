package player{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;


	public class SimpleEq extends Sprite {


		private var size:uint;
		private var bgColor:uint;
		private var barNum:int;
		private var space:int;
		private var vol:Number=0;
		private var bit:Number=0;
		private var h_limit:int;
		
		private var barArray:Array;

		public function SimpleEq(h:int,num:int=10,sp:int=1,si:uint=1,bg:uint=0x999999) {
			h_limit=h;
			barNum=num;
			space=sp;
			size=si;
			bgColor=bg;
			barArray=[];
			for (var i:int=0; i<barNum; i++) {
				barArray[i]=new Sprite;
				draw(barArray[i]);
				addChild(barArray[i]);
				barArray[i].x=i*(space+size);
			}
			var timer:Timer=new Timer(100, 0);
			timer.addEventListener(TimerEvent.TIMER,showBar);
			timer.start();
		}
		private function showBar(event:TimerEvent):void {

			for (var i:int=0; i < barArray.length; i++) {
				if (bit!=0) {
					var _h:int=Math.random()*(Math.ceil(h_limit/2)+3*bit)*vol+1;
					barArray[i].height=_h;
				} else {
					barArray[i].height=1;
				}
				barArray[i].y=h_limit-barArray[i].height;
			}
		}
		private function draw(sprite:Sprite):void {
			sprite.graphics.beginFill(bgColor);
			sprite.graphics.drawRect(0, 0, size, size);
			sprite.graphics.endFill();
		}
		
		//set property 
		public function set setVol(v:Number):void {
			vol=v;
		}
		public function set setBit(b:Number):void {
			bit=b;
		}

	}
}