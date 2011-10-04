package com.barliesque.agal {
	
	/**
	 * Specialized register, for sampling textures
	 * 
	 * @author David Barlia
	 */
	internal class Sampler implements ISampler {
		
		private var _register:String;
		
		public function Sampler(register:String) {
			this._register = register;
		}
		
		internal function get reg():String { 
			if (Assembler.assemblingVertex) throw new Error("SAMPLER registers not available in Vertex Shaders");
			return _register;
		}
		
	}
}