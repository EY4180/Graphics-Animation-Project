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

## Original

```C
view = Translate(0.0, 0.0, -viewDist);
```

## Modified

```C
float camRotUpAndOverRad = camRotUpAndOverDeg * DegreesToRadians;
float camRotSidewaysRad = camRotSidewaysDeg * DegreesToRadians;

float Y = viewDist * sinf(camRotUpAndOverRad);
float X = viewDist * cosf(camRotUpAndOverRad) * cosf(camRotSidewaysRad);
float Z = viewDist * cosf(camRotUpAndOverRad) * sinf(camRotSidewaysRad);

vec4 eye = {X, Y, Z, 0.0};
vec4 center = {0, 0, 0, 1.0};
vec4 up = {0.0, 1.0, 0.0, 0.0};

view = LookAt(eye, center, up);
```

# B

# C

# D

# E

# F

# G

# H

# I
