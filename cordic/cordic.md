# Cordic

## Description
This module compute the sine and cosine value of an angle using CORDIC algorithm.
## Parameter
c_parameter: ?
AngleFactor: ?
## Input
angle: input angle coded on 33 (?) bits.
Xin: X value (cosine) of the previously calculated value.
Yin: Y value (sine) of the previously calculated value.

## Output
Xout: X value (cosine) send to the next step.
Yout: Y value (sine) send to the next step.
s_axis_done: rise to one when computation is complete.

