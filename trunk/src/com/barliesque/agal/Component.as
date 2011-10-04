package com.barliesque.agal {
	
	/**
	 * A class allowing single register component to be passed as parameters
	 * 
	 * @author David Barlia
	 */
	internal class Component implements IComponent {
		
		private var _register:String;
		
		public function Component(register:Register, prop:String) {
			_register = register.reg + "." + prop;
			
			if (!valid(prop)) throw new Error("c15 Illegal component selection: " + _register);  // This is possible:  CONST[0]._("q")
		}
		
		internal function get reg():String { 
			return _register;
		}
		
		static public function valid(prop:String):Boolean {
			switch(prop) {
				case "x":	case "y":	case "z":	case "w":	
				case "r":	case "g":	case "b":	case "a":
					return true;
			}
			return false;
		}
		
	}
}