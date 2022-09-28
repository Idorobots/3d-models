RADIATOR_OUTER_DIA = 105;
RADIATOR_INNER_DIA = 64;
RADIATOR_HEIGHT = 18;

WALL_THICKNESS = 2.5;
OUTER_DIA = 115; // RADIATOR_OUTER_DIA + 2 * WALL_THICKNESS;
INNER_DIA = RADIATOR_INNER_DIA - 2 * WALL_THICKNESS;
ROUNDING_DIA = 10;
HEIGHT = RADIATOR_HEIGHT + WALL_THICKNESS + ROUNDING_DIA/2;

$fn = 100;

module rounded_cylinder(d, h, rounding) {
  union() {
    translate([0, 0, rounding/2])
    hull() {
      rotate_extrude(angle = 360) {
        translate([(d-rounding)/2, 0, 0])
        circle(d = rounding);
      }
    }
    translate([0, 0, rounding/2])
    cylinder(d = d, h = h - rounding/2);
  }
}

module radiator() {
  difference() {
    cylinder(d = RADIATOR_OUTER_DIA, h = RADIATOR_HEIGHT);
    cylinder(d = RADIATOR_INNER_DIA, h = RADIATOR_HEIGHT);
  }
}

difference() {
  rounded_cylinder(d = OUTER_DIA, h = HEIGHT, rounding = ROUNDING_DIA);
  translate([0, 0, HEIGHT - RADIATOR_HEIGHT]) {
    radiator();
    cylinder(d = INNER_DIA, h = HEIGHT - WALL_THICKNESS);
  }
  translate([0, 0, HEIGHT - ROUNDING_DIA/2])
  rounded_cylinder(d = OUTER_DIA, h = HEIGHT, rounding = ROUNDING_DIA);
}
