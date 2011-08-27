package com.barliesque.agal {
	/**
	 * A class allowing register components to be passed as fields
	 * 
	 * @author David Barlia
	 */
	internal class Component implements IComponent {
			 
			 private var name:String;
			 private var register:String;
			 
			 public function Component(name:String, register:String, prop:String) {
				 this.name = name;
				 this.register = register + ((register.indexOf(".") < 0) ? "." : "") + prop;
			 }
			 
			 internal function get reg():String { 
				 return register;
			 }
			 
	}
}