SHAFT_DIA = 7.5;
SHAFT_D_WIDTH = 5.5;
SHAFT_LENGTH = 8;

WALL_THICKNESS = 2;
MOUNT_DIA = 40;
MOUNT_THICKNESS = 4;

$fn = 300;

module adapter() {
  union() {
    translate([0, 0, MOUNT_THICKNESS * 0.5])
    cylinder(d = MOUNT_DIA, h = MOUNT_THICKNESS * 0.5);
    cylinder(d1 = SHAFT_DIA + 2 * WALL_THICKNESS, d2 = MOUNT_DIA, h = MOUNT_THICKNESS * 0.5);
  }
}

module shaft() {
  difference() {
    cylinder(d = SHAFT_DIA + 2 * WALL_THICKNESS, h = SHAFT_LENGTH);
    intersection() {
      cylinder(d = SHAFT_DIA, h = SHAFT_LENGTH);
      translate([SHAFT_DIA - SHAFT_D_WIDTH, 0, 0])
      cube(size = [SHAFT_DIA, SHAFT_DIA, SHAFT_LENGTH * 2], center = true);
    }
  }
}

translate([0, 0, SHAFT_LENGTH])
adapter();
shaft();
