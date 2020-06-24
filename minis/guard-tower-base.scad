MOUNDS_SEED = 12345;

LEG_SPACING = 70;
LEG_DIA = 5;
LEG_ANGLE = 1;

use <skull-totem.scad>;

THICKNESS = 1.5;
HEIGHT = 12;

$fn = 100;

module legs() {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * LEG_SPACING/2, j * LEG_SPACING/2, 0])
            rotate([j * LEG_ANGLE, -i * LEG_ANGLE, 0])
            cylinder(d = LEG_DIA, h = HEIGHT * 3, center = true);
        }
    }
}

module base() {
    union() {
        cylinder(d = 2*LEG_SPACING/sqrt(2), h = THICKNESS);
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * LEG_SPACING/2, j * LEG_SPACING/2, 0])
                mound(MOUNDS_SEED - i * 235 + j * 23);
            }
        }
    }
}

difference() {
    base();
    #legs();
}