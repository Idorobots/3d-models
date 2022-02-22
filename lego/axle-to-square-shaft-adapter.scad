DELTA = 0.1;

HEIGHT = 20;
DIA = 10 + DELTA;
SHAFT_WIDTH = 2.75 + DELTA;

AXLE_DIA = 4.8 + DELTA;
AXLE_WIDTH = 1.85 + DELTA/2;

use <beam.scad>;

$fn = 100;

module adapter(dia, ah, sh) {
  difference() {
    cylinder(d = dia, h = ah + sh);
    rotate([0, 0, 45])
    translate([-SHAFT_WIDTH/2, -SHAFT_WIDTH/2, 0])
    cube(size = [SHAFT_WIDTH, SHAFT_WIDTH, sh]);
    translate([0, 0, sh])
    axle_hole(AXLE_DIA, AXLE_WIDTH, ah);
  }
}

adapter(DIA, HEIGHT/3, 2*HEIGHT/3);