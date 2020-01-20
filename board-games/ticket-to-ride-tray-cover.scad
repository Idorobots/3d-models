WIDTH = 70;
LENGTH = 100;
THICKNESS = 0.8;
CORNER_DIA = 20;

ORING_DIA = 1.6;
HOLE_DIA = 7;
ORING_MOUNT_HEIGHT = THICKNESS * 2 + ORING_DIA;

$fn = 50;

module rounded_rect(width, length, thickness, corner_dia) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (width-corner_dia)/2, j*(length-corner_dia)/2, 0])
                cylinder(d = corner_dia, h = thickness);
            }
        }
    }
}

module oring_mount_neg() {
    union() {
        cylinder(d = HOLE_DIA, h = ORING_MOUNT_HEIGHT);
        translate([0, 0, THICKNESS + ORING_DIA/2])
        rotate_extrude() {
            translate([-HOLE_DIA/2, 0, 0])
            circle(d = ORING_DIA);
        }
    }
}

difference() {
    union() {
        rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);
        cylinder(d = HOLE_DIA + ORING_DIA + 2 * THICKNESS, h = ORING_MOUNT_HEIGHT);
    }
    
    oring_mount_neg();
}