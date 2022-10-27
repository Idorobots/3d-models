WIDTH = 29;
LENGTH = 35;
CORNER_DIA = 10;
THICKNESS_BOT = 2;
THICKNESS_TOP = 2.5;

MOUNT_HOLE_SPACING_X = 21;
MOUNT_HOLE_SPACING_Y = 26;
MOUNT_HOLE_DIA = 2.5;
MOUNT_HOLE_SHAFT_DIA = 5;
MOUNT_HOLE_HEAD_DIA = 5;
MOUNT_HOLE_SHAFT_LENGTH = 1;
MOUNT_HOLE_HEAD_LENGTH = 1;

$fn = 30;

module mount_holes(width, length, height, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

module rounded_rect(width, length, height, corner_dia) {
  hull()
  mount_holes(width - corner_dia, length - corner_dia, height, corner_dia);
}

module bottom() {
  difference() {
    union() {
      rounded_rect(WIDTH, LENGTH, THICKNESS_BOT, CORNER_DIA);
      translate([0, 0, THICKNESS_BOT])
      mount_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, MOUNT_HOLE_SHAFT_LENGTH, MOUNT_HOLE_SHAFT_DIA);
    }
    mount_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, THICKNESS_BOT + MOUNT_HOLE_SHAFT_LENGTH, MOUNT_HOLE_DIA);
  }
}

module top() {
  difference() {
    rounded_rect(WIDTH, LENGTH, THICKNESS_TOP, CORNER_DIA);
    mount_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, THICKNESS_BOT, MOUNT_HOLE_DIA);

    translate([0, 0, THICKNESS_TOP - MOUNT_HOLE_HEAD_LENGTH])
    mount_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, THICKNESS_BOT, MOUNT_HOLE_HEAD_DIA);

    mount_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, MOUNT_HOLE_SHAFT_LENGTH/2, MOUNT_HOLE_SHAFT_DIA + 1);
  }
}

bottom();
translate([0, 0, 5])
top();
