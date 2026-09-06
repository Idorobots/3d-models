WIDTH = 178;
LENGTH = 204;
THICKNESS = 1;
HEIGHT = 6;
CORNER_DIA = 5;

BB_WIDTH = 174;
BB_LENGTH = 200;
BB_HEIGHT = 10;

MOUNT_HOLE_SPACING_1 = [164, 186];
MOUNT_HOLE_SPACING_2 = [155, 164];
MOUNT_HOLE_SPACING_3 = [51.5, 164];
MOUNT_HOLE_DIA = 3.5;
MOUNT_HOLE_HEIGHT = 4;

$fn = 100;

module mount_holes(width, length, height, corner_dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = corner_dia, h = height);
    }
  }
}

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    mount_holes(width - corner_dia, length - corner_dia, height, corner_dia);
  }
}

module backplate() {
  union() {
    difference() {
      rounded_rect(WIDTH, LENGTH, HEIGHT, CORNER_DIA);
      #translate([-BB_WIDTH/2, -BB_LENGTH/2, THICKNESS])
      cube(size = [BB_WIDTH, BB_LENGTH, BB_HEIGHT]);
    }
    mount_holes(MOUNT_HOLE_SPACING_1[0], MOUNT_HOLE_SPACING_1[1], MOUNT_HOLE_HEIGHT, MOUNT_HOLE_DIA);
    mount_holes(MOUNT_HOLE_SPACING_2[0], MOUNT_HOLE_SPACING_2[1], MOUNT_HOLE_HEIGHT, MOUNT_HOLE_DIA);
    mount_holes(MOUNT_HOLE_SPACING_3[0], MOUNT_HOLE_SPACING_3[1], MOUNT_HOLE_HEIGHT, MOUNT_HOLE_DIA);
  }
}

intersection() {
  backplate();
  translate([-WIDTH/2, 0, 0])
  cube(size = [WIDTH, LENGTH, HEIGHT]);
}
