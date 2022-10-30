BASE_WIDTH = 19;
BASE_LENGTH = 22;
BASE_MOUNT_DIA = 10;
THICKNESS = 3;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_SPACING = 30;

MID_HOLE_WIDTH = 13;
MID_HOLE_LENGTH = 22;
MID_HOLE_TAB_WIDTH = 6;
MID_HOLE_TAB_LENGTH = 5;
MID_HOLE_NUB_WIDTH = 1.5;
MID_HOLE_NUB_LENGTH = 2;
MID_HOLE_NUB_OFFSET = MID_HOLE_LENGTH/2-7;

CORNER_DIA = 3;
CORNER_SPACING_BOTTOM = 35.5 - CORNER_DIA;
CORNER_SPACING_TOP = 45 - CORNER_DIA;
CORNER_SPACING_X = 18 - CORNER_DIA;

BOUND_WIDTH = max(CORNER_SPACING_X, BASE_WIDTH);
BOUND_LENGTH = max(CORNER_SPACING_BOTTOM, CORNER_SPACING_TOP);

$fn = 30;

module base() {
  hull() {
    translate([-BASE_WIDTH/2, -BASE_LENGTH/2, 0])
    cube(size = [BASE_WIDTH, BASE_LENGTH, THICKNESS]);

    for(i = [1, -1]) {
      translate([0, i * MOUNT_HOLE_SPACING/2, 0])
      cylinder(d = BASE_MOUNT_DIA, h = THICKNESS);
    }
  }
}

module mount_holes() {
  for(i = [1, -1]) {
    translate([0, i * MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
  }
}

module mid_hole() {
  difference() {
    union() {
      translate([-MID_HOLE_WIDTH/2, -MID_HOLE_LENGTH/2, 0])
      cube(size = [MID_HOLE_WIDTH, MID_HOLE_LENGTH, THICKNESS]);

      w = MID_HOLE_WIDTH + 2 * MID_HOLE_NUB_WIDTH;
      l = MID_HOLE_NUB_LENGTH;
      translate([-w/2, -l/2 - MID_HOLE_NUB_OFFSET, 0])
      cube(size = [w, l, THICKNESS]);
    }

    translate([-MID_HOLE_TAB_WIDTH/2, -MID_HOLE_LENGTH/2, 0])
    cube(size = [MID_HOLE_TAB_WIDTH, MID_HOLE_TAB_LENGTH, THICKNESS]);
  }
}

module corners() {
  for(i = [1, -1]) {
    translate([CORNER_SPACING_X/2, i * CORNER_SPACING_BOTTOM/2, 0])
    cylinder(d = CORNER_DIA, h = THICKNESS);

    translate([-CORNER_SPACING_X/2, i * CORNER_SPACING_TOP/2, 0])
    cylinder(d = CORNER_DIA, h = THICKNESS);
  }
}

module gasket() {
  difference() {
    hull() {
      base();
      corners();
    }
    #mount_holes();
    #mid_hole();
  }
}

// Right
intersection() {
  gasket();
  translate([-BOUND_WIDTH/2, 0, 0])
  cube(size = [BOUND_WIDTH, BOUND_LENGTH, THICKNESS]);
}
// Left
intersection() {
  gasket();
  translate([-BOUND_WIDTH/2, -BOUND_LENGTH, 0])
  cube(size = [BOUND_WIDTH, BOUND_LENGTH, THICKNESS]);
}
