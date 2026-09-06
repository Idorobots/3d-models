WIDTH = 25;
LENGTH = 90;
THICKNESS = 4;
THICKNESS_END = 4;
GAP = 5.7;

$fn = 100;


module leg(off = 0) {
  hull() {
    cylinder(d = THICKNESS, h = WIDTH);
    translate([LENGTH - THICKNESS - GAP, off, 0])
    cylinder(d = THICKNESS_END, h = WIDTH);
  }
}

difference() {
  cylinder(d = THICKNESS * 2 + GAP, h = WIDTH);
  #cylinder(d = GAP, h = WIDTH);
  #translate([0, -WIDTH/2, 0])
  cube(WIDTH);
}

translate([0, (GAP+THICKNESS)/2])
leg();

translate([0, -(GAP+THICKNESS)/2])
  leg(GAP - 0.5);
