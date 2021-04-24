# A

The variables `camRotSidewaysDeg` and `camRotUpAndOverDeg` are automatically
set by program when moving the mouse while clicking. By using
a sperical coordinate system it is possible to turn these angles into cartesian
coordinates.

Some extra steps had to be taken to convert the angles in degrees to radians.
And the inbuilt function `LookAt` was used to generate the transformation
matrix for the view.

Because the `up` vector is constant, an issue arises when `camRotUpAndOverDeg`
exceeds +-90 degrees. At this angle of rotation, the `up` vector is incorrect and
the camera flips. To prevent the camera from being rotated beyond +-90 degrees,
the values were clamped between +-88 degrees.

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

The resulting matricies from each transformation were multiplied together to get
the overall model matrix.

# C
The matracies to scale the mouse movements was set at an arbitrary value of 100.
This was just makes the adjusting more sensitive so it is easier to see.

As per requirements there is some clamping on the shine value to have it range
between 0 and 100.

# D

# E

# F

# G

# H

# I
