# A

The variables `camRotSidewaysDeg` and `camRotUpAndOverDeg` are automatically
set by program when moving the mouse while clicking.

To incorperate these values into the cameras position, the display callback
needed to be modified. Firstly, define `camRotSidewaysDeg` as the angle about the
y-axis and `camRotUpAndOverDeg` to be the angle about the xz-plane. Then by using
a sperical coordinate system it is possible to turn these angles into cartesian
coordinates.

Some extra steps had to be taken to convert the angles in degrees to radians.
And the inbuilt function `LookAt` was used to generate the transformation
matrix for the view.

Because the `up` vector is constant, an issue arises when `camRotUpAndOverDeg`
exceeds +-90 degrees. At this angle of rotation, the `up` vector is incorrect and
the camera flips. To prevent the camera from being rotated beyond +-90 degrees,
the values were clamped between +-88 degrees.

## Original

```C++
view = Translate(0.0, 0.0, -viewDist);
```

## Modified

```C++
float camRotUpAndOverRad = camRotUpAndOverDeg * DegreesToRadians;
float camRotSidewaysRad = camRotSidewaysDeg * DegreesToRadians;

float Y = viewDist * sinf(camRotUpAndOverRad);
float X = viewDist * cosf(camRotUpAndOverRad) * cosf(camRotSidewaysRad);
float Z = viewDist * cosf(camRotUpAndOverRad) * sinf(camRotSidewaysRad);

const vec4 eye = {X, Y, Z, 1};
const vec4 center = {0, 0, 0, 1};
const vec4 up = {0, 1, 0, 0};

view = LookAt(eye, center, up);
```

# B

Using the scene object variables, the program constructs a matrix that performs
the rotations, scale and translations required to get the object into the
correct position. The position and rotation variables are set by the program
during runtime.

To do this, we apply these transformations in order

1. `RotateX(sceneObj.angles[0])`
2. `RotateY(sceneObj.angles[1])`
3. `RotateZ(sceneObj.angles[2])`
4. `Scale(sceneObj.scale)`
5. `Translate(sceneObj.loc)`

The order here is quite important. While the rotations and scaling can occur in
any order, the translation must occur last as the rotations and scaling must
be performed at the origin for correct results.

The resulting matricies from each transformation are multiplied together to get
the overall model matrix.

# C

To get the color adjust menu working, we first look at the ID for the color
adjust menu and set the handler in the materialMenu function.

When the materialMenu function gets an ID to adjust color, it will set the
current tool object to the current object and attatch the following two functions
to the mouse event handler.

The matracies to scale the mouse movements was set at an arbitrary value of 100.
This was just makes the adjusting more sensitive so it is easier to see.

As per requirements there is some clamping on the shine value to have it range
between 0 and 100.

## Modified

```C++
static void adjustShineSpecular(vec2 ss)
{
    sceneObjs[toolObj].shine += ss[0];
    sceneObjs[toolObj].shine = fmax(sceneObjs[toolObj].shine, 0.0);
    sceneObjs[toolObj].shine = fmin(sceneObjs[toolObj].shine, 100.0);
    sceneObjs[toolObj].specular += ss[1];
}

static void adjustAmbientDiffuse(vec2 ad)
{
    sceneObjs[toolObj].ambient += ad[0];
    sceneObjs[toolObj].diffuse += ad[1];
}
```

# D

# E

# F

# G

# H

# I
