HEIGHT = 20;
DIAMETER = 85;
WALL_THICKNESS = 1.5;

HOLE_SPACING = 45;
HOLE_INNER_DIA = 7;
HOLE_OUTER_DIA = 10;

$fn = 200;

module holes(dia, spacing1, spacing2) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      hull() {
        translate([i * spacing1/2, j * spacing1/2, 0])
            cylinder(d = dia, h = HEIGHT);

        translate([i * spacing2/2, j * spacing2/2, 0])
            cylinder(d = dia, h = HEIGHT);
      }
    }
  }

}

difference() {
  union() {
    difference() {
      cylinder(d = DIAMETER, h = HEIGHT);
      cylinder(d = DIAMETER - 2 * WALL_THICKNESS, h = HEIGHT);
    }
    intersection() {
      holes(HOLE_OUTER_DIA, HOLE_SPACING, HOLE_SPACING * 2);
      cylinder(d = DIAMETER, h = HEIGHT);
    }
  }
  holes(HOLE_INNER_DIA, HOLE_SPACING, HOLE_SPACING);
}
