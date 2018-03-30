import Texture from './Texture';
import {gl} from '../../globals';
import ShaderProgram, {Shader} from './ShaderProgram';
import Drawable from './Drawable';
import Square from '../../geometry/Square';
import {vec3, vec4, mat4} from 'gl-matrix';

class PostProcess extends ShaderProgram {
	static screenQuad: Square = undefined; // Quadrangle onto which we draw the frame texture of the last render pass
	unifFrame: WebGLUniformLocation; // The handle of a sampler2D in our shader which samples the texture drawn to the quad
	unifPreFrame: WebGLUniformLocation;
	unifHighpass: WebGLUniformLocation; // The handle of a sampler2D in our shader which samples the texture drawn to the quad
	name: string;

	constructor(fragProg: Shader, tag: string = "default") {
		super([new Shader(gl.VERTEX_SHADER, require('../../shaders/screenspace-vert.glsl')),
			fragProg]);

		this.unifFrame = gl.getUniformLocation(this.prog, "u_frame");
		this.unifPreFrame = gl.getUniformLocation(this.prog, "u_preframe");
		this.unifHighpass = gl.getUniformLocation(this.prog, "u_highpass");
		this.use();
		this.name = tag;

		// bind position to this location
		if (this.unifFrame != -1) gl.uniform1i(this.unifFrame, 0);
		if (this.unifPreFrame != -1) gl.uniform1i(this.unifPreFrame, 1);
		if (this.unifHighpass != -1) gl.uniform1i(this.unifHighpass, 2);
		
		if (PostProcess.screenQuad === undefined) {
			PostProcess.screenQuad = new Square(vec3.fromValues(0, 0, 0));
			PostProcess.screenQuad.create();
		}
	}

  	draw() {
  		super.draw(PostProcess.screenQuad);
  	}

  	getName() : string { return this.name; }

}

export default PostProcess;
