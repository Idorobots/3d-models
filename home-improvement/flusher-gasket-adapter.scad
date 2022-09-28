OUTER_DIA = 31;
INNER_DIA = 28;
OPENING_DIA = INNER_DIA - 2 * 1.5;
THICKNESS = 0.5;
HEIGHT = 2 + THICKNESS;

$fn = 500;

difference() {
    cylinder(d = OUTER_DIA, h = HEIGHT);
    translate([0, 0,THICKNESS])
    cylinder(d = INNER_DIA, h = HEIGHT);
    cylinder(d = OPENING_DIA, h = HEIGHT);
}
