#version 300 es
precision highp float;
in vec2 fs_UV;

out vec4 out_Col;

uniform sampler2D u_frame;
uniform sampler2D u_highpass;

uniform float u_Time;
uniform vec4 u_CamPos;   

void main() {

    const int radius = 4;
    float n = float((radius + 1) * (radius + 1));

    vec3 m[4];
    vec3 s[4];
    for (int k = 0; k < 4; ++k) {
        m[k] = vec3(0.0);
        s[k] = vec3(0.0);
    }

    for (int j = -radius; j <= 0; ++j)  {
        for (int i = -radius; i <= 0; ++i)  {
            vec3 c = texture(u_frame, fs_UV + vec2(i,j)/ vec2(260.,260.)).rgb;
            m[0] += c;
            s[0] += c * c;
        }
    }

    for (int j = -radius; j <= 0; ++j)  {
        for (int i = 0; i <= radius; ++i)  {
            vec3 c = texture(u_frame, fs_UV + vec2(i,j) /vec2(260.,260.)).rgb;
            m[1] += c;
            s[1] += c * c;
        }
    }

    for (int j = 0; j <= radius; ++j)  {
        for (int i = 0; i <= radius; ++i)  {
            vec3 c = texture(u_frame, fs_UV + vec2(i,j) / vec2(240.,240.)).rgb;
            m[2] += c;
            s[2] += c * c;
        }
    }

    for (int j = 0; j <= radius; ++j)  {
        for (int i = -radius; i <= 0; ++i)  {
            vec3 c = texture(u_frame, fs_UV + vec2(i,j) / vec2(240.,240.)).rgb;
            m[3] += c;
            s[3] += c * c;
        }
    }


    float min_sigma2 = 1e+2;
    for (int k = 0; k < 4; ++k) {
        m[k] /= n;
        s[k] = abs(s[k] / n - m[k] * m[k]);

        float sigma2 = s[k].r + s[k].g + s[k].b;
        if (sigma2 < min_sigma2) {
            min_sigma2 = sigma2;
            out_Col = vec4(m[k], 1.0);
        }
    }
}