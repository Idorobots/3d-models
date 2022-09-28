INNER_DIA = 25;
OUTER_DIA = 28;
INNER_LENGTH = 20;
OUTER_LENGTH = 50;
SLOT_WIDTH = 10;
N_SLOTS = 3;

$fn = 50;

union() {
    translate([0, 0, OUTER_LENGTH])
    difference() {
        cylinder(d1 = INNER_DIA, d2 = (OUTER_DIA+INNER_DIA)/2, h = INNER_LENGTH);
        for(i = [0:N_SLOTS]) {
            rotate([0, 0, i*360/N_SLOTS])
            translate([-SLOT_WIDTH/2, 0, 0])
            cube(size = [SLOT_WIDTH, OUTER_DIA, INNER_LENGTH]);
        }
    }

    cylinder(d = OUTER_DIA, h = OUTER_LENGTH);
}
