# A
The variables `camRotSidewaysDeg` and  `camRotUpAndOverDeg` are automatically
set by program when moving the mouse while clicking.

To incorperate these values into the cameras position, the display callback
needed to be modified. Firstly, define `camRotSidewaysDeg` as the angle about the
y-axis and `camRotUpAndOverDeg` to be the angle about the xz-plane. Then by using
a sperical coordinate system it is possible to turn these angles into cartesian
coordinates.

The original code was,
```C
view = Translate(0.0, 0.0, -viewDist);
```

The modified code was,
```C
vec4 sphericalToCartesian(float theta, float phi, float magnitude)
{
    float Y = magnitude * sinf(theta);
    float X = magnitude * cosf(theta) * cosf(phi);
    float Z = magnitude * cosf(theta) * sinf(phi);

    return vec4(X, Y, Z, 1.0);
}

```

# B

# C

# D

# E

# F

# G

# H

# I