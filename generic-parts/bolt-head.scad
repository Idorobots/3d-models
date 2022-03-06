BOLT_DIA = 6;
BOLT_HEAD_DIA = 9.5;
BOLT_HEAD_HEIGHT = 4;

HEAD_DIA = 30;
HEAD_KNURL_DIA = 2;
HEAD_HEIGHT = 10;

$fn = 30;

module bolt() {
  cylinder(d = BOLT_DIA, h = HEAD_HEIGHT);
  cylinder(d = BOLT_HEAD_DIA, $fn = 6, h = BOLT_HEAD_HEIGHT);
}

module head() {
  difference() {
    cylinder(d = HEAD_DIA, h = HEAD_HEIGHT);
    n = (3.1415 * HEAD_DIA)/HEAD_KNURL_DIA;
    for(i = [0 : n]) {
      rotate([0, 0, i * 360/n])
      translate([HEAD_DIA/2, 0, 0])
      cylinder(d = HEAD_KNURL_DIA, h = HEAD_HEIGHT);
    }
    bolt();
  }
}

head();