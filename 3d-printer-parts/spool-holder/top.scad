THICKNESS = 1.5;
HEIGHT = 30;
BEARING_OUTER_DIAMETER = 37.5;
BEARING_THICKNESS = 12;
PLATFORM_DIAMETER = 70;
LIP_HEIGHT = BEARING_THICKNESS;
LIP_DIAMETER = 50;
LIP_TOP_DIAMETER = 25;

$fn = 200;

difference() {
    union() {
        cylinder(h = THICKNESS, d = PLATFORM_DIAMETER);
        cylinder(h = LIP_HEIGHT, d = LIP_DIAMETER);
        translate([0, 0, LIP_HEIGHT])
            cylinder(h = HEIGHT - THICKNESS - BEARING_THICKNESS, d1 = LIP_DIAMETER, d2 = LIP_TOP_DIAMETER);
    }
    union() {
        translate([0, 0, -1])
            cylinder(h = BEARING_THICKNESS+1, d =      BEARING_OUTER_DIAMETER);
        translate([0, 0, BEARING_THICKNESS-1])
            cylinder(h = HEIGHT, d1 = BEARING_OUTER_DIAMETER-1, d2 = 0);
    }
}