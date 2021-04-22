attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform vec4 DirectionalPosition; // position of the directional source
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec3 GlobalAmbient;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition; // position of the point source
uniform float Shininess;

varying vec3 Lvec; // vector from point to light
varying vec3 Evec; // vector from point to eye
varying vec3 Nvec; // surface normal vector
varying vec3 Dvec; // vector from directional to 

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);
    vec3 pos = (ModelView * vpos).xyz;
    // The vector to the light from the vertex    
    Lvec = LightPosition.xyz - pos;

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    Nvec = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );
    // Transform vertex position into eye coordinates
    Evec = -pos;

    gl_Position = Projection * ModelView * vpos;

    texCoord = vTexCoord;
}
