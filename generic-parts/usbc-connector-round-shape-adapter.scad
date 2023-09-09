OUTER_DIA = 10.5;
LIP_DIA = 14;
LIP_HEIGHT = 1;
HEIGHT = 8;

USBC_DIA = 3.5;
USBC_WIDTH = 9.5;

$fn = 100;

module base() {
    cylinder(d = LIP_DIA, h = LIP_HEIGHT);
    cylinder(d = OUTER_DIA, h = HEIGHT);
}

module usbc_connector() {
   hull() {
      for(i = [-1, 1]) {
          translate([i * (USBC_WIDTH - USBC_DIA)/2, 0, 0])
          cylinder(d = USBC_DIA, h = HEIGHT);
      }
   }
}

difference() {
    base();
    usbc_connector();
}
