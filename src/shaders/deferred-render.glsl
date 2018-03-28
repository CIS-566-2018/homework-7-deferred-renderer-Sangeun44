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


float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

#define OCTAVES 6
float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
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
    
	if(CSD_normal.w > 0.99999) {
		vec2 u_resolution = vec2(10.,10.);
	 	vec2 st = gl_FragCoord.xy/u_resolution.xy;
    	st.x *= u_resolution.x/u_resolution.y;

    	vec3 color = vec3(0.2,0.1,0.3);
    	color += fbm(st * sin(u_Time * 0.01));

    	out_Col = vec4(color,1.0);
	} else {
		out_Col = vec4(diffuseColor.xyzw * lightIntensity );
	}


}