attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

uniform vec4 LightPosition[3]; // positions of the point source
uniform mat4 ModelView;
uniform mat4 Projection;

varying vec2 texCoord;
varying vec3 pointVector; // vector from vertex to point light
varying vec3 spotVector; // vector from vertex to spot light
varying vec3 directionalVector; // vector from origin to directional light

varying vec3 eyeVector; // vector from point to eye
varying vec3 normalVector; // surface normal vector

varying vec3 vertexShaderColour[3]; // colour as seen by the vertex shader
// 0 - point
// 1 - direction
// 2 - spotlight

vec3 getIntensity(in vec3 lightVector)
{
    float distance = length(lightVector);
    float csrc = 50.0; // source intensity 
    float kc = 5.0; // constant attenuation
    float kl = 1.0; // linear attenuation
    float kq = 1.0; // quadratic attenuation
    float intensity = csrc / (kc + kl * distance + kq * distance * distance);
    return vec3(intensity, intensity, intensity);
}

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);
    vec3 pos = (ModelView * vpos).xyz;

    spotVector = LightPosition[2].xyz - pos;
    directionalVector = normalize(LightPosition[1].xyz);
    pointVector = LightPosition[0].xyz - pos;
    
    normalVector = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );
    eyeVector = -pos;
    texCoord = vTexCoord;

    gl_Position = Projection * ModelView * vpos;
}
