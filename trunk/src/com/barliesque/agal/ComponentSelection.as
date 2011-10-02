package com.barliesque.agal {
	/**
	 * A class allowing an arbitrary selection of register components to be passed as a parameter
	 * 
	 * @author David Barlia
	 */
	internal class ComponentSelection implements IField {
		
			protected var _name:String;
			private var _register:String;
			
			public function ComponentSelection(name:String, register:String, prop:String) {
				_name = name;
				this._register = register + ((register.indexOf(".") < 0) ? "." : "") + prop;
			}
			
			internal function get reg():String { 
				return _register;
			}
		
	}
}