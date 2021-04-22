in vec4 color;
in vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
in vec3 Lvec; // vector from point to light
in vec3 Evec; // vector from point to eye
in vec3 Nvec; // surface normal vector

uniform vec4 DirectionalPosition; // position of the directional source
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec3 GlobalAmbient;
uniform float Shininess;

uniform float texScale;
uniform float width, height;
uniform sampler2D texture;

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

// pretty simple method for gettin a better specular coefficient
// Gaussian Distribution m is a user defined constant for smoothness between 0 and 1
float getGaussian(in vec3 normal, in vec3 half)
{
    float theta = acos(clamp(dot(normal, half), 0.0, 1.0)); // angle between normal and half vector
    float specularCoefficient = exp(-pow(theta / Shininess, 2.0));
    return specularCoefficient;
}

// more complex method of calculating specular coefficient
float getSpecular(in vec3 normal, in vec3 light, in vec3 eye)
{
    float n = 10.0;
    vec3 reflection = reflect(light, normal);
    float cosTheta = clamp(dot(reflection, eye), 0.0, 1.0);
    float specularCoefficient = pow(cosTheta, n);
    return specularCoefficient;
}

vec3 getColor(in vec3 light, in vec3 normal, in vec3 eye)
{
    vec3 nNormal = normalize(normal);
    vec3 nLight = normalize(light);
    vec3 nEye = normalize(eye);
    vec3 nHalf = normalize( nLight + nEye );
    vec3 intensity = getIntensity(light);

    vec3 ambient = AmbientProduct;

    float Kd = clamp(dot(nLight, nNormal), 0.0, 1.0);
    vec3 diffuse = Kd * DiffuseProduct;

    //float Ks = getGaussian(nNormal, nHalf);
    float Ks = getSpecular(nNormal, nLight, nEye);
    vec3 specular = Ks * SpecularProduct;    

    vec3 totalColor = (ambient + diffuse + specular) * intensity;
    return totalColor;
}

void main()
{
    vec3 pointColor = getColor(Lvec, Nvec, Evec);
    vec3 directionalColor = getColor(normalize(DirectionalPosition.xyz), Nvec, Evec);

    if(gl_FrontFacing) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    else {
        gl_FragColor = vec4( directionalColor + pointColor, 1.0 ) * texture2D( texture, texCoord * 2.0 );
    }
}
