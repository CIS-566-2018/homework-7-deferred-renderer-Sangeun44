#version 300 es
precision highp float;

in vec2 fs_UV;

out vec4 out_Color;

uniform sampler2D u_frame;
uniform sampler2D u_GBuf0;

uniform int u_Time;
 

 void main() 
 {
     vec4 curr_Color = texture(u_frame, fs_UV);

            float greyRed = curr_Color.x * 0.21;
            float greyGreen = curr_Color.y * 0.72;
            float greyBlue = curr_Color.z * 0.07;

            float grey = greyRed + greyGreen + greyBlue;

     vec4 lightWeighting = vec4(grey);
     vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
        if (length(lightWeighting) < 1.00) {
            if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0) {
                color = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
        if (length(lightWeighting) < 0.75) {
            if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0) {
                color = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
        if (length(lightWeighting) < 0.50) {
            if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0) {
                color = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }

        if (length(lightWeighting) < 0.3465) {
            if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0) {
                color = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
     out_Color = color;
 }