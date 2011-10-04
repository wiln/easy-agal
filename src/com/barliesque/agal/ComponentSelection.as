package com.barliesque.agal {
	/**
	 * A class allowing an arbitrary selection of register components to be passed as a parameter
	 * 
	 * @author David Barlia
	 */
	internal class ComponentSelection implements IField {
		
		private var _register:String;
		
		public function ComponentSelection(register:Register, prop:String) {
			_register = register.reg + ((prop.length > 0) ? ("." + prop) : "");
			
			// Validate components
			//if (Assembler.assemblingDebug) {
				if (prop.length > 4) throw new Error("s16 Illegal component selection: " + _register);  // This is possible:  CONST[0]._("rgbar")
				for (var i:int = 0; i < prop.length; i++ ) {
					if (!Component.valid(prop.substr(i,1))) throw new Error("s18 Illegal component selection: " + _register);  // This is possible:  CONST[0]._("foo")
				}
			//}
		}
		
		internal function get reg():String { 
			return _register;
		}
		
	}
}