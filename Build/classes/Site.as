package {

	public class Site {


		public static  const WIDTH:int =1680;
		public static  const HEIGHT:int =660;

		//intro
		public static  const INTRO_COMPLETE:String = "intro_complete";
		public static  const INTRO_CHANGE:String = "intro_change";

		//anim
		public static  const IN_COMPLETE:String = "in_complete";
		public static  const OUT_COMPLETE:String = "out_complete";

		public static  const PAGE_OUT_COMPLETE:String = "page_out_complete";
		public static  const PAGE_IN_COMPLETE:String = "page_in_complete";
		public static  const ANIM_ON:String = "anim_on";
		public static  const ANIM_OFF:String = "anim_off";

		public static  const SUB_OUT_COMPLETE:String = "sub_out_complete";
		public static  const SUB_IN_COMPLETE:String = "sub_in_complete";

		//count
		public static  const COUNTED:String="counted";

		//section change
		public static  const RETURN_HOME:String = "return_home";
		public static  const SEC_CHANGE:String = "sec_change";

		//form 
		public static  const FORM_ADDED:String = "form_added";
		public static  const FORM_REMOVED:String = "form_removed";
		public static  const RADIO_CLICKED:String="radio_clicked";
		public static  const DROP_CLICKED:String="drop_clicked";

		public static  const FORM_SENDING:String = "form_sengding";
		public static  const FORM_SENT:String = "form_sent";
		public static  const FORM_ERROR:String = "form_error";
		//hand cursor
		public static  const CURSOR_ON:String="cursor_on";
		public static  const CURSOR_OFF:String="cursor_off";

		//tips
		public static  const TIPS_ON:String="tips_on";
		public static  const TIPS_OFF:String="tips_off";

		//buttons and navs
		public static  const BTN_CLICKED:String="btn_clicked";
		public static  const NAV_ROLL_OVER:String="nav_rollover";
		public static  const NAV_ROLL_OUT:String="nav_rollout";
		public static  const NAV_CLICKED:String="nav_clicked";

		public static  const SUB_CLICKED:String="sub_clicked";
		public static  const BACK_CLICKED:String="back_clicked";

		//sound
		public static  const SOUND_TO_MUTE:String="sound_to_mute";
		public static  const SOUND_UN_MUTE:String="sound_un_mute";

		public static  const SOUND_TEMP_MUTE:String="sound_temp_mute";
		public static  const SOUND_UNTEMP_MUTE:String="sound_untemp_mute";

		//link
		public static  const LINKED:String="linked";


		//object preplace
		private static  var site_module:Object;
		private static  var buttonTypes:Array=new Array("go","submit","reset","set","download","link");
		private static  var linkTypes:Array=new Array("email");
		//variable preplace
		private static  var tips_string:String="";
		private static var lang_code:String="";
		private static var opera_code:Boolean=false;

		public function Site() {

		}
		//tips
		public static function get tips():String {
			return tips_string;
		}
		public static function set tips(txt:String) {
			tips_string=txt;
		}
		//button type
		public static function get getBtnTypes():Array {
			return buttonTypes;
		}
		//link type
		public static function get getLinkTypes():Array {
			return linkTypes;
		}
		//module
		public static function get module():Object {
			return site_module;
		}
		public static function set module(target:Object) {
			site_module=target;
		}
		//lang
		public static function get langCode():String {
			return lang_code;
		}
		public static function set langCode(str:String) {
			lang_code=str;
		}
		//lang
		public static function get Opera():Boolean {
			return opera_code;
		}
		public static function set Opera(b:Boolean) {
			opera_code=b;
		}
	}
}