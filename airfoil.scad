$airfoil_fn = 120;
$close_airfoils = true;

//https://en.wikipedia.org/wiki/NACA_airfoil

  function foil_y(x, c, t) = 
(5*t*c)*( ( 0.2969 * sqrt(x/c) ) - ( 0.1260*(x/c) ) - ( 0.3516*pow((x/c),2) ) + ( 0.2843*pow((x/c),3) ) - ( ( $close_airfoils ? 0.1036 : 0.1015)*pow((x/c),4) ) ); //NACA symetrical airfoil formula
  function camber(x,c,m,p) = ( x <= (p * c) ? 
    ( ( (c * m)/pow( p, 2 ) ) * ( ( 2 * p * (x / c) ) - pow( (x / c) , 2) ) ) :
    ( ( (c * m)/pow((1 - p),2) ) * ( (1-(2 * p) ) + ( 2 * p * (x / c) ) - pow( (x / c) ,  2)))
    );
  function theta(x,c,m,p) = ( x <= (p * c) ? 
    atan( ((m)/pow(p,2)) * (p - (x / c)) ) :
    atan( ((m)/pow((1 - p),2)) * (p - (x / c))  ) 
    );
  function camber_y(x,c,t,m,p, upper=true) = ( upper == true ?
  ( camber(x,c,m,p) + (foil_y(x,c,t) * cos( theta(x,c,m,p) ) ) ) :
  ( camber(x,c,m,p) - (foil_y(x,c,t) * cos( theta(x,c,m,p) ) ) )
  );
  function camber_x(x,c,t,m,p, upper=true) = ( upper == true ?
  ( x - (foil_y(x,c,t) * sin( theta(x,c,m,p) ) ) ) :
  ( x + (foil_y(x,c,t) * sin( theta(x,c,m,p) ) ) )
  );
  
  
module airfoil_poly (c = 100, naca = 0015) {
  $close_airfoils = ($close_airfoils != undef) ? $close_airfoils : false;
  $airfoil_fn = ($airfoil_fn != undef) ? $airfoil_fn : 100;
  res = c/$airfoil_fn; //resolution of foil poly 
  t = ((naca%100)/100); //establish thickness/length ratio
  m = ( (floor((((naca-(naca%100))/1000))) /100) );
  p = ((((naca-(naca%100))/100)%10) / 10);
    
  // points have to be generated with or without camber, depending. 
    points_u = ( m == 0 || p == 0) ?
     [for (i = [0:res:c]) let (x = i, y = foil_y(i,c,t) ) [x,y]] :
     [for (i = [0:res:c]) let (x = camber_x(i,c,t,m,p), y = camber_y(i,c,t,m,p) ) [x,y]] ;
    
    points_l = ( m == 0 || p == 0) ?
     [for (i = [c:-1*res:0]) let (x = i, y = foil_y(i,c,t) * -1 ) [x,y]] :
     [for (i = [c:-1*res:0]) let (x = camber_x(i,c,t,m,p,upper=false), y = camber_y(i,c,t,m,p, upper=false) ) [x,y]] ;    
 
   polygon(concat(points_u,points_l)); //draw poly
}

//Todo: Wings, w/angles
// Airfoil definition = [c,naca]
module airfoil_simple_wing (airfoils=false, wing_angle=[0,0], wing_length=1000){
    
    if (airfoils != false) {
        if (len(airfoils[0]) == undef) {
            hull(){
                
                linear_extrude(0.1) airfoil_poly(airfoils[0],airfoils[1]);
                
                translate([(sin(wing_angle[0]) * wing_length),(sin(wing_angle[1]) * wing_length),wing_length])          linear_extrude(0.1) airfoil_poly(airfoils[0],airfoils[1]);
            
            }
        }
        else {
            union(){
                for( i=[1:len(airfoils)-1] ) {
                    hull() {
                        
                        translate([(sin(wing_angle[0]) * wing_length * (i-1)/len(airfoils)),
                        (sin(wing_angle[1]) * wing_length * (i-1)/len(airfoils)),
                        wing_length * (i-1)/len(airfoils)])
                        linear_extrude(0.1) airfoil_poly(airfoils[(i-1)][0],airfoils[(i-1)][1]);
                        
                        translate([(sin(wing_angle[0]) * wing_length * i/len(airfoils)),
                        (sin(wing_angle[1]) * wing_length * i/len(airfoils)),
                        wing_length * i/len(airfoils)])
                        linear_extrude(0.1) airfoil_poly(airfoils[i][0],airfoils[i][1]);

                    }
                }
            }
        }
    } else {
        echo("No Airfoils defined! Airfoils should be a set of [chord, naca]. Specify one for a uniform wing, two or more for compound wing. If specifying only one, do not put it in a set/vector. Multiple airfoils will be spaced evenly along the wing length.");
    }
}
module airfoil_help(){
    echo("<u><b>Parametric Airfoil and Wing generator v0.1</u></b> <br>\
    For a brief overview of the math and specifications used, see https://en.wikipedia.org/wiki/NACA_airfoil<br>\
    <u>Globals:</u><br> \
    <b><i>$close_airfoils</b></i>: Defines whether you want the back of your air foils closed, or if you want them open (default: false) <br>\
    <b><i>$airfoil_fn</b></i>: number of sides for your airfoil. (default: 100) <br>\
    <u>airfoil_poly help:</u><br>\
    <b><i>c</b></i>: Chord length, this is the chord length of your airfoil. (default: 100) <br>\
    <b><i>naca</b></i>: The NACA 4-digit specification for your airfoil. (default: 0015) <br>\
    <u>airfoil_simple_wing help:</u> <br>\
    <b><i>airfoils</b></i>: Airfoils should be a set of [chord, naca]. Specify one for a uniform wing, two or more in a vector for compound wing. If specifying only one, do not put it in a set/vector. Multiple airfoils will be spaced evenly along the wing length. (required)<br>\
    <b><i>wing_angle</b></i>: a set of angles, [sweep,slope] (optional, default=[0,0])<br>\
    <b><i>wing_length</b></i>: length of the wing (optional, default=1000)");
}
airfoil_help();
//translate([0,0,100]) airfoil_poly();
//airfoil_simple_wing(airfoils=[[100,0015],[200,2414],[100,0015],[200,2414],[100,0015]], wing_angle=[20,-20]);