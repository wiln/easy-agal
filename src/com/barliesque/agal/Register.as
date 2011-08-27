package com.barliesque.agal {
	
	/**
	 * Registers contain four floating point component values which can be accessed as either <x,y,z,w> for vertices, or <r,g,b,a> for pixels.
	 * @author David Barlia
	 */
	internal class Register implements IRegister {
			
			protected var vertexReg:String;
			protected var fragmentReg:String;
			protected var _name:String;
			
			public function Register(name:String, vertexReg:String, fragmentReg:String) {
				_name = name;
				this.vertexReg = vertexReg;
				this.fragmentReg = fragmentReg;
			}
			
			//override flash_proxy function getProperty(name:*):* {
				//return new Component(this.name, reg, name);
			//}
			
			internal function get reg():String { 
				var code:String = Assembler.assemblingVertex ? vertexReg : fragmentReg;
				if (code == null) {
					throw new Error("Register " + name + " not available in " + (Assembler.assemblingVertex ? "Vertex Shaders" : "Fragment Shaders"));
				}
				return code;
			}
			
			internal function get name():String {
				return _name;
			}
			
			public function get x():Component { return new Component(name, reg, "x"); }
			public function get y():Component { return new Component(name, reg, "y"); }
			public function get z():Component { return new Component(name, reg, "z"); }
			public function get w():Component { return new Component(name, reg, "w"); }
			
			public function get r():Component { return new Component(name, reg, "r"); }
			public function get g():Component { return new Component(name, reg, "g"); }
			public function get b():Component { return new Component(name, reg, "b"); }
			public function get a():Component { return new Component(name, reg, "a"); }
			
			public function get xyz():Component { return new Component(name, reg, "xyz"); }
			public function get rgb():Component { return new Component(name, reg, "rgb"); }
			
			public function _(components:String):Component { return new Component(name, reg, components); }
	}
	

}