SLOT_WIDTH = 4;
SLOT_LENGTH = 20;
SLOT_SPACING = 7;

THICKNESS = 2;
LENGTH = 25;
WIDTH = 17;
CORNER_DIA = 8;

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

difference() {
  rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);
  #translate([-SLOT_SPACING/2, 0, 0,])
  rounded_rect(SLOT_WIDTH, SLOT_LENGTH, THICKNESS, SLOT_WIDTH);
  #translate([SLOT_SPACING/2, 0, 0])
  rounded_rect(SLOT_WIDTH, SLOT_LENGTH, THICKNESS, SLOT_WIDTH);
}
