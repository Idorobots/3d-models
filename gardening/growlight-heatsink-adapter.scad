HEATSINK_OUTER_DIA = 33;
HEATSINK_INNER_DIA = 17;
INNER_DIA_DELTA = 1;
HEATSINK_DEPTH = 10;
INNER_DIA = 14.5;
OUTER_DIA = 16;
HEIGHT = 23;

$fn = 100;

module base() {
    intersection() {
        translate([0, 0, HEATSINK_OUTER_DIA/2 - 2])
        sphere(d = HEATSINK_OUTER_DIA);
        cylinder(d = HEATSINK_OUTER_DIA, h = HEIGHT - HEATSINK_DEPTH);
    }
}

module adapter() {
    difference() {
        union() {
            translate([0, 0, 5])
            cylinder(d1 = HEATSINK_INNER_DIA, d2 = HEATSINK_INNER_DIA + INNER_DIA_DELTA, h = HEIGHT - 5);
            base();
        }

        cylinder(d = INNER_DIA, h = HEIGHT);
        translate([0, 0, HEIGHT - HEATSINK_DEPTH/2])
        cube(size = [HEATSINK_INNER_DIA + INNER_DIA_DELTA, INNER_DIA_DELTA, HEATSINK_DEPTH], center = true);
    }
}

adapter();
