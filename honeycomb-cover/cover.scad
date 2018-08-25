DIAMETER = 84;
RING_THICKNESS = 5;
HEIGHT = 2;
LIP_HEIGHT = 5;
HOLE_DIA = 5;
BAR_THICKNESS = 2;

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

module ring(dia, bar_thickness, height, center) {
  difference() {
    cylinder(d = dia, h = height, center = center);
    translate([0, 0, -1])
      cylinder(d = dia - 2 * bar_thickness, h = height + 3, center = center);
  }
}

union() {
  honeycomb(DIAMETER-RING_THICKNESS, HOLE_DIA, BAR_THICKNESS, HEIGHT);
  ring(DIAMETER, RING_THICKNESS, HEIGHT, true);
  translate([0, 0, HEIGHT/2])
    ring(DIAMETER - RING_THICKNESS + BAR_THICKNESS, BAR_THICKNESS, LIP_HEIGHT, false);
}
