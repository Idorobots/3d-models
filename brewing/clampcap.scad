INTERNAL_DIA = 16.5;
INTERNAL_HEIGHT = 12;

EXTERNAL_DIA_TOP = 23;
EXTERNAL_DIA_BOT = 26;
EXTERNAL_HEIGHT = 6;

CLAMP_HOLE_DIA = 3;

ORING_THICKNESS = 1.5;

$fn = 100;

module oring(dia, thickness) {
    difference() {
        cylinder(d = dia+thickness, h = thickness, center = true);
        cylinder(d = dia-thickness, h = thickness, center = true);
    }
}

difference() {
    union() {
        cylinder(d2 = EXTERNAL_DIA_BOT, d1 = EXTERNAL_DIA_TOP, h = EXTERNAL_HEIGHT);
        cylinder(d = INTERNAL_DIA, h = EXTERNAL_HEIGHT + INTERNAL_HEIGHT);
    }

    translate([0, 0, EXTERNAL_HEIGHT + INTERNAL_HEIGHT * 1/3])
    oring(INTERNAL_DIA, ORING_THICKNESS);

    translate([0, 0, EXTERNAL_HEIGHT + INTERNAL_HEIGHT * 2/3])
    oring(INTERNAL_DIA, ORING_THICKNESS);
    
    translate([0, 0, EXTERNAL_HEIGHT/2])
    rotate([90, 0, 0])
    cylinder(d = CLAMP_HOLE_DIA, h = max(EXTERNAL_DIA_TOP, EXTERNAL_DIA_BOT), center = true);
}