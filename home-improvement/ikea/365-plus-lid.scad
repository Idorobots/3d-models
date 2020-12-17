WALL_THICKNESS = 1.2;

KNOB_HOLE_DIA = 5;
LIP_WIDTH = 5;
LIP_HEIGHT = 2.5;

WIDTH = 130;
LENGTH = 191;
HEIGHT = 10;
CORNER_DIA_BOT = 36;
CORNER_DIA_TOP = 40;

$fn = 50;

module rounded_rect(width, length, height, corner_dia_bot, corner_dia_top) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width - corner_dia_top)/2, j * (length - corner_dia_top)/2, 0])
        cylinder(d1 = corner_dia_bot, d2 = corner_dia_top, h = height);
      }
    }
  }
}

module lid() {
  wt = 2 * WALL_THICKNESS;
  difference() {
    union() {
      rounded_rect(WIDTH, LENGTH, HEIGHT - LIP_HEIGHT - wt/2, CORNER_DIA_BOT, CORNER_DIA_TOP);
 
      translate([0, 0, HEIGHT - LIP_HEIGHT - wt/2])
      rounded_rect(WIDTH, LENGTH, LIP_HEIGHT, CORNER_DIA_TOP, CORNER_DIA_TOP);
      
      translate([0, 0, HEIGHT - wt/2])
      rounded_rect(WIDTH + 2 * LIP_WIDTH, LENGTH + 2 * LIP_WIDTH, wt/2, CORNER_DIA_TOP, CORNER_DIA_TOP);
    }
    rounded_rect(WIDTH - wt, LENGTH - wt, HEIGHT - wt/2, CORNER_DIA_BOT, CORNER_DIA_TOP);
    
    cylinder(d = KNOB_HOLE_DIA, h = HEIGHT);
  }
}

lid();