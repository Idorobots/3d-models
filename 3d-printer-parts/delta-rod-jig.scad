WIDTH = 20;
LENGTH = 25;
THICKNESS = 5;

CENTER_HOLE_DIA = 4;

HOLE_OFFSET = 7;

TOP_HOLE_DIA = 4;
TOP_HOLE_HEAD_DIA = 8;

BOTTOM_HOLE_DIA = 3;
BOTTOM_HOLE_HEAD_DIA = 6;

$fn = 50;

difference() {
  translate([0, 0, THICKNESS/2])
  cube([WIDTH, LENGTH, THICKNESS], center = true);

  cylinder(d = CENTER_HOLE_DIA, h = THICKNESS);

  translate([0, -HOLE_OFFSET, 0])
  cylinder(d = BOTTOM_HOLE_HEAD_DIA, h = THICKNESS/2, $fn = 6);

  translate([0, -HOLE_OFFSET, 0])
  cylinder(d = BOTTOM_HOLE_DIA, h = THICKNESS);

  translate([0, HOLE_OFFSET, 0])
  cylinder(d = TOP_HOLE_HEAD_DIA, h = THICKNESS/2, $fn = 6);

  translate([0, HOLE_OFFSET, 0])
  cylinder(d = TOP_HOLE_DIA, h = THICKNESS);
}
