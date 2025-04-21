LENGTH = 80;
WIDTH = 30;
BASE_WIDTH = 7;
THICKNESS_MIN = 0.8;
THICKNESS_MAX = 2;
CORNER_DIA = 2 * BASE_WIDTH;

TOOTH_LENGTH = WIDTH - BASE_WIDTH;
TEETH = 30;
TOOTH_WIDTH_RATIO = 0.4; // END / BASE
TOOTH_WIDTH_MID = LENGTH / (TEETH - TOOTH_WIDTH_RATIO);
TOOTH_WIDTH_BASE = (1 - TOOTH_WIDTH_RATIO) * TOOTH_WIDTH_MID;
TOOTH_WIDTH_END = TOOTH_WIDTH_RATIO * TOOTH_WIDTH_MID;

$fn = 100;


module tooth() {
  hull() {
    cylinder(d = TOOTH_WIDTH_BASE, h = THICKNESS_MAX);
    translate([TOOTH_LENGTH - TOOTH_WIDTH_END/2, 0, 0])
    cylinder(d = TOOTH_WIDTH_END, h = THICKNESS_MAX);
  }
}

module teeth() {
  for(i = [0:TEETH-1]) {
    translate([0, i * TOOTH_WIDTH_MID + 0.5 * TOOTH_WIDTH_BASE - LENGTH/2, 0])
    tooth();
  }
}

module base() {
  translate([-BASE_WIDTH, 0, 0])
  intersection() {
    hull() {
      translate([CORNER_DIA - BASE_WIDTH, -(LENGTH - CORNER_DIA)/2, 0])
      cylinder(d = CORNER_DIA, h = THICKNESS_MAX);
      translate([CORNER_DIA - BASE_WIDTH, +(LENGTH - CORNER_DIA)/2, 0])
      cylinder(d = CORNER_DIA, h = THICKNESS_MAX);
    }

    translate([0, -LENGTH/2, 0])
    cube([BASE_WIDTH, LENGTH, THICKNESS_MAX]);
  }
}

module comb() {
  intersection() {
    difference() {
      union() {
        base();
        teeth();
      }

      #translate([TOOTH_LENGTH - TOOTH_WIDTH_END/2, TOOTH_WIDTH_MID/2, 0])
      rotate([0, 0, 180])
      teeth();
    }

    #hull() {
      translate([-BASE_WIDTH, -LENGTH/2, 0])
      cylinder(d = 1, h = THICKNESS_MAX);
      translate([-BASE_WIDTH, LENGTH/2, 0])
      cylinder(d = 1, h = THICKNESS_MAX);
      translate([-BASE_WIDTH + WIDTH, -LENGTH/2, 0])
      cylinder(d = 1, h = THICKNESS_MIN);
      translate([-BASE_WIDTH + WIDTH, +LENGTH/2, 0])
      cylinder(d = 1, h = THICKNESS_MIN);
    }
  }
}

comb();
