package rotationmenu.math{
	import rotationmenu.math.Math2;
	import flash.geom.Point;
	public class Ellipse {
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		public function Ellipse(w:Number,h:Number) {
			_width=w;
			_height=h;
		}
		public function get width():Number {
			return _width;
		}
		public function set width(w:Number):void {
			_width=w;
		}
		public function get height():Number {
			return _height;
		}
		public function set height(h:Number):void {
			_height=h;
		}
		public function getxy(angle:Number):Point {
			return new Point(getx(angle),gety(angle));
		}
		public function angle(y:Number,a:Number):Number {
			return Math2.atan2D(y,Math2.cosD(a) * _height);
		}
		public function yscale(y:Number,n1:Number=.5,n2:Number=1):Number {
			var _tmp_a=(y+2*_height)/_height-1;
			var _tmp_b=(n2-n1);
			return _tmp_a /1.2*_tmp_b + n1;
		}
		private function getx(angle:Number):Number {
			return _x=Math2.cosD(angle) * _width;
		}
		private function gety(angle:Number):Number {
			return _y=Math2.sinD(angle) * _height;
		}
	}
}