WALL_THICKNESS = 1;
HEIGHT = 120;
DIAMETER = 115;
INNER_DIA = 50;
N_PARTS = 5;

$fn = 50;

union() {
    difference() {
        cylinder(d = INNER_DIA + 2 * WALL_THICKNESS, h = HEIGHT);
        cylinder(d = INNER_DIA, h = HEIGHT);
    }
    for(i = [1:N_PARTS]) {
        rotate([0, 0, i * 360/N_PARTS])
        translate([INNER_DIA/2, -WALL_THICKNESS/2, 0])
        cube(size = [(DIAMETER-INNER_DIA)/2, WALL_THICKNESS, HEIGHT]);
    }
}
