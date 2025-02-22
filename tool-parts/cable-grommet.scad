HEIGHT = 9;
INNER_DIA = 21.5;
OUTER_DIA = 23.5;
HOLE_DIA = 16;
FLANGE_DIA = 30;
FLANGE_THICKNESS = 2;

$fn = 50;

difference() {
    union() {
        cylinder(d = FLANGE_DIA, h = FLANGE_THICKNESS);
        cylinder(d = OUTER_DIA, h = HEIGHT);
    }
    translate([0, 0, FLANGE_THICKNESS])
    cylinder(d = INNER_DIA, h = HEIGHT);
    cylinder(d = HOLE_DIA, h = HEIGHT);
}
