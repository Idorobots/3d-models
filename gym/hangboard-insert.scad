THICKNESS = 5;
WIDTH = 21;
LENGTH = 74;

HOLE_OFFSET_X = 30;
HOLE_OFFSET_Y = 0;
HOLE_DIA_TOP = 8;
HOLE_DIA_BOT = 5;

SLOT_OFFSET_X = 0;
SLOT_OFFSET_Y = 8;
SLOT_WIDTH = 1.5;
SLOT_LENGTH = 50;

NUB_DIA = 10;
NUB_OFFSET = 1;

$fn = 100;

difference() {
    union() {
        hull() {
            for(i = [-1, 1]) {
                translate([i * (LENGTH-WIDTH)/2, 0, 0])
                cylinder(d = WIDTH, h = THICKNESS);
            }

            translate([0, (WIDTH-NUB_DIA)/2 + NUB_OFFSET, 0])
            cylinder(d = NUB_DIA, h = THICKNESS);
        }
    }

    translate([HOLE_OFFSET_X, HOLE_OFFSET_Y])
    cylinder(d1 = HOLE_DIA_BOT, d2 = HOLE_DIA_TOP, h = THICKNESS);

    translate([SLOT_OFFSET_X, SLOT_OFFSET_Y, 0])
    hull() {
        for(i = [-1, 1]) {
            translate([i * (SLOT_LENGTH-SLOT_WIDTH)/2, 0, 0])
            cylinder(d = SLOT_WIDTH, h = THICKNESS);
        }
    }

}
