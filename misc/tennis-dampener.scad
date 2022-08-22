LOGO = "logo.svg";
LOGO_DEPTH = 0.5;
LOGO_SCALE = [0.1, 0.1, 1.0];

THICKNESS = 3;
CORNER_DIA = 1.5;
WIDTH = 22;
HEIGHT = 22;

INNER_WIDTH = 10;
INNER_HEIGHT = 10;
SPACING = 1.5;

$fn = 30;

for(s = [0, 1]) {
  rotate([0, s * 180, 0]) {
    translate([0, 0, SPACING/2]) {
      cube(size = [INNER_WIDTH, INNER_HEIGHT, THICKNESS], center = true);

      difference() {
        hull() {
          for(i = [-1, 1]) {
            for(j = [-1, 1]) {
              translate([i * (WIDTH - CORNER_DIA)/2, j * (WIDTH - CORNER_DIA)/2, 0])
              union() {
                cylinder(d = CORNER_DIA, h = THICKNESS - CORNER_DIA/2);
                translate([0, 0, THICKNESS - CORNER_DIA/2])
                sphere(d = CORNER_DIA);
              }
            }
          }
        }
        #translate([0, 0, THICKNESS - LOGO_DEPTH])
        scale(LOGO_SCALE)
        linear_extrude(LOGO_DEPTH)
        import(LOGO, center = true);
      }
    }
  }
}
