LIGHT_WIDTH = 8;
THICKNESS = 1.5;
INNER_DIA = 117;
OUTER_DIA = INNER_DIA + 2 * LIGHT_WIDTH + 2 * THICKNESS;
HEIGHT = 5;
LIP_HEIGHT = 3 + THICKNESS;

$fn = 50;

module rounded_ring(ring_dia, dia) {
    rotate_extrude()
    translate([-ring_dia/2, 0, 0])
    circle(d = dia);
}

module ring(outer_dia, inner_dia, height) {
    difference() {
        cylinder(d = outer_dia, h = height);
        cylinder(d = inner_dia, h = height);
    }
}

/*ring(OUTER_DIA + 2 * THICKNESS, INNER_DIA, h = HEIGHT);

translate([0, 0, THICKNESS])
ring(OUTER_DIA, INNER_DIA, HEIGHT - THICKNESS);

translate([0, 0, HEIGHT - THICKNESS])
union() {
    rounded_ring(OUTER_DIA - THICKNESS, THICKNESS);
    rounded_ring(INNER_DIA + THICKNESS, THICKNESS);
}
*/

difference() {
    union() {
        ring(OUTER_DIA, INNER_DIA - 2 * THICKNESS, THICKNESS);
        difference() {
            ring(OUTER_DIA, INNER_DIA, HEIGHT);
            translate([0, 0, THICKNESS])
            ring(OUTER_DIA - 2 * THICKNESS, INNER_DIA + 2 * THICKNESS, HEIGHT);
        }
        translate([0, 0, LIP_HEIGHT])
        rounded_ring(OUTER_DIA - 2 * THICKNESS, THICKNESS);
        translate([0, 0, LIP_HEIGHT])
        rounded_ring(INNER_DIA + 2 * THICKNESS, THICKNESS);
    }
    translate([0, 0, THICKNESS])
    cube(size = [OUTER_DIA, OUTER_DIA, HEIGHT]);
}