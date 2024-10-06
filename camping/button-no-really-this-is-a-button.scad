THICKNESS = 3;
LENGTH_TOP = 24;
LENGTH_BOT = 42;
WIDTH = 10;

CORNER_DIA = 3;

SLOT_WIDTH = 3;
SLOT_LENGTH = 22;

$fn = 50;

difference() {
    hull() {
        for(i = [-1, 1]) {
            translate([i * (LENGTH_TOP - CORNER_DIA)/2, (WIDTH - CORNER_DIA)/2, 0])
            sphere(d = CORNER_DIA);
        }
        for(i = [-1, 1]) {
            translate([i * (LENGTH_BOT - CORNER_DIA)/2, -(WIDTH - CORNER_DIA)/2, 0])
            sphere(d = CORNER_DIA);
        }
    }
    hull() {
        for(i = [-1, 1]) {
            translate([i * (SLOT_LENGTH - SLOT_WIDTH)/2, 0, -THICKNESS/2])
            cylinder(d = SLOT_WIDTH, h = THICKNESS);
        }
    }
}
