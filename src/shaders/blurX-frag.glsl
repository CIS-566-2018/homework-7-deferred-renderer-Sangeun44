#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_frame;
uniform sampler2D u_preFrame;


const float GAUSS_KERNEL[5] = float[5] (0.153388, 0.221461, 0.250301, 0.221461, 0.153388);

void main() {
    vec2 u_Resolution = vec2(260.,260.);
    vec3 color = vec3(0.);
    float pixelDim = 1.0/u_Resolution.x;
    
    for(int i = -2; i <=2; i++) {
        color += GAUSS_KERNEL[i+2] * texture(u_preFrame, fs_UV +vec2(float(i) * pixelDim, 0.0)).xyz;
    }
        out_Col = vec4(color, 1.0);
}
