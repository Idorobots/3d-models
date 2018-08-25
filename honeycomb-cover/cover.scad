DIAMETER = 60;
HEIGHT = 2;
HOLE_DIA = 5;
BAR_THICKNESS = 2;

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
    cylinder(d = dia, h = HEIGHT, center = true);

    translate([-(X_HOLES*DELTA_X)/2, -(Y_HOLES*DELTA_Y)/2, 0])
      for(i = [0:X_HOLES]) {
        for(j = [0:Y_HOLES]) {
          translate([-DELTA_X/2, 0, 0])
            translate([(j % 2) * DELTA_X/2, 0, 0])
              translate([i * DELTA_X, j * DELTA_Y, 0])
                hexagon(hole_dia, height + 2);
        }
      }
  }
}

honeycomb(DIAMETER, HOLE_DIA, BAR_THICKNESS, HEIGHT);
