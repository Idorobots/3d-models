SLING_THICKNESS = 11;
SLOT_WIDTH = 13;
SLOT_THICKNESS = 12;
SLOT_LENGTH = 33;
SLOT_HEIGHT = 40;
CORNER_DIA = 6;

HOLE_SPACING = 12;
HOLE_DIA = 5;
HOLE_OFFSET = 5;

$fn = 50;

module mount_holes(width, length, thickness, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = thickness);
    }
  }
}
module rounded_rect(width, length, thickness, corner_dia) {
  hull() {
    mount_holes(width-corner_dia, length-corner_dia, thickness, corner_dia);
  }
}

module adapter() {
  difference() {
    union() {
      rounded_rect(SLOT_LENGTH, SLOT_WIDTH, SLING_THICKNESS, CORNER_DIA);
      translate([0, -(SLOT_HEIGHT - SLOT_WIDTH)/2, 0])
      rounded_rect(SLOT_THICKNESS, SLOT_HEIGHT, SLING_THICKNESS, CORNER_DIA);
    }
    
    #translate([0, -(SLOT_HEIGHT - SLOT_WIDTH)/2 - SLOT_WIDTH/2 + HOLE_OFFSET, 0])
    mount_holes(0, HOLE_SPACING, SLING_THICKNESS, HOLE_DIA);
  }
}

adapter();
