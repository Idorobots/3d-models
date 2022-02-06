WIDTH = 42;
LENGTH = 62;
CORNER_DIA = 5;
THICKNESS = 2;

MOUNT_HOLE_SPACING_X = 36;
MOUNT_HOLE_SPACING_Y = 56;
MOUNT_HOLE_DIA = 3.5;
MOUNT_HOLE_STANDOFF_DIA = min(WIDTH - MOUNT_HOLE_SPACING_X, LENGTH - MOUNT_HOLE_SPACING_Y);
MOUNT_HOLE_STANDOFF_HEIGHT = 3;

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
  }
}

base();