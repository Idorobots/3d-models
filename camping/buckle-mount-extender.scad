BELT_WIDTH = 20;
FLAP_HEIGHT = 5;
BOLT_DIA = 3.2;
BOLT_HEAD_DIA = 6;
BOLT_HEAD_HEIGHT = 3;

DISTANCE = 12;
DIA = 8;
HEIGHT = BELT_WIDTH + 2 * FLAP_HEIGHT;

$fn = 30;

difference() {
    hull() {
        cylinder(d = DIA, h = HEIGHT);
        translate([0, DISTANCE, 0])
        cylinder(d = DIA, h = HEIGHT);
    }
    cylinder(d = BOLT_DIA, h = HEIGHT);
    cylinder(d = BOLT_HEAD_DIA, h = BOLT_HEAD_HEIGHT);

    translate([-DIA/2, -DIA/2, FLAP_HEIGHT - 0.25])
    cube(size = [DIA, DIA, BELT_WIDTH + 0.5]);

    d = (DISTANCE + DIA)/2;
    translate([-d/2, DISTANCE - d/2, 0])
    cube(size = [d, d, FLAP_HEIGHT + 0.5]);

    translate([-d/2, DISTANCE - d/2, HEIGHT - FLAP_HEIGHT - 0.5])
    cube(size = [d, d, FLAP_HEIGHT + 0.5]);

    translate([0, DISTANCE, 0])
    cylinder(d = BOLT_DIA, h = HEIGHT);
}
