DIAMETER = 84;
RING_THICKNESS = 5;
RING_BEVEL = 2;
HEIGHT = 2;

LIP_HEIGHT = 3;
LIP_THICKNESS = 2;

HOLE_DIA = 5;
BAR_THICKNESS = 3;

$fn = 100;

module hexagon(d, h) {
  r = d/2;
  linear_extrude(height = h, center = true)
    union() {
      for(i = [0:5]) {
        rotate([0, 0, i * 60])
          polygon(points = [[0, 0], [r, r*tan(-30)], [r, r*tan(30)]]);
      }
    }
}

module honeycomb(dia, hole_dia, bar_thickness, height) {
  DELTA_X = (hole_dia + bar_thickness/2);
  X_HOLES = floor((dia / DELTA_X));
  DELTA_Y = sqrt(pow(hole_dia + bar_thickness/2, 2) - pow(hole_dia/2, 2));
  Y_HOLES = floor(dia / DELTA_Y);

  difference() {
    cylinder(d = dia, h = height, center = true);
    translate([-(X_HOLES*DELTA_X)/2, -(Y_HOLES*DELTA_Y)/2, 0])
      for(j = [0:Y_HOLES]) {
        for(i = [0:X_HOLES + (j % 2)]) {
          translate([-(j % 2) * DELTA_X/2, 0, 0])
            translate([i * DELTA_X, j * DELTA_Y, 0])
              hexagon(hole_dia, height + 2);
        }
      }
  }
}

module ring(outer_dia, inner_dia, thickness, height, center) {
  difference() {
    cylinder(d1 = inner_dia, d2 = outer_dia, h = height, center = center);
    translate([0, 0, -1])
      cylinder(d = outer_dia - 2 * thickness, h = height + 3, center = center);
  }
}

module cover() {
  union() {
    honeycomb(DIAMETER - 2 * RING_THICKNESS, HOLE_DIA, BAR_THICKNESS, HEIGHT);
    ring(DIAMETER, DIAMETER - 2 * RING_BEVEL, RING_THICKNESS, HEIGHT, true);
    translate([0, 0, HEIGHT/2])
      ring(DIAMETER - 2 * (RING_THICKNESS - LIP_THICKNESS), DIAMETER - 2 * (RING_THICKNESS - LIP_THICKNESS), LIP_THICKNESS, LIP_HEIGHT, false);
  }
}

cover();
