BOTTLE_INNER_DIA = 35;
BOTTLE_OUTER_DIA = 46;

HOLE_INNER_DIA = 12;
HOLE_OUTER_DIA = 20;

HEIGHT = 5;
HOLE_DISTANCE = 36;

$fn = 100;

difference() {
    hull() {
        cylinder(d = BOTTLE_OUTER_DIA, h = HEIGHT);
        translate([HOLE_DISTANCE, 0, 0])
        cylinder(d = HOLE_OUTER_DIA, h = HEIGHT);
    }
    cylinder(d = BOTTLE_INNER_DIA, h = HEIGHT);
    translate([HOLE_DISTANCE, 0, 0])
    cylinder(d = HOLE_INNER_DIA, h = HEIGHT);
}
