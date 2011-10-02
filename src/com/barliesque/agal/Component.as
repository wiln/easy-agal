package com.barliesque.agal {
	
	/**
	 * A class allowing single register component to be passed as parameters
	 * 
	 * @author David Barlia
	 */
	internal class Component implements IComponent {
		
		protected var _name:String;
		private var register:String;
		
		public function Component(name:String, register:String, prop:String) {
			_name = name;
			this.register = register + ((register.indexOf(".") < 0) ? "." : "") + prop;
		}
		
		internal function get reg():String { 
			return register;
		}
		
	}
}