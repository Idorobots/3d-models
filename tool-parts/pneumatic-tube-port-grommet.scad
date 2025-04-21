INNER_DIA = 8.5;
OUTER_DIA = 10.5;
GROMMET_DIA = 12;
PASSTHROUGH_DIA = 6;
THICKNESS = 1;
HEIGHT = 6 + THICKNESS;

GROOVE_DEPTH = 0.5;
GROOVE_HEIGHT = HEIGHT - 2;

$fn = 200;

difference() {
  union() {
    cylinder(d = OUTER_DIA, h = HEIGHT);
    translate([0, 0, HEIGHT - THICKNESS])
    cylinder(d = GROMMET_DIA, h = THICKNESS);
    translate([0, 0, HEIGHT - 2 * THICKNESS])
    cylinder(d1 = OUTER_DIA, d2 = GROMMET_DIA, h = THICKNESS);
  }

  translate([0, 0, THICKNESS])
  cylinder(d = INNER_DIA, h = HEIGHT);

  cylinder(d = PASSTHROUGH_DIA, h = THICKNESS);

  #translate([0, 0, GROOVE_HEIGHT])
  rotate_extrude(angle = 360)
  translate([-INNER_DIA/2, 0, 0])
  rotate([0, 0, 45])
  square(GROOVE_DEPTH);
}
