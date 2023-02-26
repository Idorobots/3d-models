OUTER_DIA = 13;
INNER_DIA = 8;
THICKNESS = 3;
SPACING = 18;

$fn = 50;

difference() {
  hull() {
    translate([-SPACING/2, 0, 0])
    cylinder(d = OUTER_DIA, h = THICKNESS);
    translate([SPACING/2, 0, 0])
    cylinder(d = OUTER_DIA, h = THICKNESS);
  }

  translate([-SPACING/2, 0, 0])
  cylinder(d = INNER_DIA, h = THICKNESS);
  translate([SPACING/2, 0, 0])
  cylinder(d = INNER_DIA, h = THICKNESS);
}
