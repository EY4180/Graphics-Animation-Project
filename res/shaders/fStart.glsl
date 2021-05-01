varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 eyeVector; // vector from point to eye

varying vec3 pointVector; // vector from vertex to point light
varying vec3 spotVector; // vector from vertex to spot light
varying vec3 normalVector; // surface normal vector
varying vec3 directionalVector; // vector from origin to directional light

uniform vec3 spotDirection; // vector where the spotlight points
uniform vec3 ColorVector[3]; // rgb values of lights
uniform vec3 GlobalAmbient;

uniform float AmbientProduct, DiffuseProduct, SpecularProduct, Shininess;
uniform float texScale;
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
    float n = Shininess;
    vec3 reflection = reflect(light, normal);
    float cosTheta = clamp(dot(reflection, eye), 0.0, 1.0);
    float specularCoefficient = pow(cosTheta, n);
    return specularCoefficient;
}

vec3 getColor(in vec3 light, in vec3 rgb, in vec3 normal, in vec3 eye)
{
    vec3 nNormal = normalize(normal);
    vec3 nLight = normalize(light);
    vec3 nEye = normalize(eye);
    vec3 nHalf = normalize( nLight + nEye );
    vec3 intensity = getIntensity(light);

    vec3 ambient = AmbientProduct * rgb;

    float Kd = clamp(dot(nLight, nNormal), 0.0, 1.0);
    vec3 diffuse = Kd * DiffuseProduct * rgb;

    float Ks = getSpecular(nNormal, nLight, nEye);
    vec3 specular = Ks * SpecularProduct * rgb;    

    vec3 totalColor = ambient + (diffuse + specular) * intensity;
    return totalColor;
}

void main()
{
    vec3 pointColor = getColor(pointVector, ColorVector[0], normalVector, eyeVector);
    vec3 directionalColor = getColor(directionalVector.xyz, ColorVector[1], normalVector, eyeVector);
    vec3 spotColor = getColor(spotVector, ColorVector[2], normalVector, eyeVector);

    float angle = degrees(acos(dot(normalize(spotVector), spotDirection)));
    if (angle > 15.0) {
        spotColor = vec3(0.0, 0.0, 0.0);
    }
    else {
        spotColor =  spotColor * pow(cos(radians(angle)), 50.0);
    }

    if(gl_FrontFacing) {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    else {
        gl_FragColor = vec4(GlobalAmbient + spotColor + directionalColor + pointColor, 1.0 ) * texture2D( texture, texCoord * 2.0 );
    }
}
