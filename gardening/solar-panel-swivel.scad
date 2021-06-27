PLATE_THICKNESS = 2;
PLATE_WIDTH = 34;
PLATE_LENGTH = 34;

SWIVEL_WIDTH = 30;
SWIVEL_HEIGHT = 30;
SWIVEL_THICKNESS = 4.75;
SWIVEL_HOLE = 4;


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

module plate() {
  rounded_rect(PLATE_WIDTH, PLATE_LENGTH, PLATE_THICKNESS, 3);
}

module swivel() {
  translate([0, -SWIVEL_THICKNESS/2, SWIVEL_HEIGHT/2])
  rotate([-90, 0, 0])
  difference() {
    hull() {
      cylinder(d = SWIVEL_WIDTH, h = SWIVEL_THICKNESS);
      translate([-SWIVEL_WIDTH/2, 0, 0])
      cube(size = [SWIVEL_WIDTH, SWIVEL_HEIGHT/2, SWIVEL_THICKNESS]);
    }
    cylinder(d = SWIVEL_HOLE, h = SWIVEL_THICKNESS);
  }
}

plate();
translate([0, 0, PLATE_THICKNESS])
swivel();