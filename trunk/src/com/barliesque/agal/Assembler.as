package com.barliesque.agal {
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author David Barlia
	 */
	public class Assembler {
		
		static private var _debug:AGALMiniAssembler;
		static private var _release:AGALMiniAssembler;
		
		/// Static variable for AGAL instructions to be appended by EasyAGAL classes
		static internal var code:String;
		
		/// Count of instructions appended to code
		static internal var instructionCount:int;
		
		/// Internal flag set while preparing opcode.  True for VertexShader, False for FragmentShader.
		static public var assemblingVertex:Boolean;
		
		/// Internal flag set while preparing opcode.  True for debug mode, False for release.
		static public var assemblingDebug:Boolean;
		
		/// Prepare to assemble a new shader program
		static internal function prep(assemblingVertex:Boolean, assemblingDebug:Boolean):void {
			code = "";
			instructionCount = 0;
			Assembler.assemblingVertex = assemblingVertex;
			Assembler.assemblingDebug = assemblingDebug;
		}
		
		/// Append a line of opcode to the shader currently being built, and count lines
		static internal function append(code:String, count:Boolean = true):void {
			Assembler.code += code + "\n";
			if (count) instructionCount++;
		}
		
		/// Compile opcode string to a ByteArray ready to be uploaded with Program3D.
		/// NOTE: Assembler.assemblingVertex should already have been appropriately set.
		static public function assemble(opcode:String, verbose:Boolean = false):ByteArray {
			var type:String = (assemblingVertex ? Context3DProgramType.VERTEX : Context3DProgramType.FRAGMENT);
			if (assemblingDebug) {
				return Assembler.debug.assemble(type, opcode, verbose);
			}
			return release.assemble(type, opcode, verbose);
		}
		
		/// An AGALMiniAssembler instance with debug features on.
		static internal function get debug():AGALMiniAssembler {
			if (_debug == null) _debug = new AGALMiniAssembler(true);
			return _debug;
		}
		
		/// An AGALMiniAssembler instance with debug features off.
		static internal function get release():AGALMiniAssembler {
			if (_release == null) _release = new AGALMiniAssembler(false);
			return _release;
		}
		
	}
}