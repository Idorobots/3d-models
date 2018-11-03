MOUNT_HOLE_SPACING = 53;
MOUNT_HOLE_DIA = 6;

CORNER_DIA = 10;
WIDTH = MOUNT_HOLE_SPACING + MOUNT_HOLE_DIA + 10;
LENGTH = WIDTH * 2;
HEIGHT = 5;

POLE_DIA = 16;
POLE_MOUNT_DIA = POLE_DIA + 8;
POLE_MOUNT_WIDTH = WIDTH/2;
POLE_MOUNT_LENGTH = WIDTH;

$fn = 30;

module body() {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (WIDTH/2-CORNER_DIA/2), j * (WIDTH/2-CORNER_DIA/2)])
                    cylinder(d = CORNER_DIA, h = HEIGHT);
            }
        }
    }
}

module mounting_holes() {
    union() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * MOUNT_HOLE_SPACING/2, j * MOUNT_HOLE_SPACING/2])
                    cylinder(d = MOUNT_HOLE_DIA, h = HEIGHT);
            }    
        }
    }
}

module pole_mount() {
    difference() {
        hull() {
            translate([0, -POLE_MOUNT_LENGTH/2, POLE_MOUNT_DIA/2])
                rotate([-90, 0, 0])
                    cylinder(d = POLE_MOUNT_DIA, h = POLE_MOUNT_LENGTH);
            translate([-POLE_MOUNT_WIDTH/2, -POLE_MOUNT_LENGTH/2, 0])
                cube(size = [POLE_MOUNT_WIDTH, POLE_MOUNT_LENGTH, 1]);
        }
        translate([0, -POLE_MOUNT_LENGTH/2, POLE_MOUNT_DIA/2])
            rotate([-90, 0, 0])
                cylinder(d = POLE_DIA, h = POLE_MOUNT_LENGTH);

    }
}

difference() {
    union() {
        body();
        pole_mount();
    }
    mounting_holes();
}