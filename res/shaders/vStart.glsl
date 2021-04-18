attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec3 GlobalAmbient;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

varying vec3 Lvec; // vector from point to light
varying vec3 Evec; // vector from point to eye
varying vec3 Nvec; // surface normal vector

// calculate lighting based on linear, quadratic and constant attenuation
void vertexLighting(out float attenuation, in float lightDistance)
{
    float csrc = 100.0; // source intensity 
    float kc = 5.0; // constant attenuation
    float kl = 0.5; // linear attenuation
    float kq = 0.5; // quadratic attenuation
    attenuation = csrc / (kc + kl * lightDistance + kq * pow(lightDistance, 2.0));
}

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;

    // The vector to the light from the vertex    
    Lvec = LightPosition.xyz - pos;
    
    float Cl = 1.0;
    vertexLighting(Cl, length(Lvec));

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );
    
    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct * Cl;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct * Cl;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct * Cl;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    color.rgb = GlobalAmbient + ambient + diffuse + specular;
    color.a = 1.0;

    gl_Position = Projection * ModelView * vpos;

    texCoord = vTexCoord;
    Nvec = N;
    Evec = -pos;
}
