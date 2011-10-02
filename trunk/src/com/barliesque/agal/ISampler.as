package com.barliesque.agal {
	
	/**
	 * Marks a register class as being a SAMPLER register
	 * @author David Barlia
	 */
	public interface ISampler extends IField {
		function get r():Component;
		function get g():Component;
		function get b():Component;
		function get a():Component;
		
		function get rgb():ComponentSelection;
	}
	
}