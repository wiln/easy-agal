package com.barliesque.agal {
	
	/**
	 * Specialized register, for sampling textures
	 * 
	 * @author David Barlia
	 */
	internal class Sampler extends Register implements ISampler {
			 public function Sampler(reg:String) {
				 super("SAMPLER", null, reg);
			 }
	}
	
}