PIPE_DIA = 8;
PIPE_HOLDER_LENGTH = 20;
PIPE_ANGLE = [10, 10, 0];

WALL_THICKNESS = 3;
WIDTH = 12;
LENGTH = 25;
HEIGHT = 15;


$fn = 50;

module adapter() {
    intersection() {
        difference() {
            union() {
                cube([WIDTH + 2 * WALL_THICKNESS, LENGTH, HEIGHT + WALL_THICKNESS]);

                hull() {
                    translate([0, (LENGTH - PIPE_DIA - 2 * WALL_THICKNESS)/2, 0])
                    cube([WIDTH, PIPE_DIA + 2 * WALL_THICKNESS, HEIGHT + WALL_THICKNESS]);

                    translate([-PIPE_DIA, LENGTH/2, 0])
                    rotate(PIPE_ANGLE)
                    cylinder(d = PIPE_DIA + 2 * WALL_THICKNESS, h = PIPE_HOLDER_LENGTH * 2, center = true);
                }
            }

            #translate([WALL_THICKNESS, 0, WALL_THICKNESS])
            cube([WIDTH, LENGTH, HEIGHT]);

            #translate([-PIPE_DIA, LENGTH/2, 0])
            rotate(PIPE_ANGLE)
            cylinder(d = PIPE_DIA, h = PIPE_HOLDER_LENGTH * 3, center = true);
        }

        cylinder(d = 3 * LENGTH, h = HEIGHT);
    }
}

adapter();
