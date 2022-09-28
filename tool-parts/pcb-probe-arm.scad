THICKNESS = 3.5;

VERTICAL_LENGTH = 120;
VERTICAL_WIDTH = 12;
VERTICAL_SLOT_DIA = 4.5;
VERTICAL_SLOT_LENGTH = VERTICAL_LENGTH - 50;
VERTICAL_INLAY_DIA = 7.2;
VERTICAL_INLAY_DEPTH = 2;

HORIZONTAL_LENGTH = 120;
HORIZONTAL_WIDTH = VERTICAL_WIDTH;
HORIZONTAL_SLOT_DIA = VERTICAL_SLOT_DIA;
HORIZONTAL_SLOT_LENGTH = HORIZONTAL_LENGTH - 20;
HORIZONTAL_HEAD_DIA = 3.5;
HORIZONTAL_HEAD_INLAY_DIA = 6.4;
HORIZONTAL_HEAD_INLAY_DEPTH = VERTICAL_INLAY_DEPTH;

BASE_HEIGHT = 20;
BASE_DIA = 20;

MAGNET_DIA = 15.2;
MAGNET_THICKNESS = 3;

PROBE_INNER_DIA = 6.5;
PROBE_OUTER_DIA = PROBE_INNER_DIA + 2 * THICKNESS;
PROBE_THICKNESS = 4;
PROBE_LENGTH = 20;
PROBE_ANGLE = 30;


$fn = 100;

module slot(dia, length, thickness) {
  hull() {
    for(i = [-1, 1]) {
      translate([i * (length - dia)/2, 0, 0])
      cylinder(d = dia, h = thickness);
    }
  }
}

module vertical() {
  difference() {
    hull() {
      slot(VERTICAL_WIDTH, VERTICAL_SLOT_LENGTH, THICKNESS);
      translate([VERTICAL_LENGTH/2, 0, THICKNESS/2])
      cube(size = [VERTICAL_LENGTH - VERTICAL_SLOT_LENGTH, VERTICAL_WIDTH, THICKNESS], center = true);
    }
    slot(VERTICAL_SLOT_DIA, VERTICAL_SLOT_LENGTH - VERTICAL_WIDTH/2, THICKNESS);
    slot(VERTICAL_INLAY_DIA, VERTICAL_SLOT_LENGTH - VERTICAL_WIDTH/2 + VERTICAL_SLOT_DIA/2, VERTICAL_INLAY_DEPTH);
  }
}

module horizontal() {
  difference() {
    t = HORIZONTAL_LENGTH/2 + (HORIZONTAL_LENGTH - HORIZONTAL_SLOT_LENGTH - HORIZONTAL_WIDTH)/2;

    hull() {
      slot(HORIZONTAL_WIDTH, HORIZONTAL_SLOT_LENGTH, THICKNESS);
      translate([t, 0, 0])
      cylinder(d = HORIZONTAL_WIDTH, h = THICKNESS);
    }
    slot(HORIZONTAL_SLOT_DIA, HORIZONTAL_SLOT_LENGTH - HORIZONTAL_WIDTH/2, THICKNESS);

    translate([t, 0, 0]) {
      cylinder(d = HORIZONTAL_HEAD_DIA, h = THICKNESS);

      cylinder(d = HORIZONTAL_HEAD_INLAY_DIA, h = HORIZONTAL_HEAD_INLAY_DEPTH, $fn = 6);
    }
  }
}

module base() {
  difference() {
    cylinder(d = BASE_DIA, h = BASE_HEIGHT);
    cylinder(d = MAGNET_DIA, h = MAGNET_THICKNESS);
    delta = 0.4;
    cube(size = [THICKNESS + delta, VERTICAL_WIDTH + delta, VERTICAL_LENGTH], center = true);
  }
}

module probe() {
  difference() {
    union() {
      translate([THICKNESS/3, -(PROBE_OUTER_DIA/2-THICKNESS), 0])
      rotate([0, -PROBE_ANGLE, 0])
      cylinder(d = PROBE_OUTER_DIA, h = PROBE_THICKNESS);

      cube(size = [PROBE_LENGTH, THICKNESS, PROBE_THICKNESS]);

      translate([PROBE_LENGTH, THICKNESS, 0])
      rotate([90, 0, 0])
      cylinder(d = HORIZONTAL_WIDTH, h = THICKNESS);
    }
    translate([THICKNESS/3, -(PROBE_OUTER_DIA/2-THICKNESS), 0])
    rotate([0, -PROBE_ANGLE, 0])
    translate([0, 0, -PROBE_THICKNESS/2]) {
      cylinder(d = PROBE_INNER_DIA, h = PROBE_THICKNESS * 2);
      translate([-0.5, -PROBE_OUTER_DIA, PROBE_THICKNESS/2])
      #cube(size = [1, PROBE_OUTER_DIA, PROBE_THICKNESS]);
    }

    translate([PROBE_LENGTH, THICKNESS, 0])
    rotate([90, 0, 0])
    cylinder(d = HORIZONTAL_HEAD_DIA, h = THICKNESS);
  }
}

!base();
vertical();
horizontal();
probe();
