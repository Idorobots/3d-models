CORNER_DIA = 12;
THICKNESS = 2;

MOTOR_WIDTH = 42;
MOTOR_SHAFT_DIA = 25;

MOUNTING_HOLE_SPACING = 31;
MOUNTING_HOLE_DIA = 3;

HOOK_SPACING = 30;
HOOK_INNER_DIA = 19;
HOOK_OUTER_DIA = HOOK_INNER_DIA + 2 * THICKNESS;
HOOK_LEN = 10;

SHROUD_OUTER_DIA = MOTOR_WIDTH - 2 * MOUNTING_HOLE_DIA;
SHROUD_INNER_DIA = SHROUD_OUTER_DIA - 2 * THICKNESS;

SLOT_WIDTH = 8;
SLOT_LENGTH = HOOK_SPACING * 0.66;

$fn = 50;

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

module motor_plate() {
    difference() {
        rounded_rect(MOTOR_WIDTH, MOTOR_WIDTH, THICKNESS, CORNER_DIA);
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * MOUNTING_HOLE_SPACING/2, j * MOUNTING_HOLE_SPACING/2, 0])
                cylinder(d = MOUNTING_HOLE_DIA, h = THICKNESS);
            }
        }

        cylinder(d = MOTOR_SHAFT_DIA, h = THICKNESS);
    }
}

module hook() {
    union() {
        difference() {
            cylinder(d1 = SHROUD_OUTER_DIA, d2 = HOOK_OUTER_DIA, h = HOOK_SPACING);
            cylinder(d1 = SHROUD_INNER_DIA, d2 = HOOK_INNER_DIA, h = HOOK_SPACING);

            translate([0, 0, HOOK_SPACING/2])
            rotate([-90, 0, 0])
            rounded_rect(SLOT_WIDTH, SLOT_LENGTH, SHROUD_OUTER_DIA, SLOT_WIDTH);
        }

        translate([0, 0, HOOK_SPACING])
        difference() {
            cylinder(d = HOOK_OUTER_DIA, h = HOOK_LEN);
            cylinder(d = HOOK_INNER_DIA, h = HOOK_LEN);
        }
    }
}

union() {
    motor_plate();
    hook();
}
