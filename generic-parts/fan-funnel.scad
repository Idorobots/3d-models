WIDTH = 80;
THICKNESS = 1;
HEIGHT = 100;
FAN_DIA = WIDTH - 2 * THICKNESS;
FAN_MOUNT_HOLE_SPACING = 71;
FAN_MOUNT_HOLE_DIA = 4;
OUTLET_DIA = 30;
CORNER_DIA = 5;

$fn = 50;

module mounting_holes(spacing, thickness, dia) {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * spacing/2, j * spacing/2, 0])
            cylinder(d = dia, h = thickness);
        }
    }
}

module rounded_square(width, thickness, corner_dia) {
    hull() {
        mounting_holes(width - corner_dia, thickness, corner_dia);
    }
}

difference() {
    union() {
        rounded_square(WIDTH, THICKNESS, CORNER_DIA);
        cylinder(d1 = WIDTH, d2 = OUTLET_DIA + 2 * THICKNESS, h = HEIGHT);
    }
    mounting_holes(FAN_MOUNT_HOLE_SPACING, THICKNESS, FAN_MOUNT_HOLE_DIA);
    cylinder(d1 = FAN_DIA, d2 = OUTLET_DIA, h = HEIGHT);
}
