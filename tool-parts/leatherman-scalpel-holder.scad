THICKNESS = 1.6;

SCALPEL_WIDTH = 5;
SCALPEL_THICKNESS = 0.5;
SCALPEL_CUT_ANGLE = 30;
SCALPEL_OFFSET_Y = 4;
SCALPEL_OFFSET_X = 4;

BASE_WIDTH = SCALPEL_WIDTH;
BASE_THICKNESS = THICKNESS;
BASE_LENGTH = 25;
BASE_OFFSET_X = SCALPEL_OFFSET_X;
BASE_OFFSET_Y = SCALPEL_OFFSET_Y + BASE_WIDTH/2;

MOUNT_WIDTH_BOT = 1.4;
MOUNT_WIDTH_TOP = 2.3;
MOUNT_LENGTH = 15;
MOUNT_OFFSET_X = SCALPEL_OFFSET_X;
MOUNT_OFFSET_Y = SCALPEL_OFFSET_Y + 7;

$fn = 30;

module slot(dia, length, height) {
  hull() {
    translate([0, length - dia])
    cylinder(d = dia, h = height);
    cylinder( d = dia, h = height);
  }
}

module base() {
  slot(BASE_WIDTH, BASE_LENGTH, BASE_THICKNESS);
}

module mount() {
  slot(MOUNT_WIDTH_BOT, MOUNT_LENGTH, SCALPEL_THICKNESS);
  translate([0, 0.5, SCALPEL_THICKNESS])
  slot(MOUNT_WIDTH_TOP, MOUNT_LENGTH + 1, 1.2 * SCALPEL_THICKNESS);
}

module scalpel() {
  translate([-SCALPEL_WIDTH/2, 0, 0]) {
    difference() {
      cube(size = [SCALPEL_WIDTH, BASE_LENGTH, SCALPEL_THICKNESS]);
      rotate([0, 0, SCALPEL_CUT_ANGLE - 90])
      cube(size = [SCALPEL_WIDTH, BASE_LENGTH, SCALPEL_THICKNESS]);
    }

    rotate([0, 0, SCALPEL_CUT_ANGLE + 90])
    translate([0, -SCALPEL_WIDTH, 0])
    cube(size = [SCALPEL_WIDTH * 2, BASE_LENGTH, SCALPEL_THICKNESS]);
  }
}

module leatherman_mount() {
  mirror([1, 0, 0])
  translate([-5.5, -4.5, 0])
  linear_extrude(height = THICKNESS)
  import("leatherman-blank.svg");
}

module holder() {
  difference() {
    union() {
      translate([BASE_OFFSET_X, BASE_OFFSET_Y, 0])
      base();
      leatherman_mount();
    }
    #translate([SCALPEL_OFFSET_X, SCALPEL_OFFSET_Y, THICKNESS - SCALPEL_THICKNESS])
    scalpel();
  }
  translate([MOUNT_OFFSET_X, MOUNT_OFFSET_Y, BASE_THICKNESS - SCALPEL_THICKNESS])
  mount();
}

holder();
