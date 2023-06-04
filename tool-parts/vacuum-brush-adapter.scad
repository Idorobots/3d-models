OUTER_DIA = 22;
OUTER_CURVE = 40;
OUTER_HEIGHT = 15;

INNER_HEIGHT = 9;
INNER_DIA = 13;
INNER_WIDTH = 12;

LIP_WIDTH = 11;
LIP_HEIGHT = 3;

MOUNT_HOLE_DIA = 3;
MOUNT_HOLE_HEAD_DIA = 6;
MOUNT_HOLE_HEAD_HEIGHT = 2;

ARMS = 3;
ARM_LENGTH = 50;
ARM_WIDTH = 10;
ARM_THICKNESS_TIP = 1;
ARM_THICKNESS_BASE = 3;

$fn = 100;

module body() {
    intersection() {
        cylinder(d = OUTER_DIA, h = OUTER_HEIGHT);
        translate([0, 0, OUTER_HEIGHT - OUTER_CURVE/2])
        sphere(d = OUTER_CURVE);
    }
}

module nub() {
    intersection() {
        union() {
            translate([-INNER_WIDTH/2, -INNER_WIDTH/2, LIP_HEIGHT])
            cube(size = [INNER_WIDTH, INNER_WIDTH, INNER_HEIGHT]);
            translate([-LIP_WIDTH/2, -LIP_WIDTH/2, 0])
            cube(size = [LIP_WIDTH, LIP_WIDTH, LIP_HEIGHT]);
        }

        cylinder(d = INNER_DIA, h = INNER_HEIGHT);
    }

    cylinder(d = MOUNT_HOLE_HEAD_DIA, h = INNER_HEIGHT + MOUNT_HOLE_HEAD_HEIGHT, $fn = 6);
    cylinder(d = MOUNT_HOLE_DIA, h = OUTER_HEIGHT);
}

module mount() {
    difference() {
        body();
        translate([0, 0, OUTER_HEIGHT])
        rotate([180, 0, 0])
        arms_base();
        nub();
    }
}

module arm() {
    hull() {
        cylinder(d = ARM_WIDTH, h = ARM_THICKNESS_BASE);
        translate([ARM_LENGTH - ARM_WIDTH, 0, 0])
        cylinder(d = ARM_WIDTH, h = ARM_THICKNESS_TIP);
    }
}

module arms_base() {
    for(i = [0:ARMS-1]) {
        rotate([0, 0, i * 360/ARMS])
        arm();
    }
}

module arms() {
    difference() {
        arms_base();
        cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_HEIGHT);
        cylinder(d = MOUNT_HOLE_DIA, h = OUTER_HEIGHT);
    }
}

!mount();
arms();
