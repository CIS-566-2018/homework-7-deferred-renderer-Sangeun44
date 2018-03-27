#version 300 es
precision highp float;

#define EPS 0.0001
#define PI 3.1415962

in vec2 fs_UV;
in vec4 fs_Pos;
in vec4 fs_Nor;

out vec4 out_Col;

uniform sampler2D u_gb0;
uniform sampler2D u_gb1;
uniform sampler2D u_gb2;

uniform float u_Time;

uniform mat4 u_View;
uniform vec4 u_CamPos;   

vec4 fs_LightVec;

vec2 random2( vec2 p ) {
    return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

void main() { 
	// read from GBuffers

	fs_LightVec = vec4(0, 10, 0, 0.0);

	vec4 CSD_normal = texture(u_gb0, fs_UV);
	vec4 gb1 = texture(u_gb1, fs_UV);
	vec4 albedo = texture(u_gb2, fs_UV);

	//color of the image mario 
	vec4 diffuseColor = albedo;

  	//Calculate the diffuse term for Lambert shading
 	float diffuseTerm = dot(normalize(vec4(CSD_normal.x, CSD_normal.y, CSD_normal.z, 0.)), normalize(fs_LightVec));
    diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);

    float ambientTerm = 0.1;
	float lightIntensity = diffuseTerm + ambientTerm; 
    
	out_Col = vec4(diffuseColor.xyzw * lightIntensity );


}