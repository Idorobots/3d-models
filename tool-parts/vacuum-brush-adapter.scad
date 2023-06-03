OUTER_DIA = 20;
OUTER_CURVE = 60;
OUTER_HEIGHT = 12;

INNER_HEIGHT = 8.5;
INNER_DIA = 13;
INNER_WIDTH = 12;

LIP_WIDTH = 11;
LIP_HEIGHT = 3;

NUB_DIA = 6;
NUB_HEIGHT = 2;

ARMS = 3;
ARM_LENGTH = 50;
ARM_WIDTH = 10;
ARM_THICKNESS = 1;

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

    cylinder(d = NUB_DIA, h = INNER_HEIGHT + NUB_HEIGHT);
}

module arm() {
    hull() {
        cylinder(d = ARM_WIDTH, h = ARM_THICKNESS);
        translate([ARM_LENGTH - ARM_WIDTH, 0, 0])
        cylinder(d = ARM_WIDTH, h = ARM_THICKNESS);
    }
}

difference() {
    union() {
        body();

        for(i = [0:ARMS-1]) {
            rotate([0, 0, i * 360/ARMS])
            translate([0, 0, OUTER_HEIGHT - ARM_THICKNESS])
            arm();
        }
    }
    nub();
}
