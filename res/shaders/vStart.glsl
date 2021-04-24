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
