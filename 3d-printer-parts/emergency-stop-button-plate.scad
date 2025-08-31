WIDTH = 50;
LENGTH = 60;
CORNER_DIA = 10;
THICKNESS = 2;

HOLE_SPACING_X = 30;
HOLE_SPACING_Y = 40;
HOLE_DIA = 4.5;

BUTTON_HOLE = 16;

$fn = 50;

module holes(width, length, height, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * (width - dia)/2, j * (length - dia)/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

difference() {
  hull() {
    holes(WIDTH, LENGTH, THICKNESS, CORNER_DIA);
  }
  #holes(HOLE_SPACING_X + HOLE_DIA, HOLE_SPACING_Y + HOLE_DIA, THICKNESS, HOLE_DIA);
  #cylinder(d = BUTTON_HOLE, h = THICKNESS);
}
