#version 300 es
precision highp float;

in vec2 fs_UV;

out vec4 out_Color;

uniform sampler2D u_frame;
uniform sampler2D u_Prev;
uniform sampler2D u_GBuf0;

uniform int u_Time;
 
 const int radius = 7;

 void main() 
 {
     vec4 gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
        if (length(lightWeighting) < 1.00) {
            if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0) {
                gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
        if (length(lightWeighting) < 0.75) {
            if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0) {
                gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
        if (length(lightWeighting) < 0.50) {
            if (mod(gl_FragCoord.x + gl_FragCoord.y - 5.0, 10.0) == 0.0) {
                gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }

        if (length(lightWeighting) < 0.3465) {
            if (mod(gl_FragCoord.x - gl_FragCoord.y - 5.0, 10.0) == 0.0) {
                gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
     out_Color = fragColor;
 }