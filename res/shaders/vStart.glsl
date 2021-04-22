attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

uniform vec4 DirectionVector[3]; // direction of lights
uniform vec4 LightPosition[3]; // positions of the point source
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;

varying vec2 texCoord;
varying vec3 pointVector; // vector from point to light
varying vec3 eyeVector; // vector from point to eye
varying vec3 normalVector; // surface normal vector

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);
    vec3 pos = (ModelView * vpos).xyz;

    pointVector = LightPosition[0].xyz - pos;
    normalVector = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );
    eyeVector = -pos;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
