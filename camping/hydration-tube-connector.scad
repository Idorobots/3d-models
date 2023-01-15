INNER_DIA = 7; // 7.8;

BASE_DIA = 11;
BASE_THICKNESS = 9.5;
LIP_DIA = 11.5;
LIP_THICKNESS = 1;
LIP_HEIGHT = BASE_THICKNESS;
LOCK_DIA = 9;
LOCK_THICKNESS = 3.5;
LOCK_HEIGHT = LIP_HEIGHT + LIP_THICKNESS;
LEDGE_DIA = 12;
LEDGE_THICKNESS = 2;
LEDGE_HEIGHT = LOCK_HEIGHT + LOCK_THICKNESS;
OUTER_DIA = 16;
OUTER_THICKNESS = 2;
OUTER_HEIGHT = LEDGE_HEIGHT + LEDGE_THICKNESS;

ORING_DIA = 11.5;
ORING_WIDTH = 2;
ORING_HEIGHT = 3;

TUBE_INNER_DIA = 9;
TUBE_OUTER_DIA = 12;
TUBE_THICKNESS = 19 - OUTER_THICKNESS; //20 - OUTER_HEIGHT - OUTER_THICKNESS;

$fn = 100;

module oring() {
  translate([0, 0, ORING_HEIGHT])
  rotate_extrude(angle = 360)
  translate([(ORING_DIA - ORING_WIDTH/2)/2, 0, 0])
  circle(d = ORING_WIDTH, $fn = 30);
}

module tube_mount() {
  difference() {
    cylinder(d = TUBE_OUTER_DIA, h = TUBE_THICKNESS);
    #cylinder(d = TUBE_INNER_DIA, h = TUBE_THICKNESS);
  }
}

module connector() {
  difference() {
    union() {
      cylinder(d = BASE_DIA, h = BASE_THICKNESS);

      translate([0, 0, LIP_HEIGHT])
      cylinder(d1 = LIP_DIA - 0.5, d2 = LIP_DIA, h = LIP_THICKNESS);

      translate([0, 0, LOCK_HEIGHT])
      cylinder(d = LOCK_DIA, h = LOCK_THICKNESS);

      translate([0, 0, LEDGE_HEIGHT])
      cylinder(d1 = LEDGE_DIA - 1, d2 = LEDGE_DIA, h = LEDGE_THICKNESS);

      translate([0, 0, OUTER_HEIGHT])
      cylinder(d = OUTER_DIA, h = OUTER_THICKNESS);

      translate([0, 0, OUTER_HEIGHT + OUTER_THICKNESS])
      tube_mount();
    }

    #cylinder(d = INNER_DIA, h = LEDGE_HEIGHT);
    #translate([0, 0, LEDGE_HEIGHT])
    cylinder(d1 = INNER_DIA, d2 = TUBE_INNER_DIA, h = LEDGE_THICKNESS + OUTER_THICKNESS);
    #oring();
  }
}

connector();
