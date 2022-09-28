MOUNT_WIDTH = 3.2;
MOUNT_DEPTH = 5;
MOUNT_SPACING = 16;

BAR_WIDTH = 1;
BAR_LENGTH = 25;
BAR_SPACING = 4;

CROSSBAR_WIDTH = 1;
CROSSBAR_LENGTH = BAR_SPACING * 25;

SINE = false;
SINE_LENGTH = 10;
PI = 3.14158692;

module mounts() {
    for(i = [-1, 1]) {
        translate([0, i * MOUNT_SPACING/2, MOUNT_WIDTH/2])
        cube(size = [MOUNT_DEPTH, MOUNT_WIDTH, MOUNT_WIDTH], center = true);
    }
}

module crossbars() {
    for(i = [-1, 1]) {
        translate([0, i * MOUNT_SPACING/2, CROSSBAR_WIDTH/2 + BAR_WIDTH])
        cube(size = [CROSSBAR_LENGTH, CROSSBAR_WIDTH, CROSSBAR_WIDTH], center = true);
    }
}

module bars() {
    for(i = [0:((CROSSBAR_LENGTH -  2 * BAR_SPACING)/BAR_SPACING)]) {
        l = SINE ? sin(180 * (i * BAR_SPACING)/(CROSSBAR_LENGTH - 2 * BAR_SPACING)) * SINE_LENGTH : 0;
        translate([(i + 1) * BAR_SPACING - CROSSBAR_LENGTH/2, l/2, BAR_WIDTH/2])
        cube(size = [BAR_WIDTH, BAR_LENGTH + l, BAR_WIDTH], center = true);
    }
}

union() {
    translate([-CROSSBAR_LENGTH/2, 0, 0])
    mounts();

    crossbars();

    bars();

    translate([CROSSBAR_LENGTH/2, 0, 0])
    rotate([0, 0, 180])
    mounts();
}
