WIDTH = 10;
HEIGHT = 10;
LENGTH = 50;

SLOT_WIDTH = 6;
SLOT_SPACING = 31;

MOUNTING_HOLE_DIA = 4;
MOUNTING_HOLE_HEAD_DIA = 10;
MOUNTING_HOLE_HEAD_HEIGHT = 5;

$fn = 50;

difference() {
    union() {
        intersection() {
            cylinder(d = LENGTH, h = HEIGHT);
            translate([-LENGTH, -LENGTH/2, 0])
            cube(size = [LENGTH, LENGTH, HEIGHT]);
        }
        translate([0, -LENGTH/2, 0])
        cube(size = [WIDTH, LENGTH, HEIGHT]);
    }

    translate([-LENGTH/4, 0, 0]) {
        cylinder(d = MOUNTING_HOLE_DIA, h = HEIGHT);
        cylinder(d = MOUNTING_HOLE_HEAD_DIA, h = MOUNTING_HOLE_HEAD_HEIGHT);
    }

    for(i = [-1, 1]) {
        translate([WIDTH/2, i * SLOT_SPACING/2, 0])
        cube(size = [WIDTH, SLOT_WIDTH, HEIGHT*2], center = true);
    }

    translate([SLOT_WIDTH/2, LENGTH/2, HEIGHT-SLOT_WIDTH/2])
    rotate([90, 0, 0])
    hull() {
        cylinder(d = SLOT_WIDTH, h = LENGTH);
        translate([0, SLOT_WIDTH, 0])
        cylinder(d = SLOT_WIDTH, h = LENGTH);
    }
}
