package com.barliesque.agal {
	
	/**
	 * A Register with component values
	 * @author David Barlia
	 */
	public interface IRegister extends IField {
		function get x():Component;
		function get y():Component;
		function get z():Component;
		function get w():Component;
		
		function get r():Component;
		function get g():Component;
		function get b():Component;
		function get a():Component;
		
		function get xyz():Component;
		function get rgb():Component;
		
		/// Specify any register components, e.g. "zyx" "xxxx" "wwww" "rrb" "rg"
		function _(xyzwrgba:String):Component;
	}
	
}