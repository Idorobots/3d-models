HEIGHT = 15;
THICKNESS = 1.5;

HOLE_DIA = 12;

CUT_DIA_TOP = 36;
CUT_DIA_BOT = 32;

CAP_OUTER_DIA = 48;
CAP_INNER_DIA = CAP_OUTER_DIA - 2 * THICKNESS;

$fn = 100;

module cap() {
    difference() {
        cylinder(d = CAP_OUTER_DIA, h = HEIGHT);
        translate([0, 0, THICKNESS])
        cylinder(d = CAP_INNER_DIA, h = HEIGHT);
    }
}

difference() {
    union() {
        cap();
        cylinder(d1 = CUT_DIA_TOP, d2 = CUT_DIA_BOT, h = HEIGHT);
    }
    cylinder(d = HOLE_DIA, h = HEIGHT);
}
