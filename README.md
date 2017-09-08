# OpenSCAD_airfoil
## Parametric Airfoil and Wing generator v0.1
Homepage: https://github.com/ErroneousBosch/OpenSCAD_airfoil

For a brief overview of the math and specifications used, see https://en.wikipedia.org/wiki/NACA_airfoil

## Globals:
***$close_airfoils***: Defines whether you want the back of your air foils closed, or if you want them open (default: false) 

***$fn***: number of sides for your airfoil. (default: 100) 

## airfoil_poly help:
***c***: Chord length, this is the chord length of your airfoil. (default: 100) 

***naca***: The NACA 4-digit specification for your airfoil. (default: 0015) 

## airfoil_simple_wing help: 
***airfoils***: Airfoils should be a set of [chord, naca]. Specify one for a uniform wing, two or more in a vector for compound wing. If specifying only one, do not put it in a set/vector. Multiple airfoils will be spaced evenly along the wing length. (required)

***wing_angle***: a set of angles, \[sweep,slope\] (optional, default=[0,0])

***wing_length***: length of the wing (optional, default=1000