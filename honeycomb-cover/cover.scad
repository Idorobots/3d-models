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
  cylinder(d = d * 2*sqrt(3)/3, h = h, center = true, $fn = 6);
}

module honeycomb(dia, hole_dia, bar_thickness, height) {
  DELTA_X = sqrt(pow(hole_dia + bar_thickness/2, 2) - pow(hole_dia/2, 2));
  X_HOLES = floor((dia / DELTA_X));
  DELTA_Y = (hole_dia + bar_thickness/2);
  Y_HOLES = floor(dia / DELTA_Y);

  difference() {
    cylinder(d = dia, h = height, center = true);
    union() {
      translate([-(X_HOLES*DELTA_X)/2, -(Y_HOLES*DELTA_Y)/2, 0])
        for(i = [0:X_HOLES]) {
          for(j = [0:Y_HOLES + (i % 2)]) {
            translate([0, -(i % 2) * DELTA_X/2, 0])
              translate([i * DELTA_X, j * DELTA_Y, 0])
                hexagon(hole_dia, height + 2);
          }
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
