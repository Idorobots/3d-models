THICKNESS = 2; // 2.5;

BEARING_INNER_DIA = 12.75;
BEARING_OUTER_DIA = 37;
BEARING_THICKNESS = 12;

BASE_DIA = 150;
BASE_SPOKES = 3;
BASE_SPOKE_DIA = 18;
BASE_THICKNESS = THICKNESS;

HOLDER_OUTER_DIA = 80; //70; // 90; // 70;
HOLDER_INNER_DIA_BOT = 65; //50; //75; // 53;
HOLDER_INNER_DIA_TOP = 62; //48; // 72; // 50;
HOLDER_THICKNESS = 15;

$fn = 100;

module base() {
  for(i = [0:BASE_SPOKES-1]) {
    rotate([0, 0, i * 360/BASE_SPOKES])
    hull() {
      translate([0, (BASE_DIA - BASE_SPOKE_DIA)/2, 0])
      cylinder(d = BASE_SPOKE_DIA, h = BASE_THICKNESS);
      cylinder(d = BASE_SPOKE_DIA, h = BASE_THICKNESS);
    }
  }

  cylinder(d = BASE_SPOKE_DIA, h = 2 * BASE_THICKNESS);

  cylinder(d1 = BEARING_INNER_DIA, d2 = BEARING_INNER_DIA - 1, h = 2 * BASE_THICKNESS + BEARING_THICKNESS);
}

module holder() {
  difference() {
    union() {
      cylinder(d = HOLDER_OUTER_DIA, h = THICKNESS);
      translate([0, 0, BASE_THICKNESS])
      cylinder(d1 = HOLDER_INNER_DIA_BOT, d2 = HOLDER_INNER_DIA_TOP, h = HOLDER_THICKNESS);
    }

    #if(HOLDER_INNER_DIA_TOP - BEARING_OUTER_DIA > 6 * THICKNESS) {
      translate([0, 0, THICKNESS])
      difference() {
        cylinder(d = HOLDER_INNER_DIA_TOP - 2 * THICKNESS, h = HOLDER_THICKNESS);
        cylinder(d = BEARING_OUTER_DIA + 2 * THICKNESS, h = max(HOLDER_THICKNESS, BEARING_THICKNESS));
      }
    }
    cylinder(d = BEARING_OUTER_DIA, h = BASE_THICKNESS + max(HOLDER_THICKNESS, BEARING_THICKNESS));
  }
}

base();
translate([0, 0, 2 * BASE_THICKNESS])
!holder();
