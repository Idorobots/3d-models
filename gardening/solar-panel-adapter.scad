PLATE_THICKNESS = 2;
PLATE_WIDTH = 34;
PLATE_LENGTH = 34;
PLATE_ANGLE = 45;
PLATE_HOLE_DIA = 10;

COLUMN_HEIGHT = 20;
COLUMN_OUTER_DIA = 20;
COLUMN_INNER_DIA = 15;

PIPE_OUTER_DIA = 25;
PIPE_INNER_DIA = COLUMN_OUTER_DIA;
PIPE_HEIGHT = 50;

$fn = 50;

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

module plate() {
  rotate([PLATE_ANGLE, 0, 0])
  difference() {
    rounded_rect(PLATE_WIDTH, PLATE_LENGTH, PLATE_THICKNESS, 3);
    cylinder(d = PLATE_HOLE_DIA, h = PLATE_THICKNESS);
  }
}

module pipe(od, id, height) {
  difference() {
    cylinder(d = od, h = height);
    cylinder(d = id, h = height);
  }
}

module column() {
  difference() {
    pipe(COLUMN_OUTER_DIA, COLUMN_INNER_DIA, COLUMN_HEIGHT + PLATE_LENGTH/3);
    translate([0, 0, COLUMN_HEIGHT])
    rotate([PLATE_ANGLE, 0, 0])
    translate([0, 0, COLUMN_HEIGHT])
    cube([COLUMN_HEIGHT * 2, COLUMN_HEIGHT * 2, COLUMN_HEIGHT * 2], center = true);
  }
}

translate([0, 0, COLUMN_HEIGHT])
plate();
column();

//pipe(PIPE_OUTER_DIA, PIPE_INNER_DIA, PIPE_HEIGHT);
