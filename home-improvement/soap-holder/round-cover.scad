INNER_DIA = 134;
HEIGHT = 23.5;
LIP_HEIGHT = HEIGHT - 15;
LIP_THICKNESS = 4;
BOT_THICKNESS = HEIGHT - 19;
WALL_THICKNESS = 6;
OUTER_DIA = INNER_DIA + 2 * WALL_THICKNESS;
CORNER_DIA_BOT = 15;
CORNER_DIA_TOP = 1.25;

$fn = 200;

module rounded_ring(outer_dia, inner_dia, corner_dia) {
    rotate_extrude(angle = 360)
    hull() {
        translate([-(outer_dia-corner_dia)/2, 0, 0])
        circle(d = corner_dia);
        translate([-(inner_dia+corner_dia)/2, 0, 0])
        circle(d = corner_dia);
    }
}

module rounded_cylinder(dia, height, corner_dia) {
    translate([0, 0, corner_dia/2])
    hull() {
        rounded_ring(dia, 0, corner_dia);
        cylinder(d = dia, h = height - corner_dia/2);
    }
}

difference() {
    union() {
        rounded_cylinder(OUTER_DIA, HEIGHT - CORNER_DIA_TOP/2, CORNER_DIA_BOT);
        translate([0, 0, HEIGHT - CORNER_DIA_TOP/2])
        rounded_ring(OUTER_DIA, INNER_DIA, CORNER_DIA_TOP);
    }
    translate([0, 0, LIP_HEIGHT])
    cylinder(d = INNER_DIA, h = HEIGHT);
    translate([0, 0, BOT_THICKNESS])
    cylinder(d = INNER_DIA - 2 * LIP_THICKNESS, h = HEIGHT);
}
