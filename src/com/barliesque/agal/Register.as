package com.barliesque.agal {
	
	/**
	 * Registers contain four floating point component values which can be accessed as either <x,y,z,w> for vertices, or <r,g,b,a> for pixels.
	 * @author David Barlia
	 */
	internal class Register implements IRegister {
			
			private var _vertexReg:String;
			private var _fragmentReg:String;
			private var _name:String;
			private var _index:int;
			
			public function Register(name:String, vertexReg:String, fragmentReg:String, index:int = -1) {
				_name = name;
				_vertexReg = vertexReg;
				_fragmentReg = fragmentReg;
				_index = index;
			}
			
			internal function get reg():String { 
				var code:String = (Assembler.assemblingVertex ? _vertexReg : _fragmentReg) + ((_index >= 0) ? _index : "");
				if (code == null) {
					throw new Error(_name + " register not available in " + (Assembler.assemblingVertex ? "Vertex Shaders" : "Fragment Shaders"));
				}
				return code;
			}
			
			internal function get type():String { return _name; }
			internal function get name():String { return _name; }
			internal function get vertexReg():String { return _vertexReg; }
			internal function get fragmentReg():String { return _fragmentReg; }
			internal function get index():int { return _index; }
			
			public function get x():Component { return new Component(this, "x"); }
			public function get y():Component { return new Component(this, "y"); }
			public function get z():Component { return new Component(this, "z"); }
			public function get w():Component { return new Component(this, "w"); }
			
			public function get r():Component { return new Component(this, "r"); }
			public function get g():Component { return new Component(this, "g"); }
			public function get b():Component { return new Component(this, "b"); }
			public function get a():Component { return new Component(this, "a"); }
			
			public function get xyz():ComponentSelection { return new ComponentSelection(this, "xyz"); }
			public function get rgb():ComponentSelection { return new ComponentSelection(this, "rgb"); }
			
			
			
			public function _(components:String):IField { 
				if (components.length == 1) {
					return new Component(this, components.toLowerCase());
				} else {
					return new ComponentSelection(this, components.toLowerCase());
				}
			}
	}
	

}