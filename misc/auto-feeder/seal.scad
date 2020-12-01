WALL_THICKNESS = 1.2;

SEAL_THICKNESS = 2;
SEAL_DIA = 60;
SEAL_MOUNT_HOLE_DIA = 4;
SEAL_HOLES = 6;

ORING_DIA = 40;
ORING_CROSS_DIA = 2;

INPUT_DIA = 33 + 2 * WALL_THICKNESS;
INPUT_LENGTH = 35;


$fn = 50;

module seal() {
  union() {
    cylinder(d = SEAL_DIA, h = SEAL_THICKNESS);
    cylinder(d = INPUT_DIA, h = INPUT_LENGTH);
  }
}

module seal_holes() {
  #union() {
    cylinder(d = INPUT_DIA - 2 * WALL_THICKNESS, h = INPUT_LENGTH);
    for(i = [0:SEAL_HOLES-1]) {
      rotate([0, 0, i * 360/SEAL_HOLES])
      translate([(SEAL_DIA - 2 * SEAL_MOUNT_HOLE_DIA)/2, 0, 0])
      cylinder(d = SEAL_MOUNT_HOLE_DIA, h = SEAL_THICKNESS);
    }
  }
}

module oring() {
  #rotate_extrude()
  translate([ORING_DIA/2, 0, 0])
  circle(d = ORING_CROSS_DIA);
}

difference() {
  seal();
  seal_holes();
  oring();
}