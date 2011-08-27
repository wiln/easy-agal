package com.barliesque.agal {
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author David Barlia
	 */
	internal class EasyBase {
		
		private var _vertexOpcode:String;
		private var _fragmentOpcode:String;
		private var _vertexInstructions:uint = 0;
		private var _fragmentInstructions:uint = 0;
		private var _program:Program3D;
		private var _context:Context3D;
		
		// Register definitions
		internal var _ATTRIBUTE:Vector.<IRegister>;
		internal var _CONST:Vector.<IRegister>;
		internal var _TEMP:Vector.<IRegister>;
		internal var _OUTPUT:Register;
		internal var _VARYING:Vector.<IRegister>;
		internal var _SAMPLER:Vector.<Sampler>;
		internal var initialized:Boolean = false;
		
		public var debug:Boolean;
		
		//---------------------------------------------------------
		
		public function EasyBase() { }
		
		
		/// To be overridden.  Write your vertex shader here.
		/// If opcode has already been assigned to 'vertexOpcode' then that code will be used, and this function will not be called.
		protected function _vertexShader():void { }
		
		/// To be overridden.  Write your fragment shader here.
		/// If opcode has already been assigned to 'fragmentOpcode' then that code will be used, and this function will not be called.
		protected function _fragmentShader():void { }
		
		//---------------------------------------------------------
		
		/// A count of the number of instructions in the vertex shader
		public function get vertexInstructions():uint { return _vertexInstructions; }
		
		/// A count of the number of instructions in the fragment shader
		public function get fragmentInstructions():uint { return _fragmentInstructions; }
		
		/// Un-assembled AGAL instructions for the vertex shader
		public function get vertexOpcode():String { return _vertexOpcode; }
		protected function setVertexOpcode(value:String):void { _vertexOpcode = value; }
		
		/// Un-assembled AGAL instructions for the fragment shader
		public function get fragmentOpcode():String { return _fragmentOpcode; }
		protected function setFragmentOpcode(value:String):void { _fragmentOpcode = value; }
		
		/// The Program3D instance created by calling upload()
		public function get program():Program3D { return _program; }
		protected function setProgram(value:Program3D):void { _program = value; }
		
		/// The Context3D instance the shader program has been uploaded to.  Set by calling upload().  Cleared by calling dispose().
		public function get context():Context3D { return _context; }
		
		//---------------------------------------------------------
		
		/// @private  Prepare AGAL opcode to be passed to AGALMiniAssembler as the vertex program
		private function prepVertexShader():void {
			init();
			if (_vertexOpcode == null) {
				Assembler.prep(true, debug);
				_vertexShader();
				_vertexOpcode = Assembler.code;
				_vertexInstructions = Assembler.instructionCount;
			}
		}
		
		/// @private  Prepare AGAL opcode to be passed to AGALMiniAssembler as the fragment program
		private function prepFragmentShader():void {
			init();
			if (_fragmentOpcode == null) {
				Assembler.prep(false, debug);
				_fragmentShader();
				_fragmentOpcode = Assembler.code;
				_fragmentInstructions = Assembler.instructionCount;
			}
		}
		
		//------------------------------------------------------
		
		/**
		 * Assemble and upload the shader program.
		 * Note:  The shader will only be assembled and uploaded if the 'program' property of this instance is null.
		 * In order to reassemble and re-upload the program, dispose() should be called first.
		 * @param	context		The Context3D instance that will use this shader
		 * @return	Returns a reference to the Program3D instance
		 */
		public function upload(context:Context3D):Program3D {
			if (_program) return _program;
			_context = context;
			_program = context.createProgram();
			_program.upload(assembleVertex(), assembleFragment());
			return _program;
		}
		
		private function assembleVertex():ByteArray {
			prepVertexShader();
			return Assembler.assemble(_vertexOpcode, debug);
		}
		
		private function assembleFragment():ByteArray {
			prepFragmentShader();
			return Assembler.assemble(_fragmentOpcode, debug);
		}
		
		/// Release all resources, including the shader program uploaded to the GPU.
		public function dispose():void {
			if (_program) _program.dispose();
			_context = null;
			_program = null;
			_vertexOpcode = null;
			_vertexInstructions = 0;
			_fragmentOpcode = null;
			_fragmentInstructions = 0;
		}
		
		//------------------------------------------------------
		
		
		/// Add a comment to the opcode.  Helpful if you want to examine the opcode constructed by EasyAGAL.
		/// Commenting is disabled when EasyAGAL::debug is set to false.
		static protected function comment(remarks:String):void {
			// if (Assembler.assemblingDebug) {
				Assembler.append("\n// " + remarks, false);
			// }
		}
		
		//{ REGISTERS:  Initialization and Access
		
		private function init():void {
			if (initialized) return;
			var i:int;
			
			_ATTRIBUTE = new Vector.<IRegister>;
			for (i = 0; i < 8; i++)  _ATTRIBUTE.push(new Register("ATTRIBUTE", "va" + i, null));
			_ATTRIBUTE.fixed = true;
			
			_CONST = new Vector.<IRegister>;
			for (i = 0; i < 128; i++)  _CONST.push(new Register("CONST", "vc" + i, (i < 28) ? ("fc" + i) : null));
			_CONST.fixed = true;
			
			_TEMP = new Vector.<IRegister>;
			for (i = 0; i < 8; i++)  _TEMP.push(new Register("TEMP", "vt" + i, "ft" + i));
			_TEMP.fixed = true;
			
			_VARYING = new Vector.<IRegister>;
			for (i = 0; i < 8; i++)  _VARYING.push(new Register("VARYING", "v" + i, "v" + i));
			_VARYING.fixed = true;
			
			_SAMPLER = new Vector.<Sampler>;
			for (i = 0; i < 8; i++)  _SAMPLER.push(new Sampler("fs" + i));
			_SAMPLER.fixed = true;
			
			_OUTPUT = new Register("OUTPUT", "op", "oc");
			
			initialized = true;
		}
		
		
		/**
		 * [vc0-127 / fc0-27]  CONSTANT REGISTERS
		 * These hold values passed as parameters from ActionScript, using Context3D::setProgramConstants().
		 * There are 128 constants available to vertex shaders, but only 28 to fragment shaders.
		 */
		protected function get CONST():Vector.<IRegister> { return _CONST; }
		
		/**
		 * [vt0-7 / ft0-7]  TEMPORARY REGISTERS
		 * These registers can be used to temporarily store the results of calculations.
		 * There are 8 temporary registers available to vertex shaders, and another 8 to pixel shaders.
		 */
		 protected function get TEMP():Vector.<IRegister> { return _TEMP; }
		
		/**
		 * [va0-7]  VERTEX ATTRIBUTE BUFFER REGISTERS
		 * These registers hold up to eight different attributes of the current vertex
		 * being processed.  Vertex Attribute registers are only available in vertex shaders.
		 * Data is passed by ActionScript using the function Context3D::setVertexBufferAt().
		 * Attributes of a vertex will probably include position, as well as UV texture values, 
		 * vertex color, vertex normal, or any other information that your shader can make use of.
		 */
		 protected function get ATTRIBUTE():Vector.<IRegister> { return _ATTRIBUTE; }
		
		/**
		 * [op/oc]  OUTPUT REGISTER - Position or Color
		 * The output register is where the result of the shader must be stored.
		 * For vertex shaders, this output is the clip-space position of the vertex.
		 * For fragment shaders it is the color of the pixel.
		 * There is only one Output register for the vertex shader and one for the fragment shader.
		 */
		 protected function get OUTPUT():IRegister { return _OUTPUT; }
		 // For more about the clip-space coordinate system, see:  
		 // http://http.developer.nvidia.com/CgTutorial/cg_tutorial_chapter04.html
		
		/**
		 * [v0-7]  VARYING REGISTERS
		 * Used to pass data from the vertex shader to the fragment shader.
		 * When the fragment shader is run, these registers will contain interpolations
		 * of the values passed by the vertex shader for each vertex of the polygon
		 * of which the fragment is a part.
		 * There are 8 Varying registers, shared by both vector and fragment shaders.
		 */
		 protected function get VARYING():Vector.<IRegister> { return _VARYING; }
		
		/**
		 * [fs0-7]  FRAGMENT (TEXTURE) SAMPLER REGISTERS
		 * The Sampler registers are used to pick color values from textures,
		 * based on UV coordinates.  Texture images are passed from Actionscript with 
		 * the function Context3D::setTextureAt(index:uint, texture:BitmapData) where
		 * the index corresponds to the Fragment Sampler register number.
		 */
		 protected function get SAMPLER():Vector.<Sampler> { return _SAMPLER; }
		 
		//} -----------------------------------------------------------------		
		
	}
}

