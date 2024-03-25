//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 colorTeamOne;
uniform vec4 colorTeamTwo;
uniform sampler2D paintSurface;
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
	
	if(surfaceRSampler == 1.0){
		discard;
	}else{
		gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	}    
}
