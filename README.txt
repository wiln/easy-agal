
EasyAGAL
by David Barlia,  david@barliesque.com
---------------------------------
https://github.com/Barliesque/EasyAGAL

EasyAGAL is an open source ActionScript library that assists developers in writing AGAL 
("Adobe Graphics Assembly Language") by providing an AS3-based pseudo-AGAL command 
set.  The resulting advantages include: 
	
	* Code completion and hinting
	* More easy-to-read code
	* Macros organized into libraries
	* Dynamic code customization
	
EasyAGAL provides training wheels to learning AGAL as well as a structural foundation for writing shaders 
for use with any other library. All methods of EasyAGAL maintain the same parameters, in the same order, 
as AGAL opcodes; They are all documented with ASDoc tags providing help for every instruction and register 
as you type, including the original AGAL opcodes.




CHANGE LOG __________________________________________________________________________________________________________


16.Oct.2011
- Changed register variables to static, so that only one set is needed for the entire project
- EasyBase.init() now does not get called if it's not needed.  If all shaders in a project use 
	setVertexOpcode() and setFragmentOpcode() in the constructor, none of EasyAGAL's
	registers need to be used, conserving memory.
	
15.Oct.2011
- Added RegisterType and support for obtaining types of registers from macros.
- Added two more blend modes to macro library Blend.as: lighterColor & darkerColor
- Replaced nextRegister.as which mysteriously disappeared!

4.Oct.2011
- Replaced Blend.softLight() with a formula that is a perfect match with Photoshop and is *far* more efficient
- setFragmentOpcode() and setVertexOpcode() now allow appending.  Instruction counting still not added.
- Retested all blend modes.  Minor updates to avoid possible "two constant parameters" error.
- Removed unsupported facility to select components of a SAMPLER register
- Fixed bugs in Blend.softLight() and Blend.hardLight() macros

3.Oct.2011
- Updated AGALMiniAssembler.as to current version!!!
- Removed verboseDebug as it is no longer an option in AGALMiniAssembler

2.Oct.2011
- added CONST_byIndex
- opcode and instruction count are available now before calling upload()
- shader upload errors now trigger a dump of the shader code with line numbers
- separated debug options in EasyBase constructor
- added interface IComponent to differentiate single components
- new macro Utils.selectByIndex()
