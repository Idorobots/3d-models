MOUNT_HOLE_SPACING = 40;
MOUNT_HOLE_DIA = 4;

WIDTH = MOUNT_HOLE_SPACING + MOUNT_HOLE_DIA + 10;

POLE_DIA = 16;
POLE_MOUNT_DIA = POLE_DIA + 8;
POLE_MOUNT_WIDTH = WIDTH/2;
POLE_MOUNT_LENGTH = WIDTH;
POLE_MOUNT_HEIGHT = 5;

$fn = 30;

module pole_mount() {
    difference() {
        hull() {
            translate([0, -POLE_MOUNT_LENGTH/2, POLE_MOUNT_DIA/2])
                rotate([-90, 0, 0])
                    union() {
                        cylinder(d = POLE_MOUNT_DIA, h = POLE_MOUNT_LENGTH);
                        sphere(d = POLE_MOUNT_DIA);
                    }
            translate([-POLE_MOUNT_WIDTH/2, -POLE_MOUNT_LENGTH/2, 0])
                cube(size = [POLE_MOUNT_WIDTH, POLE_MOUNT_LENGTH, POLE_MOUNT_HEIGHT]);
        }
        translate([0, -POLE_MOUNT_LENGTH/2, POLE_MOUNT_DIA/2])
            rotate([-90, 0, 0])
                cylinder(d = POLE_DIA, h = POLE_MOUNT_LENGTH);

    }
}

module mounting_holes() {
    height = (POLE_MOUNT_DIA + POLE_MOUNT_HEIGHT)/2;
    union() {
        for(i = [-1, 1]) {
            translate([0, i * MOUNT_HOLE_SPACING/2, 0])
                cylinder(d = MOUNT_HOLE_DIA, h = height);
            translate([0, i * MOUNT_HOLE_SPACING/2, height])
                cylinder(d = MOUNT_HOLE_DIA*2, h = height);
        }
    }
}

difference() {
    pole_mount();
    mounting_holes();
}