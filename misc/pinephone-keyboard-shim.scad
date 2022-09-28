INNER_DIA = 6.5;
OUTER_DIA = 8.5;
THICKNESS = 0.2;

$fn = 100;

module shim() {
  difference() {
    cylinder(d = OUTER_DIA, h = THICKNESS);
    cylinder(d = INNER_DIA, h = THICKNESS);
  }
}

shim();
