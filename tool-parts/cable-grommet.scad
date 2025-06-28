HEIGHT = 9;
INNER_DIA = 57.5; // 21.5;
OUTER_DIA = 60.5; // 23.5;
HOLE_DIA = 9; // 16;
FLANGE_DIA = 70; // 30;
FLANGE_THICKNESS = 1.5; // 2;

$fn = 100;

difference() {
    union() {
        cylinder(d = FLANGE_DIA, h = FLANGE_THICKNESS);
        cylinder(d = OUTER_DIA, h = HEIGHT);
    }
    translate([0, 0, FLANGE_THICKNESS])
    cylinder(d = INNER_DIA, h = HEIGHT);
    cylinder(d = HOLE_DIA, h = HEIGHT);
}
