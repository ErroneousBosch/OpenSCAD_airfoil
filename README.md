# OpenSCAD_airfoil
## Parametric Airfoil and Wing generator v0.1
Homepage: https://github.com/ErroneousBosch/OpenSCAD_airfoil

For a brief overview of the math and specifications used, see https://en.wikipedia.org/wiki/NACA_airfoil

## Globals:
***$close_airfoils***: Defines whether you want the back of your air foils closed, or if you want them open (default: false) 

***$airfoil_fn***: number of sides for your airfoil. (default: 100) 

## airfoil_poly help:
This function generates a 2D polygon of an airfoil, using the following variables.

***c***: Chord length, this is the chord length of your airfoil. (default: 100) 

***naca***: The NACA 4-digit specification for your airfoil. (default: 0015) 

***raw***: overrides the NACA code with direct ratios. Provide in the same order as the NACA digits. (e.g NACA 4123 becomes raw [.4,.1,.23])<br>

## airfoil_simple_wing help: 
This will generate a simple wing based on one or more supplied airfoils. Each set of airfoils is an individual shape, allowing for very complex variation along the wing.

***airfoils*** (required): 
Two modes:

*Single Airfoil*: Specifying a single airfoil will generate a uniform wing based on that airfoil. You can specify the airfoil as a set (vector) of [chord, naca].

*Multiple airfoils*: Specify a set (vector) of airfoils. Individual airfoils are specified the same as a single airfoil (see above). These airfoils will be spaced evenly along the wing length.

***wing_angle***: a set of angles, \[sweep,slope\]. Sweep is along the x axis, slope along the y axis. (optional, default=[0,0])

***wing_length***: length of the wing (optional, default=1000)
