OUTER_DIAMETER = 42;
INNER_DIAMETER = 24;
HEIGHT = 23;

SHAFT_HEIGHT = 14;
SHAFT_DIAMETER = 22.5;
SHAFT_MOUNT_WIDTH = 19.5;

MOUNTING_HOLE_DIA = 3.5;
MOUNTING_HOLE_HEAD_DIA = 6;
MOUNTING_HOLE_NUT_DIA = 7;

$fn = 100;

LEFT = false;

module grip_pos() {
    cylinder(d = OUTER_DIAMETER, h = HEIGHT, $fn = 23);
}

module grip_neg() {
    union() {
        translate([0, 0, SHAFT_HEIGHT])
        cylinder(d = INNER_DIAMETER, h = HEIGHT-SHAFT_HEIGHT);

        intersection() {
            cylinder(d = SHAFT_DIAMETER, h = SHAFT_HEIGHT);
            translate([-SHAFT_MOUNT_WIDTH/2, -SHAFT_DIAMETER/2, 0])
            cube(size = [SHAFT_MOUNT_WIDTH, SHAFT_DIAMETER, SHAFT_HEIGHT]);
        }
    }
}

module mounting_hole() {
    L = OUTER_DIAMETER;
    rotate([0, 90, 0])
    translate([0, 0, -L/2])
    union() {
        cylinder(d = MOUNTING_HOLE_HEAD_DIA, h = L/3);
        translate([0, 0, L/3])
        cylinder(d = MOUNTING_HOLE_DIA, h = L/3);
        translate([0, 0, 2*L/3])
        cylinder(d = MOUNTING_HOLE_NUT_DIA, h = L/3, $fn = 6);
    }
}

module mounting_holes() {
    union() {
        translate([0, -OUTER_DIAMETER/3, HEIGHT/2])
        mounting_hole();
        
        translate([0, OUTER_DIAMETER/3, HEIGHT/2])
        mounting_hole();
    }
}

intersection() {
    difference() {
        grip_pos();
        grip_neg();
        mounting_holes();
    }
    translate([LEFT ? 0 : -OUTER_DIAMETER, -OUTER_DIAMETER/2, 0])
    cube(size = [OUTER_DIAMETER, OUTER_DIAMETER, HEIGHT]);
}