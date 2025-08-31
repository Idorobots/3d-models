CORNER_DIA = 5;
BEND_DIA = 20;
BEND_OFFSET_X = 0; //-1.5;
BEND_OFFSET_Y= -1.5;

LENGTH_X = 40 - BEND_DIA/2;
WIDTH_X = 10;
THICKNESS_X = 10 + 1.5;

LENGTH_Y = 25 - BEND_DIA/2; // 15 - BEND_DIA/2;
WIDTH_Y = 15;
THICKNESS_Y = 10;

HOLE_DIA = 4.5;
HOLE_OFFSETS = [
  [30, 0], [20, 0],
  [-2, 16], [-2, 6] // 0.5
];


$fn = 50;

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for (i = [-1, 1]) {
      for (j = [-1, 1]) {
        translate([i*(width-corner_dia)/2, j*(length-corner_dia)/2, 0])
        cylinder(d = corner_dia, h = height);
      }
    }
  }
}

module bend() {
  difference() {
    translate([BEND_DIA/2 - WIDTH_Y/2, BEND_DIA/2 - WIDTH_X/2, 0])
    cylinder(d = BEND_DIA, h = THICKNESS_Y);

    #translate([BEND_OFFSET_X, BEND_OFFSET_Y, 0])
    hull() {
      translate([WIDTH_Y/2 + BEND_DIA/2, WIDTH_X/2 + BEND_DIA/2, 0])
      cylinder(d = BEND_DIA, h = THICKNESS_Y);

      translate([WIDTH_Y/2 + BEND_DIA/2, WIDTH_X/2 + BEND_DIA/2 + 10, 0])
      cylinder(d = BEND_DIA, h = THICKNESS_Y);
    }
  }
}

difference() {
  union() {
    hull() {
      translate([LENGTH_X/2 + BEND_DIA/4, 0, 0])
      rounded_rect(LENGTH_X, WIDTH_X, THICKNESS_X, CORNER_DIA);

      translate([WIDTH_Y/2 - BEND_DIA/4, -WIDTH_X/2, 0])
      cube(size = [WIDTH_X, WIDTH_X, THICKNESS_Y]);
    }

    hull() {
      translate([0, LENGTH_Y/2 + BEND_DIA/4, 0])
      rounded_rect(WIDTH_Y, LENGTH_Y, THICKNESS_Y, CORNER_DIA);

      translate([-WIDTH_Y/2, BEND_DIA/4, 0])
      cube(size = [WIDTH_Y, 1, THICKNESS_Y]);
    }

    intersection() {
      #bend();
      translate([-WIDTH_Y/2, -BEND_DIA/4, 0])
      cube(size = [WIDTH_Y * 2, LENGTH_Y + BEND_DIA/2 - 1, THICKNESS_Y]);
    }
  }

  #for(o = HOLE_OFFSETS) {
    translate([o[0], o[1], 0])
    cylinder(d = HOLE_DIA, h = THICKNESS_X);
  }
}
