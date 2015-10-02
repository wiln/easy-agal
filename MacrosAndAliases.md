# Macros and Aliases #

In this article I'll show you how you can create and use a library of macro functions written with EasyAGAL.  The more macros we have to work with, the more AGAL can begin to feel like a higher level language.

In case the term is unfamiliar to you, a _macro_ is similar to a function in that it's a bit of code that gets used and re-used repeatedly.  The difference is that, where a function exists in one place in memory and is called by multiple points in an application, a macro is literally duplicated wherever it's needed at compile-time.  Presently, there is no way for AGAL to redirect program execution to call a function, or branch or loop -- AGAL programs are executed in a straight shot, from top to bottom.  So, in place of functions we must use macros.

Wherever you use a function from the Easy/EasierAGAL library, instructions are appended to whatever code is being assembled at the time.  So you can write a set of handy static functions in their own class, to be called as needed.  You can pass EasyAGAL registers as parameters, or any other data that may be useful to customize the macro.  And you can organize your macros along with the rest of your ActionScript classes into logical packages so they're nice and easy to find when you need them.

## Interface types ##

There is one important rule in writing macros with EasyAGAL:  you may not use any register that is not passed to your macro as a parameter.  This is a good rule to abide by because it means that the user of the macro retains control over how registers are used;  it helps to keep your macros as reusable as possible.  When you define function parameters, or alias variables, you have four data type options:

  * **`IRegister`** - Just as it sounds, this type specifies an AGAL register.  The whole register, that is, so `CONST[0]` is an `IRegister`, but `CONST[0].xyz` is not.  If the user of your macro tries to pass `VARYING[1].x` where an `IRegister` was specified, they'll get a compile error.

  * **`IComponent`** - Strictly a single component of a register.  `CONST[0].x` is an `IComponent`, but `CONST[0].xyz` and `CONST[0]` are not.

  * **`IField`** - This type specifies any AGAL register (except for texture samplers) -- either the whole register, or a selection of components.

  * **`ISampler`** - This type specifies a texture `SAMPLER` register.  Trying to pass `ATTRIBUTE[3]` to an `ISampler` parameter again results in a compile-time error.  No component selections of sampler registers are supported by AGAL.

So, for example, we can use ActionScript variables as aliases to AGAL registers, like so:

```
	var position:IRegister = ATTRIBUTE[0];
	var projection:IRegister = CONST[0];

	multiply4x4(OUTPUT, position, projection);
```

## A Simple Macro ##

Here's a really simple macro to set a register or component to zero:

```
	static public function setZero(dest:IField):void {
		// Subtract anything from itself and the result is always zero.
		subtract(dest, dest, dest);
	}
```

I used IField for the parameter type because this allows the macro to be applied either to whole registers or individual components.  Nothing is returned from the function, since its purpose is to append to the current shader code by calling the EasierAGAL command set.  You might wonder, "Why bother to write a macro when there's only one operation inside?"  Simply because it's clearer what the purpose of `setZero()` is compared to the subtraction statement.

Here's another macro function to clamp a value to a range:

```
	static function clamp(dest:IField, source:IField, minValue:IField, maxValue:IField):void {
		min(dest, source, maxValue);
		max(dest, dest, minValue);
	}
```

I've placed these two functions in a class called `Utils`, so I can now use them in any Easy/EasierAGAL shader code, like so...

```
	Utils.clamp(TEMP[2], TEMP[1], CONST[0], CONST[1]);
	Utils.zero(TEMP[2].w);
```

As if you didn't already know how to call a static function!  Anyway, you'll find these and more in the package:  com.barliesque.shaders.macro


## Other Parameter Types ##

Obviously, when writing macros you can specify whatever parameter types you want, not just AGAL registers.  Have a look at the parameter list of the following function, specifically the `comparison` parameter.

```
static public const EQUAL:String = "equal";
static public const NOT_EQUAL:String = "notEqual";
static public const LESS_THAN:String = "less";
static public const GREATER_THAN:String = "greater";
static public const LESS_OR_EQUAL:String = "lessOrEqual";
static public const GREATER_OR_EQUAL:String = "greaterOrEqual";

/**
 * Return one of two results, based on a comparison of two values, componentwise
 * dest = (operandA compared with operandB) ? trueResult : falseResult
 * Contains 5 to 8 instructions.
 * @param	comparison	The type of comparison, e.g. Utils.NOT_EQUAL
 * @param	temp		A temporary register that will be utilized for this operation
 */
static public function setByComparison(dest:IField, operandA:IField, comparison:String, operandB:IField, 
					trueResult:IField, falseResult:IField, temp:IRegister):void {

	// First make the requested comparison
	// and set the temporary to the inverse
	switch (comparison) {
		case LESS_OR_EQUAL:
			setIf_GreaterEqual(dest, operandB, operandA);
			setIf_LessThan(temp, operandB, operandA);
			break;

		case GREATER_OR_EQUAL:
			setIf_GreaterEqual(dest, operandA, operandB);
			setIf_LessThan(temp, operandA, operandB);
			break;

		case EQUAL:
			setIf_Equal(dest, operandA, operandB, temp);
			//  temp = 1 - dest
			setIf_GreaterEqual(temp, operandA, operandA);
			subtract(temp, temp, dest);
			break;

		case NOT_EQUAL:
			setIf_NotEqual(dest, operandA, operandB, temp);
			//  temp = 1 - dest
			setIf_GreaterEqual(temp, operandA, operandA);
			subtract(temp, temp, dest);
			break;

		case LESS_THAN:
			setIf_LessThan(dest, operandA, operandB);
			setIf_GreaterEqual(temp, operandA, operandB);
			break;

		case GREATER_THAN:
			setIf_LessThan(dest, operandB, operandA);
			setIf_GreaterEqual(temp, operandB, operandA);
			break;

		default:
			throw new Error("Unrecognized comparison type: " + comparison);
	}

	// Now apply result values to each...
	multiply(dest, dest, trueResult);
	multiply(temp, temp, falseResult);

	// ...and combine results
	add(dest, dest, temp);
}
```

So, now I can perform a comparison and get a result value in a single line...

```
	//
	// OUTPUT = (TEMP[1] <= CONST[0]) ? CONST[2] : CONST[3]
	//
	Utils.setByComparison(OUTPUT, TEMP[1], Utils.LESS_OR_EQUAL, CONST[0], CONST[2], CONST[3], TEMP[2]);
```

## Watch Your Operation Count ##

Do be careful how you use macros, however.  It's easy to forget that a single macro might produce dozens of operations.  Remember: There is a limit of 256 operations per shader program!  That's a pretty tight space to work in, but with multiple shader programs chained together, we can do just about anything.  You can keep a tab on your operations count by looking at the following properties in the EasyAGAL base class:

```
	trace("Operations in the vertex program: " + vertexInstructions);
	trace("Operations in the shader program: " + fragmentInstructions);
```

By the way, you can also access the generated opcode, with optional line numbering:

```
	trace("VERTEX SHADER:");
	trace(getVertexOpcode(true));
	trace("------------------");
	trace("FRAGMENT SHADER");
	trace(getFragmentOpcode(true));
```


**NOTE: [This project has moved to GitHub](https://github.com/Barliesque/EasyAGAL)**