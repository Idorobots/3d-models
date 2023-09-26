PIPE_DIA = 8.5;
WALL_THICKNESS = 2;
BASE_THICKNESS = 3;

MOUNT_HOLE_DIA = 3;
MOUNT_HOLE_SPACING_X = 10;
MOUNT_HOLE_SPACING_Y = 60;

WIDTH = 22;
LENGTH = 70;

$fn = 50;

difference() {
    delta = PIPE_DIA/2 + WALL_THICKNESS - BASE_THICKNESS;

    union() {
        cylinder(d = PIPE_DIA + 2 * WALL_THICKNESS, h = LENGTH);
        translate([delta, 0, 0])
        cube(size = [BASE_THICKNESS, WIDTH, LENGTH]);
    }

    #translate([delta, WIDTH - MOUNT_HOLE_SPACING_X/2, (LENGTH-MOUNT_HOLE_SPACING_Y)/2])
    rotate([0, 90, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = BASE_THICKNESS);

    #translate([delta, WIDTH - MOUNT_HOLE_SPACING_X/2, (LENGTH-MOUNT_HOLE_SPACING_Y)/2 + MOUNT_HOLE_SPACING_Y])
    rotate([0, 90, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = BASE_THICKNESS);

    #cylinder(d = PIPE_DIA, h = LENGTH);
}
