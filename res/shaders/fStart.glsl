varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 Intensity; // attenuation of light
varying vec3 Light; // vector from point to light
varying vec3 Eye; // vector from point to eye
varying vec3 Normal; // surface normal vector
varying vec3 Half; // vector from point to eye

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform float texScale;
uniform sampler2D texture;
uniform float Shininess;

void main()
{
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(Light, Normal), 0.0 );
    vec3 diffuse = Kd*DiffuseProduct;

    float m = 0.5;
    // pretty simple method for gettin a better specular coefficient
    // Gaussian Distribution m is a user defined constant for smoothness between 0 and 1
    float KsNew = exp(pow((dot(Normal, Half) / m), 2.0));
    float Ks = pow( max(dot(Normal, Half), 0.0), Shininess );
    vec3 specular = KsNew * SpecularProduct;    
    if (dot(Light, Normal) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 

    vec4 perFragment = vec4( (ambient.rgb + diffuse.rgb + specular.rgb) * Intensity, 1.0 );

    if(gl_FrontFacing) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    else {
        gl_FragColor = color * texture2D( texture, texCoord * texScale );
    }
    
}
