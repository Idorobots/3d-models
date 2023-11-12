INNER_DIA = 12;
OUTER_DIA = 42;
THICKNESS = 1.5;

$fn = 100;

difference() {
    cylinder(d = OUTER_DIA, h = THICKNESS);
    cylinder(d = INNER_DIA, h = THICKNESS);
}
