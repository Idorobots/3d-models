GRIP_LENGTH = 80;
GRIP_WIDTH = 23;
GRIP_THICKNESS = 8;

INSERT_WIDTH = 18.2;
INSERT_THICKNESS = 5;
INSERT_LENGTH = 32;

$fn = 200;

union() {
    hull() {
        translate([-GRIP_LENGTH-GRIP_WIDTH/2, 0, -GRIP_THICKNESS/2])
        cylinder(d = GRIP_WIDTH, h = GRIP_THICKNESS);

        translate([-GRIP_WIDTH, -GRIP_WIDTH/2, -GRIP_THICKNESS/2])
        cube(size = [GRIP_WIDTH, GRIP_WIDTH, GRIP_THICKNESS]);
    }
    hull() {
        translate([INSERT_LENGTH-INSERT_WIDTH/2, 0, -INSERT_THICKNESS/2])
        cylinder(d = INSERT_WIDTH, h = INSERT_THICKNESS);

        translate([-INSERT_WIDTH/2, -INSERT_WIDTH/2, -INSERT_THICKNESS/2])
        cube(size = [INSERT_WIDTH, INSERT_WIDTH, INSERT_THICKNESS]);
    }
}
