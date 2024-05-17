OUTER_DIA = 24;
INNER_DIA = 11;
HEIGHT = 190;

BASE_DIA = 60;
BASE_THICKNESS = 5;
BASE_SUPPORT_DIA = 42;
BASE_SUPPORT_THICKNESS = 3;

$fn = 100;

difference() {
    union() {
        cylinder(d = OUTER_DIA, h = HEIGHT);
        cylinder(d = BASE_DIA, h = BASE_THICKNESS);
    }
    cylinder(d = INNER_DIA, h = HEIGHT);
    cylinder(d = BASE_SUPPORT_DIA, h = BASE_SUPPORT_THICKNESS);
}
