varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 colorTeamOne;
uniform vec3 colorTeamTwo;
//...

vec3 hsv2rgb(vec3 c) 
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	vec4 surfaceSampler = v_vColour * texture2D(gm_BaseTexture,v_vTexcoord);
	float surfaceRSampler = surfaceSampler.r;
	
	if (surfaceRSampler == 1.0) {
        discard;
    } else if (surfaceRSampler == 0.0) {
        gl_FragColor = vec4(hsv2rgb(colorTeamOne), 1.0);
    } else if (surfaceRSampler > 0.070 && surfaceRSampler < 0.08) {
        gl_FragColor = vec4(hsv2rgb(colorTeamTwo), 1.0);
    }
}
