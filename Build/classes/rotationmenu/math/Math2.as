//radian to replace angle
package rotationmenu.math{
	public final class Math2{

		public static  function angleToRadian(angle:Number):Number {
			return angle * Math.PI / 180;
		}
		//radian to angle
		public static  function radianToAngle(radian:Number):Number {
			return radian * 180 / Math.PI;
		}
		//angle only under 360
		public static  function fixAngle(angle:Number):Number {
			return angle%= 360 < 0?angle + 360:angle;
		}
		//trigonometric function by angle
		public static  function sinD(angle:Number):Number {
			return Math.sin(angleToRadian(angle));
		}
		public static  function cosD(angle:Number):Number {
			return Math.cos(angleToRadian(angle));
		}
		public static  function tanD(angle:Number):Number {
			return Math.tan(angleToRadian(angle));
		}
		//return angle
		public static  function asinD(radian:Number):Number {
			return radianToAngle(Math.acos(radian));
		}
		public static  function acosD(radian:Number):Number {
			return radianToAngle(Math.acos(radian));
		}
		public static  function atanD(radian:Number):Number {
			return radianToAngle(Math.acos(radian));
		}
		public static  function atan2D(y:Number,x:Number):Number {
			return radianToAngle(Math.atan2(y,x));
		}
	}
}