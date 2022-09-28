OUTER_DIA = 12.4;
INNER_DIA = 8;

BEARING_INNER_DIA = 7.6;
BEARING_OUTER_DIA = 8.4;

HEIGHT = 10;
BEARING_HEIGHT = 10;

$fn = 50;

union() {
  difference() {
    cylinder(d = OUTER_DIA, h = HEIGHT, $fn = 6);
    cylinder(d = INNER_DIA, h = HEIGHT, $fn = 6);
  }
  translate([0, 0, HEIGHT])
  difference() {
    cylinder(d = BEARING_OUTER_DIA, h = BEARING_HEIGHT);
    cylinder(d = BEARING_INNER_DIA, h = BEARING_HEIGHT);
  }
}
