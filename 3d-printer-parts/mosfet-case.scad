WIDTH = 70; // 28; // 40; // 114; // 100; // 27; //50; // 90; // 53; // 70; // 42;
LENGTH = 90; // 148; // 60; // 139; // 160; // 100; // 70; // 150; // 77; // 90; // 62;
CORNER_DIA = 2; // 5; // 5;
THICKNESS = 2;

MOUNT_HOLE_SPACING_X = 64; // 24; // 36; // 107; // 88; // 23; // 46; // 84; // 45; // 65; //36;
MOUNT_HOLE_SPACING_Y = 84; // 144; // 56; // 133; // 155; // 95; //66; // 144; // 70; // 83; //56;
MOUNT_HOLE_DIA = 3; // 2; // 3.5; // 2; // 2.5; // 3.5;
MOUNT_HOLE_STANDOFF_DIA = min(WIDTH - MOUNT_HOLE_SPACING_X, LENGTH - MOUNT_HOLE_SPACING_Y);
MOUNT_HOLE_STANDOFF_HEIGHT = 5; // 20; // 3; // 3;

ACCESS_SLOT_WIDTH = 0; // 21; // 0; // 0;
ACCESS_SLOT_HEIGHT = 4;


$fn = 30;

module mounting_holes(width, length, height, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

module rounded_cube(width, length, height, corner_dia) {
  hull() {
    mounting_holes(width - corner_dia, length - corner_dia, height, corner_dia);
  }
}

module base() {
  difference() {
    union() {
      difference() {
        rounded_cube(WIDTH, LENGTH, MOUNT_HOLE_STANDOFF_HEIGHT + THICKNESS, CORNER_DIA);
        translate([0, 0, THICKNESS])
        rounded_cube(WIDTH - THICKNESS, LENGTH - THICKNESS, MOUNT_HOLE_STANDOFF_HEIGHT, CORNER_DIA);
      }
      mounting_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, MOUNT_HOLE_STANDOFF_HEIGHT + THICKNESS, MOUNT_HOLE_STANDOFF_DIA);
    }
    mounting_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, MOUNT_HOLE_STANDOFF_HEIGHT + THICKNESS, MOUNT_HOLE_DIA);

    if (ACCESS_SLOT_WIDTH > 0) {
      translate([0, 0, MOUNT_HOLE_STANDOFF_HEIGHT + THICKNESS - ACCESS_SLOT_HEIGHT])
      rounded_cube(ACCESS_SLOT_WIDTH, LENGTH + 2 * THICKNESS, ACCESS_SLOT_HEIGHT, 1);
    }
  }
}

base();
