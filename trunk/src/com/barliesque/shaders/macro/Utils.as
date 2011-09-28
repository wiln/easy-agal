package com.barliesque.shaders.macro {
	import com.barliesque.agal.EasierAGAL;
	import com.barliesque.agal.IField;
	import com.barliesque.agal.IRegister;
	
	/**
	 * Utility functions to include in shader code
	 * 
	 * @author David Barlia, barliesque@gmail.com
	 */
	public class Utils extends EasierAGAL {
		
		
		static public const EQUAL:String = "equal";
		static public const NOT_EQUAL:String = "notEqual";
		static public const LESS_THAN:String = "less";
		static public const GREATER_THAN:String = "greater";
		static public const LESS_OR_EQUAL:String = "lessOrEqual";
		static public const GREATER_OR_EQUAL:String = "greaterOrEqual";
		
		
		/**
		 * Return one of two results, based on a comparison of two values, componentwise
		 * dest = (operandA compared with operandB) ? trueResult : falseResult
		 * @param	comparison	The type of comparison, e.g. Utils.NOT_EQUAL
		 * @param	temp		A temporary register that will be utilized for this operation
		 * @param	temp2		A temporary register that will be utilized for this operation
		 */
		static public function setByComparison(dest:IField, operandA:IField, comparison:String, operandB:IField, trueResult:IField, falseResult:IField, temp:IRegister):void {
			
			// First make the requested comparison
			switch (comparison) {
				case LESS_OR_EQUAL:
					setIf_GreaterEqual(dest, operandA, operandB);
					setIf_GreaterEqual(temp, operandB, operandA);
					min(dest, dest, temp);  // Combine results (AND)
					setIf_LessThan(temp, operandA, operandB);
					max(dest, dest, temp);  // Combine results (OR)
					break;
					
				case GREATER_OR_EQUAL:
					setIf_GreaterEqual(dest, operandA, operandB);
					break;
					
				case EQUAL:
					setIf_Equal(dest, operandA, operandB, temp);
					break;
					
				case NOT_EQUAL:
					setIf_NotEqual(dest, operandA, operandB, temp);
					break;
					
				case LESS_THAN:
					setIf_LessThan(dest, operandA, operandB);
					break;
					
				case GREATER_THAN:
					setIf_LessThan(dest, operandA, operandB);
					setIf_LessThan(temp, operandB, operandA);
					max(dest, dest, temp);  // Combine results (OR) ...If either is true, A and B are not equal
					setIf_GreaterEqual(temp, operandA, operandB);
					min(dest, dest, temp);  // Combine results (AND) ...If both are true, A > B
					break;
					
				default:
					throw new Error("Unrecognized comparison type: " + comparison);
			}
			
			// Set the temporary to the inverse of the comparison
			setOne(temp);
			subtract(temp, temp, dest);  //  temp = 1 - dest
			
			// Now apply result values to each
			multiply(dest, dest, trueResult);
			multiply(temp, temp, falseResult);
			
			// ...and combine results
			add(dest, dest, temp);
		}
		
		
		/**
		 * Sets the specified register or component selection to zero.
		 * @param	dest	A register or component selection to be set to zero.
		 */
		static public function setZero(dest:IField):void {
			// Subtract anything from itself and the result is always zero.
			subtract(dest, dest, dest);
		}
		
		
		/**
		 * Sets the specified register or component selection to 1.0
		 * @param	dest	A register or component selection to be set to 1.0
		 */
		static public function setOne(dest:IField):void {
			// Is (dest == dest)?  Of course!  So result is always 1.0
			setIf_GreaterEqual(dest, dest, dest);
		}
		
		
		/**
		 * Set the component values of a register as follows: {x: 2.0, y: 1.0, z: 0.0, w: 0.5}
		 * @param	dest	A register whose components will set to handy constant values
		 */
		static public function setTwoOneZeroHalf(dest:IRegister):void {
			setZero(dest.z);						// z = zero
			setOne(dest.y);							// y = one
			add(dest.x, dest.y, dest.y);			// x = two
			divide(dest.w, dest.y, dest.x);			// w = half
		}
		
		
		/**
		 * Clamp a value to a specified range.  Componentwise.
		 * @param	dest		Destination register for the resulting value
		 * @param	source		The value to be clamped
		 * @param	minValue	The minimum value
		 * @param	maxValue	The maximum value
		 */
		static public function clamp(dest:IField, source:IField, minValue:IField, maxValue:IField):void {
			min(dest, source, maxValue);
			max(dest, dest, minValue);
		}
		
		
		/**
		 * Find the length of the source vector
		 * @param	dest		Destination register for the resulting value
		 * @param	source		A 3-component vector whose length will be calculated
		 */
		static public function length(dest:IField, source:IRegister):void {
			dotProduct3(dest, source, source);
			squareRoot(dest, dest);
		}
		
		
		/**
		 * Find the distance between two vertices
		 * @param	dest		Destination register for the resulting value
		 * @param	source1		A 3-component vertex
		 * @param	source2		A 3-component vertex
		 */
		static public function distance(dest:IField, source1:IRegister, source2:IRegister):void {
			subtract(dest, source2, source1);
			dotProduct3(dest, dest, dest);
			squareRoot(dest, dest);
		}
		
		
	}
}