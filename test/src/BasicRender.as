package test {
	import com.barliesque.agal.EasierAGAL;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	//import flash.display3D.textures.Texture;
	
	
	/**
	 * A simple test shader that accepts xyz vertex data with rgb vertex colors.
	 * @author David Barlia
	 */
	public class BasicRender extends EasierAGAL {
		private var vertexBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		//private var texture3D:Texture;
		
		/// x, y, z, r, g, b
		public const DATA32_PER_VERTEX:uint = 6;
		
		
		public function BasicRender() {
			super(true);
		}
		
		
		override protected function _vertexShader():void {
			comment("Apply a 4x4 matrix to transform vertices to clip-space");
			multiply4x4(OUTPUT, ATTRIBUTE[0], CONST[0]);
			
			comment("Pass vertex color to fragment shader");
			move(VARYING[0], ATTRIBUTE[1]);
		}
		
		
		override protected function _fragmentShader():void {
			// Output the interpolated vertex color for this pixel
			move(OUTPUT, VARYING[0]);
			
			//comment("Use UV coordinates passed from vertex shader to sample the texture");
			//move(TEMP[0], VARYING[0]);
			//sampleTexture(TEMP[1], TEMP[0], SAMPLER[1], [TextureFlag.DIMENSIONS_2D, TextureFlag.MODE_CLAMP, TextureFlag.FILTER_LINEAR]);
			//move(OUTPUT, TEMP[1]);
		}
		
		
		//public function setGeometry(vertices:Vector.<Number>, indices:Vector.<uint>, textureBitmap:BitmapData):void {
		public function setGeometry(vertices:Vector.<Number>, indices:Vector.<uint>):void {
			// Upload vertex data
			if (vertexBuffer != null) vertexBuffer.dispose();
			vertexBuffer = context.createVertexBuffer(vertices.length / DATA32_PER_VERTEX, DATA32_PER_VERTEX);
			vertexBuffer.uploadFromVector(vertices, 0, vertices.length / DATA32_PER_VERTEX);
			
			// Upload polygon data (vertex indices)
			if (indexBuffer != null)  indexBuffer.dispose();
			indexBuffer = context.createIndexBuffer(indices.length);
			indexBuffer.uploadFromVector(indices, 0, indices.length);
			
/*			// Upload texture
			if (texture3D != null) texture3D.dispose();
			texture3D = context.createTexture(textureBitmap.width, textureBitmap.height, Context3DTextureFormat.BGRA, false);
			texture3D.uploadFromBitmapData(textureBitmap);
*/		}
		
		
		public function run(viewMatrix:Matrix3D):void {
			// Tell the 3D context that this is the current shader program to be rendered
			context.setProgram(program);
			
			// Set ATTRIBUTE Registers to point at vertex data
			context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // xyz
			context.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3); // rgb
			
			// Set SAMPLER Register
//			context.setTextureAt(1, textureBitmap);
			
			// Pass viewMatrix into constant registers
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewMatrix); // , true
			
			// Render the shader!
			context.drawTriangles(indexBuffer);
		}
		
		
		override public function dispose():void {
			//if (texture3D) {
				//texture3D.dispose();
				//texture3D = null;
			//}
			if (vertexBuffer) {
				vertexBuffer.dispose();
				vertexBuffer = null;
			}
			if (indexBuffer) {
				indexBuffer.dispose();
				indexBuffer = null;
			}
			super.dispose();
		}
		
		
	}
}


