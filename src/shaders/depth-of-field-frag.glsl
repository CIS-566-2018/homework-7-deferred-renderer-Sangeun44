#version 300 es
precision highp float;

in vec2 fs_UV;

out vec4 out_Col;

uniform sampler2D u_frame;
uniform sampler2D u_gb0;

uniform float u_Time;
uniform vec4 u_CamPos;   

//blur the more the z frag is further away

void main() {
	float d_X = 30.; //x of kernel
    float d_Y = 30.; //y of kernel
    float frag_X = gl_FragCoord.x; //current coord.x
    float frag_Y = gl_FragCoord.y; //current coord.y

    vec3 weighted_Color; //color

    
    vec4 posVec = texture(u_gb0, fs_UV);
        
    float sigma = 2.;
    if(posVec.w > 0.995) {
        for(float i = 0.; i < d_X; i++){
            for(float j = 0.; j < d_Y; j++){
                float first = 1./(2. * 3.141592 * pow(sigma, 2.));
                float e_value = pow(2.71828, (-1. * ((pow(i - d_X / 2., 2.) + pow(j - d_Y / 2., 2.))/(2. * pow(sigma,2.)))));
                float weight = first * e_value;

                vec2 point_UV = vec2(clamp(fs_UV.x + (i - d_X/2.)/640.f, 0., 1.), clamp(fs_UV.y + (j - d_Y/2.)/480.f, 0., 1.));

                vec4 curr_Color = texture(u_frame, point_UV);
                weighted_Color = weighted_Color + (weight * vec3(curr_Color));
            }
        }
    } else if(posVec.w < 0.00002) {
        for(float i = 0.; i < d_X; i++) {
            for(float j = 0.; j < d_Y; j++) {
                float first = 1./(2. * 3.141592 * pow(sigma, 2.));
                float e_value = pow(2.71828, (-1. * ((pow(i - d_X / 2., 2.) + pow(j - d_Y / 2., 2.))/(2. * pow(sigma,2.)))));
                float weight = first * e_value;

                vec2 point_UV = vec2(clamp(fs_UV.x + (i - d_X/2.)/640.f, 0., 1.), clamp(fs_UV.y + (j - d_Y/2.)/480.f, 0., 1.));

                vec4 curr_Color = texture(u_frame, point_UV);
                weighted_Color = weighted_Color + (weight * vec3(curr_Color));
            }
        }
    } else {
        vec4 curr_Color = texture(u_frame, fs_UV);
        weighted_Color = vec3(curr_Color);
    }
    
    out_Col = vec4(weighted_Color, 1.);
}