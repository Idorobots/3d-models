// Mac Pro 5.1 drive bay cover
//*
CORNER_DIA = 10;
WIDTH = 37.2;
LENGTH = 51.5;
THICKNESS = 3;
LIP_WIDTH = 1;
LIP_THICKNESS = 0.5;
/**/

// Mac Pro 5.1 CD flap cover
/*
CORNER_DIA = 6;
WIDTH = 17.1;
LENGTH = 162.5;
THICKNESS = 3;
LIP_WIDTH = 1;
LIP_THICKNESS = 1.5;
/**/

$fn = 100;

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2])
        cylinder(d = corner_dia, h = height);
      }
    }
  }
}

rounded_rect(WIDTH + LIP_WIDTH * 2, LENGTH + LIP_WIDTH * 2, LIP_THICKNESS, CORNER_DIA);
rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);
