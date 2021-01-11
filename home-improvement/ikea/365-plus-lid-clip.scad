THICKNESS = 2;

HEIGHT = 12;
DEPTH_TOP = 12;
DEPTH_BOT = 3;
LIP_DIA = 4;
WIDTH = 10;

$fn = 30;

module clip() {
  union() {
    cube(size = [WIDTH, THICKNESS, HEIGHT + 2 * THICKNESS], center = true);
    translate([0, (DEPTH_TOP + LIP_DIA + THICKNESS)/2, (HEIGHT + THICKNESS)/2])
    cube(size = [WIDTH, DEPTH_TOP + LIP_DIA , THICKNESS], center = true);
    
    translate([0, (DEPTH_TOP + LIP_DIA), HEIGHT/2])
    rotate([0, 90, 0])
    cylinder(d = LIP_DIA, h = WIDTH, center = true);

    translate([0, (DEPTH_BOT + LIP_DIA + THICKNESS)/2, -(HEIGHT + THICKNESS)/2])
    cube(size = [WIDTH, DEPTH_BOT + LIP_DIA , THICKNESS], center = true);

    translate([0, (DEPTH_BOT + LIP_DIA), -HEIGHT/2])
    rotate([0, 90, 0])
    cylinder(d = LIP_DIA, h = WIDTH, center = true);
  }
}

clip();