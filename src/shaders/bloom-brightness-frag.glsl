#version 300 es
precision highp float;

in vec2 fs_UV;

out vec4 out_Col;

uniform sampler2D u_frame;

uniform int u_Time;

void main()
{
    float threshold = 0.1;

    vec4 curr_Color = texture(u_frame, fs_UV);

    float greyRed = curr_Color.x * 0.21;
    float greyGreen = curr_Color.y * 0.72;
    float greyBlue = curr_Color.z * 0.07;
    
    float grey = greyRed + greyGreen + greyBlue;

    if (grey > threshold) {
        out_Col = vec4(curr_Color.xyz, 1.);
    } else {
        out_Col = vec4(0.);
    }
}
