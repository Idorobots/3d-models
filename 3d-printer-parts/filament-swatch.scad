WIDTH = 50;
LENGTH = 50;
THICKNESS = 3;
CORNER_DIA = 6;

TEXT = "PETG-CF";
TEXT_FONT = "Roboto:style=bold";
TEXT_SIZE = 6.5;

INSET_LIP_WIDTH = 2.5;
INSET_WIDTH = WIDTH - INSET_LIP_WIDTH * 2;
INSET_LENGTH = LENGTH - INSET_LIP_WIDTH * 3 - TEXT_SIZE;
INSET_DEPTH = 0.6;

HOLE_DIA = TEXT_SIZE;
HOLE_OFFSET = HOLE_DIA/2 + INSET_LIP_WIDTH;

$fn = 200;


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

module swatch() {
  difference() {
    rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);

    #translate([0, -(LENGTH - INSET_LENGTH)/2 + INSET_LIP_WIDTH, THICKNESS - INSET_DEPTH])
    rounded_rect(INSET_WIDTH, INSET_LENGTH, INSET_DEPTH * 2, CORNER_DIA);

    #translate([WIDTH/2 - HOLE_OFFSET, LENGTH/2 - HOLE_OFFSET, 0])
    cylinder(d = HOLE_DIA, h = THICKNESS + INSET_DEPTH);


    #translate([-WIDTH/2 + INSET_LIP_WIDTH, LENGTH/2 - TEXT_SIZE - INSET_LIP_WIDTH, THICKNESS - INSET_DEPTH])
    linear_extrude(height = INSET_DEPTH * 2)
    text(TEXT, font = TEXT_FONT, size = TEXT_SIZE);
  }
}

swatch();
