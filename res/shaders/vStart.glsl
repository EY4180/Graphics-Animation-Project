attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 color;
varying vec3 Intensity; // attenuation of light
varying vec3 Light; // vector from point to light
varying vec3 Eye; // vector from point to eye
varying vec3 Normal; // surface normal vector
varying vec3 Half; // vector from point to eye

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec3 GlobalAmbient;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;


// calculate lighting based on linear, quadratic and constant attenuation
void getAttenuation(out vec3 attenuation, in vec3 light)
{
    float csrc = 100.0; // source intensity 
    float kc = 5.0; // constant attenuation
    float kl = 0.5; // linear attenuation
    float kq = 0.5; // quadratic attenuation
    float total = csrc / (kc + kl * length(light) + kq * pow(length(light), 2.0));
    attenuation = vec3(total, total, total);
}

void main()
{
    vec4 vpos = vec4(vPosition, 1.0);
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vpos).xyz;
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;


    // Unit direction vectors for Blinn-Phong shading calculation
    Light = normalize( Lvec );   // Direction to the light source
    Eye = normalize( -pos );   // Direction to the eye/camera
    Half = normalize( Light + Eye );  // Halfway vector
    getAttenuation(Intensity, Lvec); // Light intensity

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    Normal = normalize( (ModelView*vec4(vNormal, 0.0)).xyz );
    
    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(Light, Normal), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(Normal, Half), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(Light, Normal) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    color.rgb = GlobalAmbient + (ambient + diffuse + specular) * Intensity;
    color.a = 1.0;

    gl_Position = Projection * ModelView * vpos;
    texCoord = vTexCoord;
}
