LOOP_DIA = 23;
HOOK_DIA = 15;
THICKNESS = 5;
LOOP_WIDTH = LOOP_DIA + 2 * THICKNESS;
HOOK_WIDTH = HOOK_DIA + 2 * THICKNESS;
HOOK_ANGLE = 210;
LENGTH = 80;

$fn = 50;

module loop(inner_dia, outer_dia, thickness) {
    difference() {
        cylinder(d = outer_dia, h = thickness, center = true);
        cylinder(d = inner_dia, h = thickness, center = true);
    }
}

module half_loop(inner_dia, outer_dia, thickness) {
    intersection() {
        loop(inner_dia, outer_dia, thickness);
        translate([outer_dia/2, 0, 0])
        cube(size = [outer_dia, outer_dia, 2* thickness], center = true);
    }
}

module hook(inner_dia, outer_dia, thickness, angle) {
    union() {
        rotate([0, 0, 180 - angle])
        union() {
            half_loop(inner_dia, outer_dia, thickness);
            translate([0, -(outer_dia+inner_dia)/4, 0])
            cylinder(d = thickness, h = thickness, center = true);
        }
        half_loop(inner_dia, outer_dia, thickness);
    }
}

union() {
    translate([-LOOP_WIDTH/2, 0, 0])
    loop(LOOP_DIA, LOOP_WIDTH, THICKNESS);

    bar_len = LENGTH-LOOP_WIDTH-HOOK_WIDTH/2;
    translate([bar_len, -(HOOK_DIA+THICKNESS)/2, 0])
    hook(HOOK_DIA, HOOK_WIDTH, THICKNESS, HOOK_ANGLE);

    translate([bar_len/2 - 1, 0, 0])
    cube(size = [bar_len + 2,THICKNESS, THICKNESS], center = true);
}
