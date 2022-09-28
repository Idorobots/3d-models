HEIGHT = 28;
DIAMETER = 8;
INNER_DIAMETER = 3.6;

$fn = 30;

difference() {
    cylinder(d = DIAMETER, h = HEIGHT);
    cylinder(d = INNER_DIAMETER, h = HEIGHT);
}
