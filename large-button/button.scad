DIAMETER = 28;
HOLES = 4;
HOLE_DIAMETER = 2.5;
HOLE_SPACING = 6;
HEIGHT = 4;
ROUNDNESS = 2;


$fn = 60;


module ring(r, h, n) {
  rotate_extrude()
  hull() {
    translate([r-n, n, 0])
    circle(n); 
    translate([r-n, h-n, 0])
    circle(n); 
  }
}

difference() {
    union() {
        ring(r = DIAMETER/2, h = HEIGHT, n = ROUNDNESS);
        cylinder(r = DIAMETER/2-ROUNDNESS, h = HEIGHT);
    }
    
    
    for(i = [0 : 360/HOLES : 360]) {
        
        translate([HOLE_SPACING/2*cos(i),
                   HOLE_SPACING/2*sin(i),
                   0])
        cylinder(
            r = HOLE_DIAMETER/2, 
            h = HEIGHT*3, 
            center = true
        );   
    }
}