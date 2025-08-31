WIDTH = 10;
LENGTH = 25;
THICKNESS = 10;

HOLE_DIA = 5.5; //4.5;
HOLE_SPACING = 16;

$fn = 100;

difference() {
  translate([-WIDTH/2, -LENGTH/2, 0])
  cube(size = [WIDTH, LENGTH, THICKNESS]);

  translate([0, -HOLE_SPACING/2, 0])
  cylinder(d = HOLE_DIA, h = THICKNESS);

  translate([0, HOLE_SPACING/2, 0])
  cylinder(d = HOLE_DIA, h = THICKNESS);
}
