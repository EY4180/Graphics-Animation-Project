varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float texScale;
uniform sampler2D texture;
uniform float Shininess;

in vec3 Lvec; // vector from point to light
in vec3 Evec; // vector from point to eye
in vec3 Nvec; // surface normal vector

// calculate lighting based on linear, quadratic and constant attenuation
void vertexLighting(out float attenuation, in float lightDistance)
{
    float csrc = 100.0; // source intensity 
    float kc = 5.0; // constant attenuation
    float kl = 1.0; // linear attenuation
    float kq = 2.0; // quadratic attenuation
    attenuation = csrc / (kc + kl * lightDistance + kq * pow(lightDistance, 2.0));
}

void main()
{
    vec3 Normal = normalize(Nvec);
    vec3 Light = normalize(Lvec);
    vec3 Eye = normalize(Evec);
    vec3 Half = normalize( Light + Eye );  // Halfway vector
    float multiplier = 1.0;
    vertexLighting(multiplier, length(Lvec));

    vec3 ambient = AmbientProduct * multiplier;

    float Kd = max( dot(Light, Normal), 0.0 );
    vec3 diffuse = Kd*DiffuseProduct * multiplier;

    float m = 0.5;
    // pretty simple method for gettin a better specular coefficient
    // Gaussian Distribution m is a user defined constant for smoothness between 0 and 1
    float KsNew = exp(pow((dot(Normal, Half) / m), 2.0));
    float Ks = pow( max(dot(Normal, Half), 0.0), Shininess );
    vec3 specular = KsNew * SpecularProduct  * multiplier;    
    if (dot(Light, Normal) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 

    vec4 perFragment = vec4( ambient.rgb + diffuse.rgb + specular.rgb, 1.0 );

    if(gl_FrontFacing) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    else {
        gl_FragColor = perFragment * texture2D( texture, texCoord * texScale );
    }
    
}
