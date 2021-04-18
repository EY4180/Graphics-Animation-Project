varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform float texScale;
uniform sampler2D texture;
uniform vec3 lightPos;  

in vec3 fragNormal;
in vec3 fragPos;  

void main()
{
    vec3 lightDirection = fragPos - lightPos;
    float lightDistance = length(lightDirection);
    
    gl_FragColor = color * texture2D( texture, texCoord * texScale );
}
