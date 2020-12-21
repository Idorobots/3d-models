MOUNT_HOLE_DIA = 4.5;

WIDTH = 20;
THICKNESS = 5;

$fn = 100;


module hook() {
  wt = 2 * THICKNESS;
  difference() {
    cube(size = [WIDTH + wt, WIDTH, WIDTH + wt], center = true);
    translate([0, 0, -wt/2])
    cube(size = [WIDTH, WIDTH, WIDTH + wt], center = true);
    
    rotate([0, 90, 0])
    #cylinder(d = MOUNT_HOLE_DIA, h = WIDTH);
  }
}

hook();