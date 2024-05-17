THICKNESS = 5;
WIDTH = 22;
LENGTH = 75;

HOLE_DIA_TOP = 15;
HOLE_DIA_BOT = 12;

$fn = 100;

difference() {
    hull() {
        for(i = [-1, 1]) {
            translate([i * (LENGTH-WIDTH)/2, 0, 0])
            cylinder(d = WIDTH, h = THICKNESS);
        }
    }

    cylinder(d1 = HOLE_DIA_BOT, d2 = HOLE_DIA_TOP, h = THICKNESS);
}
