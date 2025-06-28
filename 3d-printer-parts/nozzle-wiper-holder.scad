INSERT_WIDTH = 10;
INSERT_LENGTH = 40;
INSERT_DEPTH = 1.5;

WIDTH = INSERT_WIDTH + 2;
LENGTH = INSERT_LENGTH + 2;
HEIGHT = 5;

MOUNT_TAB_DIA = 10;
MOUNT_TAB_THICKNESS = 2;

HOLE_HEAD_DIA = 8;
HOLE_DIA = 5;
HOLE_OFFSET_X = -10;
HOLE_OFFSET_Y = -20;

$fn = 50;

difference() {
  union() {
    hull() {
      translate([HOLE_OFFSET_X, HOLE_OFFSET_Y, 0])
      cylinder(d = MOUNT_TAB_DIA, h = MOUNT_TAB_THICKNESS);

      translate([-WIDTH/2, -LENGTH/2, 0])
      cube([WIDTH, LENGTH, HEIGHT]);
    }
  }

  #translate([HOLE_OFFSET_X, HOLE_OFFSET_Y, 0]) {
    cylinder(d = HOLE_DIA, h = HEIGHT);
    translate([0, 0, MOUNT_TAB_THICKNESS])
    cylinder(d = HOLE_HEAD_DIA, h = HEIGHT);
  }

  #translate([-INSERT_WIDTH/2, -INSERT_LENGTH/2, HEIGHT - INSERT_DEPTH])
  cube([INSERT_WIDTH, INSERT_LENGTH, HEIGHT]);

}
