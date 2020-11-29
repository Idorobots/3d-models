WALL_THICKNESS = 1.2;

OUT_PORT_DIA = 54 + 2 * WALL_THICKNESS + 0.5;
OUT_PORT_LENGTH = 25;

OUTPUT_DIA = 30;
OUTPUT_LENGTH = 50;

$fn = 50;

module output_outside() {
  wt = 2 * WALL_THICKNESS;
  sd = max(OUT_PORT_DIA + wt, OUTPUT_DIA + wt);
  union() {
    translate([(sd - OUTPUT_DIA - wt)/2, 0, OUTPUT_LENGTH]) {
      rotate([0, 90, 0])
      cylinder(d = OUT_PORT_DIA + wt, h = OUT_PORT_LENGTH);
      sphere(d = sd);
    }
    cylinder(d = OUTPUT_DIA + wt, h = OUTPUT_LENGTH);
  }
}

module output_inside() {
  sd = max(OUT_PORT_DIA, OUTPUT_DIA);
  union() {
    translate([(sd + 2 * WALL_THICKNESS - OUTPUT_DIA)/2, 0, OUTPUT_LENGTH]) {
      rotate([0, 90, 0])
      cylinder(d = OUT_PORT_DIA, h = OUT_PORT_LENGTH * 2);
      sphere(d = sd);
    }
    cylinder(d = OUTPUT_DIA, h = OUTPUT_LENGTH);
  }
}

difference() {
  output_outside();
  output_inside();
}