OUTER_DIA = 18;
INNER_DIA = 13;
INLET_DIA = 15;
INLET_HEIGHT = 8;
EXTENSION = 2;

$fn = 100;

difference() {
    union() {
        cylinder(d = OUTER_DIA, h = EXTENSION);
        cylinder(d = INLET_DIA, h = INLET_HEIGHT + EXTENSION);
    }

    cylinder(d = INNER_DIA, h = INLET_HEIGHT + EXTENSION);
}
