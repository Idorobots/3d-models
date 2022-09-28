INNER_DIA = 31.5;
INNER_DIA_CONN = 14;
OUTER_DIA = 36;
OUTER_DIA_CONN = 18;
HEIGHT = 12;
DIST = 35;


$fn = 100;

module rings(dia, inner_dia, height, dist) {
  union() {
    translate([-dist/2, 0, 0])
    cylinder(d = dia, h = height);
    translate([dist/2, 0, 0])
    cylinder(d = dia, h = height);

    hull() {
        translate([-dist/2, 0, 0])
        cylinder(d = inner_dia, h = height);
        translate([dist/2, 0, 0])
        cylinder(d = inner_dia, h = height);
    }
  }
}

difference() {
  rings(OUTER_DIA, OUTER_DIA_CONN, HEIGHT, DIST);
  rings(INNER_DIA, INNER_DIA_CONN, HEIGHT, DIST);
}
