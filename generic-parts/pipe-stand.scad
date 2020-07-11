WIDTH = 50;
HEIGHT = 40;
THICKNESS = 5;

PIPE_DIA = 22.2;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_SPACING = 45;

CORNER_DIA = 10;

$fn = 100;

module mounting_holes(width, length, height, dia) {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width-dia)/2, j * (length-dia)/2, 0])
            cylinder(d = dia, h = height);
      }
    }
}

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    mounting_holes(width, length, height, corner_dia);
  }
}

difference() {
  union() {
    cylinder(d1 = WIDTH - THICKNESS, d2 = PIPE_DIA + THICKNESS, h = HEIGHT);
    rounded_rect(WIDTH, WIDTH, THICKNESS, CORNER_DIA);
  }

  cylinder(d = PIPE_DIA, h = HEIGHT);
  mounting_holes(MOUNT_HOLE_SPACING, MOUNT_HOLE_SPACING, THICKNESS, MOUNT_HOLE_DIA);
}
