WIDTH = 31;
HEIGHT = 23;
DEPTH = 10;
CORNER_DIA = 6;

IEC_WIDTH_TOP = 16;
IEC_WIDTH_BOT = 28;
IEC_CORNER_DIA_TOP = 1;
IEC_CORNER_DIA_BOT = 9;
IEC_THICKNESS_BOT = 14;
IEC_THICKNESS_TOP = 20.2;

$fn = 50;

module rounded_rect(width, length, height, dia) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width - dia)/2, j * (length - dia)/2, 0])
        cylinder(d = dia, h = height);
      }
    }
  }
}

module iec() {
  hull() {
    translate([0, -(IEC_THICKNESS_TOP - IEC_THICKNESS_BOT)/2, 0]) {
      rounded_rect(IEC_WIDTH_BOT, IEC_THICKNESS_BOT, DEPTH, IEC_CORNER_DIA_BOT);
      translate([0, (IEC_THICKNESS_BOT - IEC_CORNER_DIA_TOP)/2, 0])
      rounded_rect(IEC_WIDTH_BOT, IEC_CORNER_DIA_TOP, DEPTH, IEC_CORNER_DIA_TOP);
    }
    rounded_rect(IEC_WIDTH_TOP, IEC_THICKNESS_TOP, DEPTH, IEC_CORNER_DIA_TOP);
  }
}

difference() {
  rounded_rect(WIDTH, HEIGHT, DEPTH, CORNER_DIA);

  #iec();
}
