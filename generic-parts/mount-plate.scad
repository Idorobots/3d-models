WIDTH = 20;
LENGTH = 30;
THICKNESS = 2.5;
CORNER_DIA = 5;

HOLE_DIA = 4.5;
HOLE_OFFSETS= [
  [-5, -10], [5, -10],
  [0, 8], [0, 8]
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

difference() {
  rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);

  #for(o = HOLE_OFFSETS) {
    translate([o[0], o[1], 0])
    cylinder(d = HOLE_DIA, h = THICKNESS);
  }
}
