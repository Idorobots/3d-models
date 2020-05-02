WIDTH = 22;
LENGTH = 50;
HEIGHT = 12.1;

MOUNTING_HOLE_DIA = 7;
MOUNTING_HOLE_SPACING = 35;
MOUNTING_HOLE_OFFSET = 12 - (LENGTH - MOUNTING_HOLE_SPACING);

STRAINER_ARM_DIA = 2.5;

$fn = 100;

difference() {
    cube(size = [WIDTH, LENGTH, HEIGHT], center = true);
    
    for(i = [-1, 1]) {
        translate([0, i * MOUNTING_HOLE_SPACING/2 + MOUNTING_HOLE_OFFSET, 0])
        cylinder(d = MOUNTING_HOLE_DIA, h = HEIGHT, center = true);

        hull() {
            translate([i * (WIDTH - STRAINER_ARM_DIA)/2, 0, -(HEIGHT - STRAINER_ARM_DIA)/2])
            rotate([90, 0, 0])
            cylinder(d = STRAINER_ARM_DIA, h = LENGTH, center = true);

            translate([i * WIDTH/2, 0, -(HEIGHT - STRAINER_ARM_DIA)/2])
            rotate([90, 0, 0])
            cylinder(d = STRAINER_ARM_DIA, h = LENGTH, center = true);
        }
    }
}