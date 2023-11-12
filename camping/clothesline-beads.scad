LINE_DIA = 3.25;
LINE_DISTANCE = 2.5;

BEAD_DIA_MAX = 9;
BEAD_DIA_MIN = 7;
BEAD_HEIGHT = 9;

$fn = 100;

difference() {
    hull() {
        translate([-LINE_DISTANCE/2, 0, 0])
        cylinder(d = BEAD_DIA_MIN, h = BEAD_HEIGHT, center = true);
        translate([-LINE_DISTANCE/2, 0, 0])
        sphere(d = BEAD_DIA_MAX);

        translate([LINE_DISTANCE/2, 0, 0])
        cylinder(d = BEAD_DIA_MIN, h = BEAD_HEIGHT, center = true);
        translate([LINE_DISTANCE/2, 0, 0])
        sphere(d = BEAD_DIA_MAX);
    }

    translate([-LINE_DISTANCE/2, 0, 0])
    cylinder(d = LINE_DIA, h = BEAD_HEIGHT, center = true);

    translate([LINE_DISTANCE/2, 0, 0])
    cylinder(d = LINE_DIA, h = BEAD_HEIGHT, center = true);
}
