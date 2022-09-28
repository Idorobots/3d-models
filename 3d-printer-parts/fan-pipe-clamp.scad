HEIGHT = 10;
THICKNESS = 1;

BASE_PLATE_WIDTH = 40;
BASE_PLATE_CLAMP_WIDTH = 20;
BASE_PLATE_THICKNESS = 1.5;

FAN_MOUNT_SPACING = 35;
FAN_MOUNT_DIA = 2;

PIPE_DIA = 14.75;
PIPE_OFFSET_Y = BASE_PLATE_THICKNESS + PIPE_DIA/2;
PIPE_OFFSET_X = 5;
PIPE_CLAMP_GAP_WIDTH = 5;

$fn = 50;

difference() {
    union() {
        translate([PIPE_OFFSET_X, 0, 0])
        difference() {
            hull() {
                translate([0, PIPE_OFFSET_Y, 0])
                cylinder(d = PIPE_DIA + 2 * THICKNESS, h = HEIGHT);
                translate([-BASE_PLATE_CLAMP_WIDTH/2, 0, 0])
                cube(size = [BASE_PLATE_CLAMP_WIDTH, BASE_PLATE_THICKNESS, HEIGHT]);
            }
            translate([0, PIPE_OFFSET_Y, 0])
            cylinder(d = PIPE_DIA, h = HEIGHT);
            translate([-PIPE_CLAMP_GAP_WIDTH/2, PIPE_DIA/2 + PIPE_OFFSET_Y - THICKNESS, 0])
            cube(size = [PIPE_CLAMP_GAP_WIDTH, 2 * THICKNESS, HEIGHT]);
        }
        translate([-BASE_PLATE_WIDTH/2, 0, 0])
        cube(size = [BASE_PLATE_WIDTH, BASE_PLATE_THICKNESS, HEIGHT]);
    }

    #for(i = [-1, 1]) {
        translate([i * FAN_MOUNT_SPACING/2, 0, HEIGHT - (BASE_PLATE_WIDTH - FAN_MOUNT_SPACING)/2])
        rotate([-90, 0, 0])
        cylinder(d = FAN_MOUNT_DIA, h = HEIGHT);
    }
}
