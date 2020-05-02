WIDTH = 150;
LENGTH = 160;
THICKNESS = 1;
HEIGHT = 10;

CORNER_DIA_TOP = 5;
CORNER_DIA_BOT = 15;

LIP_WIDTH = 15;

HOLE_DIA = 8.8;
BAR_THICKNESS = 2;

MOUNTING_HOLE_HEAD_DIA = 8;
MOUNTING_HOLE_HEAD_LEN = 4;
MOUNTING_HOLE_DIA = 5;
MOUNTING_HOLE_SPACING = 120;
MOUNTING_HOLE_STANDOFF_DIA = 12;

$fn = 100;

module hexagon(d, h) {
  cylinder(d = d * 2*sqrt(3)/3, h = h, center = true, $fn = 6);
}

module honeycomb(width, length, hole_dia, bar_thickness, height) {
  DELTA_X = sqrt(pow(hole_dia + bar_thickness, 2) - pow(hole_dia/2, 2));
  X_HOLES = floor((width / DELTA_X));
  DELTA_Y = (hole_dia + bar_thickness);
  Y_HOLES = floor(length / DELTA_Y);

  difference() {
    cube(size = [width, length, height], center = true);
    union() {
      translate([-(X_HOLES*DELTA_X)/2, -(Y_HOLES*DELTA_Y)/2, 0])
        for(i = [0:X_HOLES]) {
          for(j = [0:Y_HOLES + (i % 2)]) {
            translate([0, -(i % 2) * DELTA_X/2, 0])
              translate([i * DELTA_X, j * DELTA_Y, 0])
                hexagon(hole_dia, height + 2);
          }
        }
    }
  }
}

module rounded_rectoid(width, length, height, corner_dia_1, corner_dia_2) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (width - corner_dia_1)/2, j * (length - corner_dia_1)/2, 0])
                cylinder(d1 = corner_dia_1, d2 = corner_dia_2, h = height, center = true);
            }
        }
    }
}

module rounded_rect(width, length, height, corner_dia) {
    rounded_rectoid(width, length, height, corner_dia, corner_dia);
}

difference() {
    union() {
        difference() {
            rounded_rectoid(WIDTH, LENGTH, HEIGHT, CORNER_DIA_BOT, CORNER_DIA_TOP);
            difference() {
                union() {
                    translate([0, 0, -THICKNESS])
                    rounded_rectoid(WIDTH - 2*THICKNESS, LENGTH - 2*THICKNESS, HEIGHT, CORNER_DIA_BOT, CORNER_DIA_TOP);
                    cube(size = [WIDTH - 2*LIP_WIDTH, LENGTH - 2*LIP_WIDTH, HEIGHT], center = true);
                }
                for(i = [-1, 1]) {
                    hull() {
                        translate([i * MOUNTING_HOLE_SPACING/2, 0, 0])
                        cylinder(d = MOUNTING_HOLE_STANDOFF_DIA, h = HEIGHT, center = true);
                        translate([i * MOUNTING_HOLE_SPACING, 0, 0])
                        cylinder(d = MOUNTING_HOLE_STANDOFF_DIA, h = HEIGHT, center = true);
                    }
                }
            }
        }
        translate([0, 0, (HEIGHT-THICKNESS)/2])
        honeycomb(WIDTH - 2*LIP_WIDTH, LENGTH - 2*LIP_WIDTH, HOLE_DIA,  BAR_THICKNESS, THICKNESS);
    }

    for(i = [-1, 1]) {
        translate([i * MOUNTING_HOLE_SPACING/2, 0, 0]) {
            cylinder(d = MOUNTING_HOLE_DIA, h = HEIGHT, center = true);
            translate([0, 0, (HEIGHT - MOUNTING_HOLE_HEAD_LEN)/2])
            cylinder(d = MOUNTING_HOLE_HEAD_DIA, h = MOUNTING_HOLE_HEAD_LEN, center = true);
        }
    }
}