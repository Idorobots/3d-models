ROD_DIA = 4.2;
SPRING_LOOP_DIA = 3;
THICKNESS = 2;
CLAMPING_FACTOR = 0.75;

$fn = 50;

module ring(outer_dia, inner_dia, height) {
    difference() {
        cylinder(d = outer_dia, h = height);
        cylinder(d = inner_dia, h = height);
    }
}

difference() {
    union() {
        d = ROD_DIA + 2 * THICKNESS;
        ring(d, ROD_DIA, THICKNESS);

        translate([d/2 + SPRING_LOOP_DIA/2, 0, 0])
        ring(SPRING_LOOP_DIA + THICKNESS, SPRING_LOOP_DIA, THICKNESS);
    }
    translate([-ROD_DIA/2, 0, 0])
    cube(size = [2 * THICKNESS, ROD_DIA * CLAMPING_FACTOR, 2 * THICKNESS], center = true);
}