attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

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

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    // The vector to the light from the vertex    
    Lvec = LightPosition.xyz - pos;
    
    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );

    gl_Position = Projection * ModelView * vpos;

    texCoord = vTexCoord;
    Nvec = N;
    Evec = -pos;
}
