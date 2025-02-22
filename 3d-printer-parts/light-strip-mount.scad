STRIP_LENGTH = 100;
STRIP_WIDTH = 10;
STRIP_DEPTH = 0.5;

BASE_THICKNESS = 2;
LENGTH = STRIP_LENGTH + 10;
WIDTH = STRIP_WIDTH + 5;

MOUNT_HOLE_DIA = 4;
MOUNT_OFFSET_X = -8;
MOUNT_OFFSET_Z = 5;

$fn = 30;

module strip() {
    translate([0, 0, STRIP_DEPTH/2])
    cube(size = [STRIP_WIDTH, STRIP_LENGTH, STRIP_DEPTH], center = true);
}

module mount() {
    difference() {
        hull() {
            cylinder(d = BASE_THICKNESS, h = WIDTH, center = true);
            translate([MOUNT_OFFSET_Z, 0, MOUNT_OFFSET_X])
            rotate([90, 0, 0])
            cylinder(d = 3   * MOUNT_HOLE_DIA, h = BASE_THICKNESS, center = true);
        }
        translate([MOUNT_OFFSET_Z, 0, MOUNT_OFFSET_X])
        rotate([90, 0, 0])
        cylinder(d = MOUNT_HOLE_DIA, h = BASE_THICKNESS, center = true);

    }
}

module base() {
    hull() {
        translate([0, -(LENGTH-WIDTH)/2, 0])
        cylinder(d = WIDTH, h = BASE_THICKNESS);
        translate([0, LENGTH/2, BASE_THICKNESS/2])
        rotate([0, 90, 0])
        cylinder(d = BASE_THICKNESS, h = WIDTH, center = true);
    }

    translate([0, LENGTH/2, BASE_THICKNESS/2])
    rotate([0, -90, 0])
    mount();
}

difference() {
    base();
    translate([0, 0, BASE_THICKNESS-STRIP_DEPTH])
    strip();
}
