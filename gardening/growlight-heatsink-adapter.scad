HEATSINK_OUTER_DIA = 33;
HEATSINK_INNER_DIA = 17.5;
HEATSINK_DEPTH = 10;
INNER_DIA = 14.5;
OUTER_DIA = 16;
HEIGHT = 23;

$fn = 100;

module base() {
    //cylinder(d1 = OUTER_DIA, d2 = HEATSINK_OUTER_DIA, h = HEIGHT - HEATSINK_DEPTH);
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
            cylinder(d = HEATSINK_INNER_DIA, h = HEIGHT - 5);
            base();
        }

        cylinder(d = INNER_DIA, h = HEIGHT);
    }
}

adapter();
