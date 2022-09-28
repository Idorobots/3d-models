LENGTH = 40;
WIDTH = 15;
HEIGHT = 15;
CORNER_DIA = 10;
INNER_CORNER_DIA = 4;
THICKNESS = 3;

OPENING_WIDTH = 15;

$fn = 30;

module retainer() {
  difference() {
    hull() {
      l = LENGTH - CORNER_DIA;
      h = HEIGHT - CORNER_DIA;

      translate([-l/2, 0, 0])
      cylinder(d = CORNER_DIA, h = WIDTH);

      translate([l/2, 0, 0])
      cylinder(d = CORNER_DIA, h = WIDTH);

      translate([-l/2, h, 0])
      cylinder(d = CORNER_DIA, h = WIDTH);

      translate([l/2, h, 0])
      cylinder(d = CORNER_DIA, h = WIDTH);
    }

    #translate([0, THICKNESS - (CORNER_DIA-INNER_CORNER_DIA)/2, 0])
    hull() {
      dia = INNER_CORNER_DIA;
      l = LENGTH - INNER_CORNER_DIA - 2 * THICKNESS;
      h = HEIGHT - INNER_CORNER_DIA - 2 * THICKNESS;

      translate([-l/2, 0, 0])
      cylinder(d = dia, h = WIDTH);

      translate([l/2, 0, 0])
      cylinder(d = dia, h = WIDTH);

      translate([-l/2, h, 0])
      cylinder(d = dia, h = WIDTH);

      translate([l/2, h, 0])
      cylinder(d = dia, h = WIDTH);
    }

    w = OPENING_WIDTH + THICKNESS;
    #translate([-w/2, HEIGHT-THICKNESS-CORNER_DIA/2, 0])
    cube(size = [w, THICKNESS, WIDTH]);
  }

  translate([-OPENING_WIDTH/2 - THICKNESS/2, HEIGHT-CORNER_DIA/2 - THICKNESS/2, 0])
  cylinder(d = THICKNESS, h = WIDTH);

  translate([OPENING_WIDTH/2 + THICKNESS/2, HEIGHT-CORNER_DIA/2 - THICKNESS/2, 0])
  cylinder(d = THICKNESS, h = WIDTH);
}

retainer();
