# A
## Function
- Left Mouse Button
  - Horizontal: Rotate the camera horizontally about the origin
  - Vertical: Zoom in/out when moving up/down with respect to the screen

- Middle Mouse Button
  - Horizontal: Rotate the camera horizontally about the origin
  - Vertical: Rotate the camera vertically about the origin

## Implementation
```C++
    const vec4 eye = {X, Y, Z, 1};
    const vec4 center = {0, 0, 0, 1};
    const vec4 up = {0, 1, 0, 0};

    view = LookAt(eye, center, up);
```
The variables `camRotSidewaysDeg` and `camRotUpAndOverDeg` are automatically
set by program when moving the mouse while clicking. By using
a sperical coordinate system it is possible to turn these angles into cartesian
coordinates. These coordinates are then used with the inbuilt `LookAt()`
function inside the display callback to set the view matrix.

Because the `up` vector is constant, an issue arises when `camRotUpAndOverDeg`
exceeds +-90 degrees. At this angle of rotation, the `up` vector is incorrect and
the camera flips. To prevent the camera from being rotated beyond +-90 degrees,
the values were clamped between +-88 degrees.

# B
## Function
The program now allows the user to change the scale, rotation and position of
objects in the scene.
## Implementation
Using the scene object variables, the program constructs a matrix that performs
the rotations, scale and translations required to get the object into the
correct position. The position and rotation variables are set by the program
during runtime.

To do this, several transformations are applied in order

1. `RotateX(sceneObj.angles[0])`
2. `RotateY(sceneObj.angles[1])`
3. `RotateZ(sceneObj.angles[2])`
4. `Scale(sceneObj.scale)`
5. `Translate(sceneObj.loc)`

The order here is quite important. While the rotations and scaling can occur in
any order, the translation must occur last as the rotations and scaling must
be performed at the origin for correct results.

- Left Mouse Button
  - Horizontal: Rotate object parallel to the y-axis
  - Vertical: Rotate object about the x-axis

- Middle Mouse Button
  - Horizontal: Rotate object about the z-axis
  - Vertical: Increases/decrases the texture scale

# C
Using the left mouse button, you can move the mouse sources along the path of
your mouse. For example, move the mouse up and the object moves into the screen,
move the mouse left and the object moves to the left of the screen. All objects
move in this intuitive manner. 

Using the middle mouse button can change the y-position of a light source and
alter its brightness.

Left mouse and dragging vertically increases the diffuse lighting
(up is increase and down is decrease).

Left mouse and dragging horizontally changes the ambient lighting 
(left is decreas and right is increase).

Middle mouse and dragging horizontally changes the shine
(left is decreas and right is increase).
Middle mouse and dragging vertically changes specular
(up is increase and down is decrease).

It all of these values are clamped between 0.0 and 100.0 which I thought were
reasonable limits for this program.
# D
The program is capable of zooming in as much as they want. Clipping of the
near plane was set at an arbitrary low value. You can go as close to the object
as you want.

The main problem with the original code was that it used the `Frustrum()`
method rather than the `perspective` method (which can achieve a far closer
near plane and prevent clipping). 
# E
After the screen stops becomming a square, the FOV adapts so that the content on
the screen does not change. This works both when reshaping the width and height.

To solve this, I simply made the FOV a function of the screen width and height.
The aspect ratio is calculated as `width/height` but in the case the the height
is less than the width, I simply switch the components in the view matrix that
correspond to the FOV transofmations. This is essentially how I calculate the
FOV in the y-direction when height is less than width (normally FOV is assumed to
be in the x-direction).

# F
I added a function in the vertex shader that takes the vector from the 
light-source to the vertex and produces an intensity vector. This intensity
vector is multiplied with the ambient, diffuse and specular components to
produce the effect of light falling off with distance. Light falls of with the
inverse square law. To get more good-looking results, I used the following
attenuation equation,

```C++
float distance = length(lightVector);
float csrc = 50.0; // source intensity 
float kc = 5.0; // constant attenuation
float kl = 1.0; // linear attenuation
float kq = 1.0; // quadratic attenuation
float intensity = csrc / (kc + kl * distance + kq * distance * distance);
return vec3(intensity, intensity, intensity);
```
# G
The lighting in the vertex shader was very patchy. For example, when you move the light the circle of light underneath it changes its shape as it moves over the plane. This is because the plane is very low-poly and does not allow for accurate lighting calcualtions.

To solve this, I simply moved the color calculations over to the fragment
shader. The vertex shader only exists to pass the normal, eye and light
vectors to the fragment shader. 

This change makes moving light very smooth.
# H
Specular reflection was caluclated according to the equation,
```C++
float n = Shininess;
vec3 reflection = reflect(light, normal);
float cosTheta = clamp(dot(reflection, eye), 0.0, 1.0);
float specularCoefficient = pow(cosTheta, n);
return specularCoefficient;
```

Increasing values of `n` increase the amount of specular highlighting
that occurs. This specular equation is designed to blow up then the
eye is in the same direction to the reflected vector. This increase in
specular coefficient will dominate the other RGB terms from 
diffuse and ambient - tending towards the color white.
# I
The directional light appears as a big sphere, and its direction of
illumination can be controlled by moving it around the world. Its
direction is the vector between the lights position and the origin.

When adding multiple lights it was important to have separate color
vectors as each light has its own modifiable color. Early on I had
a bug where turning one light green turned all of them green.

The program correctly allows each light to have its own separate RGB
values which affect the final render.
# J
Users can delete any object that they want from a dropdown menu. However,
users can not delete any of the light sources or ground planes.
Similarly, you can duplicate any object on the screen from a drop-down.

The spot-light can have both its position and direction changed.
Its lighting angle is set at 15 degrees and can not be changed.
Its position is set identically to the other lights as described earlier.
And its direction is set by rotating the object like you would any other
object.