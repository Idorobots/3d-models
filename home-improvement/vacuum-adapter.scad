INNER_DIA = 29;
OUTER_DIA = 32;

LENGTH = 100;

$fn = 100;

difference() {
  cylinder(d = OUTER_DIA, h = LENGTH);
  cylinder(d = INNER_DIA, h = LENGTH);
}
