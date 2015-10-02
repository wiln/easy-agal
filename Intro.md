# Introducing EasyAGAL #

## AGAL made Easy? ##
I could never understand why assembly code is always written in what looks more like shorthand than a fully expressed language, considering whatever the name of an operation is, it'll be compiled down to a handful of bits understandable only to the CPU.  Mario Scabia is absolutely spot on likening it to the ancient hieroglyphics, in his [introduction to AGAL](http://iflash3d.com/shaders/my-name-is-agal-i-come-from-adobe-1/).

Learning how to work with matrices to achieve rendering effects is challenging enough without having to take on a new and strange programming language.  Given that there is no IDE especially for AGAL (at least for the time being!) I decided to write a small library that would assist me in writing AGAL programs, just as easily as writing ActionScript.  So, what does that mean?
  * Code completion and hinting
  * Far more easily readable code
  * Dynamic coding advantages


## Two Flavors:  Easy & Easier ##
Two base classes are provided for you to choose from:  _EasyAGAL.as_ which uses the original AGAL opcodes for function names, and _EasierAGAL.as_ which uses fully expressed function names.

Compare these corresponding samples:
```
	"m44 vt1, va2, vc8 \n" +
	"nrm vt1.xyz, vt1.xyz \n" +
	"sub vt2, vc12, vt0 \n" +
	"nrm vt2.xyz, vt2.xyz \n" +
	"dp3 vt3, vt1, vt2 \n" +
	"mov v2, vt3"
```
```
	// With EasyAGAL...

	m44( TEMP[1], ATTRIBUTE[2], CONST[8] );
	nrm( TEMP[1].xyz, TEMP[1].xyz );
	sub( TEMP[2], CONST[12], TEMP[0] );
	nrm( TEMP[2].xyz, TEMP[2].xyz );
	dp3( TEMP[3], TEMP[1], TEMP[2] );
	mov( VARYING[2], TEMP[3] );
```
```
	// or with EasierAGAL...

	multiply4x4( TEMP[1], ATTRIBUTE[2], CONST[8] );
	normalize( TEMP[1].xyz, TEMP[1].xyz );
	subtract( TEMP[2], CONST[12], TEMP[0] );
	normalize( TEMP[2].xyz, TEMP[2].xyz );
	dotProduct3( TEMP[3], TEMP[1], TEMP[2] );
	move( VARYING[2], TEMP[3] );
```

You'll notice that the EasyAGAL code simplifies the use of registers a bit --  depending on whether you're writing a vertex or a fragment shader, the appropriate register will automatically be used.  So, for example, you don't need to worry about `vt1` versus `ft1`, only `TEMP[1]` which will be translated appropriately.  We can make the EasyAGAL code more readable still, by assigning registers to variables with descriptive names:
```
	var normal:IRegister = ATTRIBUTE[2];
	var normalMatrix:IRegister = CONST[8];
	var xformedNorm:IRegister = TEMP[1];
	var intensity:IRegister = TEMP[2];
	
	multiply4x4( xformedNorm, normal, normalMatrix );
	normalize( xformedNorm.xyz, xformedNorm.xyz );
	subtract( intensity, CONST[12], TEMP[0] );
	normalize( intensity.xyz, intensity.xyz );
	dotProduct3( TEMP[3], TEMP[1], intensity );
	move( VARYING[2], TEMP[3] );
```


## Skeptical? ##
Some may say "PixelBender3D does the same thing…" ...which is actually quite inaccurate.  PixelBender3D is a high level language that is pre-compiled down to AGAL byte-code.  When writing AGAL from ActionScript (with or without the aid of this library) we have the oportunity to dynamically make some decisions about how the shader is written, e.g. whether to include vertex fogging, etc.  We can instantly rewrite the shader to include or exclude any number of options.  True, PixelBender3D was created as a friendlier alternative to AGAL, but at some cost to efficiency and outright hands-on control.

Others will say, "If you take the time to learn AGAL properly, you'll be able to read it more easily and you won't need any of this."  I expect that for many the hurdle of making sense out of the hieroglyphics of AGAL when first meeting the language will prove too much of an obstacle to progress beyond basic tutorials.  This library provides training wheels to learning AGAL.  I have not reinvented the language, but merely made it much easier to read and write, leveraging the features of our IDE's.  All methods of `EasyAGAL` and `EasierAGAL` maintain the same parameters, in the same order, as AGAL opcodes;  They are all documented with ASDoc tags providing help for every instruction and every register as you type.  The code-hints from EasierAGAL also include the original AGAL opcodes to help you learn them.

![http://studio.barliesque.com/images/easy-agal-code-hinting.png](http://studio.barliesque.com/images/easy-agal-code-hinting.png)


## Happy Trails ##
AGAL is not easy, but hopefully this library will make it easier, and assist your learning experience.  Read about [how to write macros](MacrosAndAliases.md) with EasyAGAL.  Also, here are some excellent links to tutorials and introductions to AGAL and the Molehill API:

[My Name is AGAL, and I Come from Adobe](http://iflash3d.com/shaders/my-name-is-agal-i-come-from-adobe-1/) by Marco Scabia

[Molehill - Getting Started](http://labs.jam3.ca/2011/03/molehill-getting-started/) by Mikko Haapoja

[Tutorials](http://pgstudios.org/tutorials.php) by Pixelante


**NOTE: [This project has moved to GitHub](https://github.com/Barliesque/EasyAGAL)**