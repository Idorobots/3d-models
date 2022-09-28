ROD_DIA = 6;
HEIGHT = 2;
THICKNESS = 1;

$fn = 30;

difference() {
    d = ROD_DIA + 2 * THICKNESS;
    hull() {
        cylinder(d = d, h = HEIGHT);

        translate([-d/2, -d/2, 0])
        cube(size = [d, 2 * THICKNESS, HEIGHT]);
    }
    translate([0, THICKNESS/2, 0])
    cylinder(d = ROD_DIA, h = HEIGHT);
}
