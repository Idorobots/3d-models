ROUNDING = 0;

TOP_INNER_DIA = 23 + 2 * ROUNDING;
TOP_OUTER_DIA = 34 - 2 * ROUNDING;
TOP_SLOT_WIDTH = 18;
TOP_SLOT_ANGLE = 22.5; //17.8;

BOT_INNER_DIA = 16 + 2 * ROUNDING;
BOT_OUTER_DIA = 26 - 2 * ROUNDING;
BOT_SLOT_WIDTH = 13;
BOT_SLOT_ANGLE = 198; // 192.3;

TOP_BOT_DIST = 26;
THICKNESS = 5 - 2 * ROUNDING;

$fn = 100;

module loop(outer, inner, thickness) {
  difference() {
    cylinder(d = outer, h = thickness);
    #cylinder(d = inner, h = thickness);
  }
}

module slot(dia, width, thickness) {
  hull() {
    cylinder(d = dia, h = thickness);
    translate([width, 0, 0])
    cylinder(d = dia, h = thickness);
  }
}

module hook() {
  difference() {
    union() {
      loop(TOP_OUTER_DIA, TOP_INNER_DIA, THICKNESS);
      translate([0, TOP_BOT_DIST, 0])
      loop(BOT_OUTER_DIA, BOT_INNER_DIA, THICKNESS);
    }

    #translate([0, (TOP_INNER_DIA - TOP_SLOT_WIDTH)/2, 0])
    rotate([0, 0, TOP_SLOT_ANGLE])
    slot(TOP_SLOT_WIDTH, TOP_OUTER_DIA, THICKNESS);

    #translate([0, TOP_BOT_DIST - (BOT_INNER_DIA - BOT_SLOT_WIDTH)/2, 0])
    rotate([0, 0, BOT_SLOT_ANGLE])
    slot(BOT_SLOT_WIDTH, BOT_OUTER_DIA, THICKNESS);
  }
}

minkowski() {
  hook();
  sphere(d=ROUNDING);
}
