PANEL_WIDTH = 154;
PANEL_LENGTH = 134;
PANEL_THICKNESS = 3;

PANEL_BOX_WIDTH = 35;
PANEL_BOX_LENGTH = 35;
PANEL_BOX_OFFSET = 24;

WALL_THICKNESS = 1.5;
CORNER_DIA = 5;

MOUNT_HOLE_SPACING = 25;
MOUNT_HOLE_HEAD_DIA = 8;
MOUNT_HOLE_HEAD_LENGTH = 1;
MOUNT_HOLE_DIA = 3;

$fn = 50;

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2, 0])
        cylinder(d = corner_dia, h = height);
      }
    }
  }
}

module case() {
  wt = 2 * WALL_THICKNESS;
  difference() {
    rounded_rect(PANEL_WIDTH + wt, PANEL_LENGTH + wt, PANEL_THICKNESS + wt/2, CORNER_DIA);

    rounded_rect(PANEL_WIDTH, PANEL_LENGTH, PANEL_THICKNESS, 1);

    translate([PANEL_BOX_OFFSET + PANEL_BOX_WIDTH/2, 0, 0])
    rounded_rect(PANEL_BOX_WIDTH, PANEL_BOX_LENGTH, PANEL_THICKNESS + wt, CORNER_DIA);

    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * MOUNT_HOLE_SPACING/2, j * MOUNT_HOLE_SPACING/2, PANEL_THICKNESS]) {
          cylinder(d = MOUNT_HOLE_DIA, h = WALL_THICKNESS);
          cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_LENGTH);
        }
      }
    }
  }
}

case();