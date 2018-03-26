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

void main() { 
	// read from GBuffers

	fs_LightVec = vec4(0,10,20,1.0);

	vec4 gb0 = texture(u_gb0, fs_UV);
	vec4 gb1 = texture(u_gb1, fs_UV);
	vec4 gb2 = texture(u_gb2, fs_UV);

	//color of the image mario 
	vec4 diffuseColor = texture(u_gb2, fs_UV);

  	//Calculate the diffuse term for Lambert shading
 	float diffuseTerm = dot(normalize(gb0), normalize(fs_LightVec));
    diffuseTerm = clamp(diffuseTerm, 0.0, 1.0);

    float ambientTerm = 0.7;
	float lightIntensity = diffuseTerm + ambientTerm; 
    
	//blinn-phong
	vec4 view_vec = fs_Pos * u_CamPos;
    vec4 light_vec = fs_LightVec;
    vec4 average = normalize((view_vec + light_vec)/2.);
    vec4 normal = normalize(fs_Nor);
    float exp = 50.;
    float SpecularIntensity = max(pow(dot(average, normal), exp), 0.0);

    // Compute final shaded color
    out_Col = vec4(diffuseColor.xyzw * lightIntensity + SpecularIntensity);

}