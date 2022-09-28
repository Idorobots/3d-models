LEG_SPACING = 70;
LEG_DIA = 5;
LEG_ANGLE = 2;

MOUNT_DIA_BOT = 10;
MOUNT_DIA_TOP = 8;
MOUNT_HEIGHT = 5;

BASE_WIDTH = LEG_SPACING + MOUNT_DIA_BOT;
BASE_LENGTH = LEG_SPACING + MOUNT_DIA_BOT;
BASE_CORNER_DIA = MOUNT_DIA_BOT;

THICKNESS = 1.5;
HEIGHT = 12;

$fn = 100;

module legs() {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * LEG_SPACING/2, j * LEG_SPACING/2, 0])
            rotate([j * LEG_ANGLE, -i * LEG_ANGLE, 0])
            cylinder(d = LEG_DIA, h = HEIGHT * 3, center = true);
        }
    }
}

module rounded_rect(width, length, height, corner_dia) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (width-corner_dia)/2, j * (length-corner_dia)/2, 0])
                cylinder(d = corner_dia, h = height);
            }
        }
    }
}

module base() {
    union() {
        rounded_rect(BASE_WIDTH, BASE_LENGTH, THICKNESS, BASE_CORNER_DIA);
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * LEG_SPACING/2, j * LEG_SPACING/2, THICKNESS])
                cylinder(d1 = MOUNT_DIA_BOT, d2 = MOUNT_DIA_TOP, h = MOUNT_HEIGHT);
            }
        }
    }
}

difference() {
    base();
    #legs();
}
