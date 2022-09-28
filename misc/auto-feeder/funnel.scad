OUTPORT_LENGTH = 50;
OUTPORT_WIDTH = 30;
OUTPORT_CORNER_DIA = 2;
OUTPORT_HEIGHT = 20;
OUTPORT_OFFSET = 50;

INPORT_LENGTH = 110;
INPORT_WIDTH = 175;
INPORT_CORNER_DIA = 34;

HEIGHT = 50;

$fn = 100;

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

module funnel() {
  union() {
    hull() {
      translate([0, 0, HEIGHT + OUTPORT_HEIGHT])
      rounded_rect(INPORT_WIDTH, INPORT_LENGTH, 1, INPORT_CORNER_DIA);
      translate([-(INPORT_WIDTH/2 - OUTPORT_OFFSET), 0, OUTPORT_HEIGHT])
      rounded_rect(OUTPORT_WIDTH, OUTPORT_LENGTH, 1, OUTPORT_CORNER_DIA);
    }
    translate([-(INPORT_WIDTH/2 - OUTPORT_OFFSET), 0, 0])
    rounded_rect(OUTPORT_WIDTH, OUTPORT_LENGTH, OUTPORT_HEIGHT, OUTPORT_CORNER_DIA);
  }
}

funnel();
