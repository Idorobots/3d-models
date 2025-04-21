MAIN_WIDTH = 30;
MAIN_LENGTH = 80;

BED_WIDTH = 30;
BED_LENGTH = 40;

THICKNESS = 2.5;
CORNER_DIA = 8;

MOUNT_HOLE_DIA = 4;
MAIN_MOUNT_HOLE_SPACING_X = 22;
MAIN_MOUNT_HOLE_SPACING_Y = 72;
BED_MOUNT_HOLE_SPACING_X = 22;
BED_MOUNT_HOLE_SPACING_Y = 32;

MOLEX_HEIGHT = 10;
MOLEX_WIDTH = 7.5;
MOLEX_CENTER_NUB_WIDTH = 2;
MOLEX_CENTER_NUB_THICKNESS = 1.5;
MOLEX_SIDE_TAB_WIDTH = 4;
MOLEX_SIDE_TAB_CLEARANCE = 2.25;

JST_HEIGHT = 10;
JST_WIDTH = 5.5;
JST_CENTER_NUB_WIDTH = 3;
JST_CENTER_NUB_THICKNESS = 2;
JST_SIDE_TAB_WIDTH = 4.5;
JST_SIDE_TAB_CLEARANCE = 2.25;

XC60_HEIGHT = 10;
XC60_WIDTH = 8.5;
XC60_LENGTH = 16.5;
XC60_MOUNT_HOLE_DIA = 3;
XC60_MOUNT_HOLE_SPACING = 20.5;

// MOLEX
TOOLHEAD_LENGTH = 31;
TOOLHEAD_MAIN_PLACEMENT = [6, -14, 0];
TOOLHEAD_MAIN_ORIENTATION = [0, 0, 0];

// MOLEX
LIGHT_LENGTH = 10;
LIGHT_MAIN_PLACEMENT = [-6, 20, 0];
LIGHT_MAIN_ORIENTATION = [0, 0, 180];

LIGHT_BED_PLACEMENT = [0, 7, 0];
LIGHT_BED_ORIENTATION = [0, 0, 90];

// JST
RUNOUT_LENGTH = 10.5;
RUNOUT_MAIN_PLACEMENT = [-6, (TOOLHEAD_LENGTH - LIGHT_LENGTH)/2 -14, 0];
RUNOUT_MAIN_ORIENTATION = [0, 0, 180];

// XC60
BED_MAIN_PLACEMENT = [6, 20, 0];
BED_MAIN_ORIENTATION = [0, 0, 0];

BED_BED_PLACEMENT = [0, -7, 0];
BED_BED_ORIENTATION = [0, 0, 90];


$fn = 100;

module molex(length) {
  translate([0, 0, MOLEX_HEIGHT/2]) {
    cube([MOLEX_WIDTH, length, MOLEX_HEIGHT], center = true);
    cube([MOLEX_SIDE_TAB_WIDTH, length + 2 * MOLEX_SIDE_TAB_CLEARANCE, MOLEX_HEIGHT], center = true);
    translate([MOLEX_CENTER_NUB_THICKNESS, 0, 0])
    cube([MOLEX_WIDTH, MOLEX_CENTER_NUB_WIDTH, MOLEX_HEIGHT], center = true);
  }
}

module jst(length) {
  translate([0, 0, JST_HEIGHT/2]) {
    cube([JST_WIDTH, length, JST_HEIGHT], center = true);
    cube([JST_SIDE_TAB_WIDTH, length + 2 * JST_SIDE_TAB_CLEARANCE, JST_HEIGHT], center = true);
    translate([JST_CENTER_NUB_THICKNESS, 0, 0])
    cube([JST_WIDTH, JST_CENTER_NUB_WIDTH, JST_HEIGHT], center = true);
  }
}

module xc60() {
  translate([0, 0, XC60_HEIGHT/2]) {
    translate([0, -XC60_WIDTH/4, 0])
    cube([XC60_WIDTH, XC60_LENGTH - XC60_WIDTH/2, XC60_HEIGHT], center = true);

    translate([0, (XC60_LENGTH - XC60_WIDTH)/2, 0])
    cylinder(d = XC60_WIDTH, h = XC60_HEIGHT, center = true);

    translate([0, -XC60_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = XC60_MOUNT_HOLE_DIA, h = XC60_HEIGHT, center = true);

    translate([0, XC60_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = XC60_MOUNT_HOLE_DIA, h = XC60_HEIGHT, center = true);
  }
}

module mounting_holes(dia, width, length, height) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    mounting_holes(corner_dia, width - corner_dia, length - corner_dia, height);
  }
}

module main_panel() {
  difference() {
    rounded_rect(MAIN_WIDTH, MAIN_LENGTH, THICKNESS, CORNER_DIA);

    #mounting_holes(MOUNT_HOLE_DIA, MMAIN_OUNT_HOLE_SPACING_X, MAIN_MOUNT_HOLE_SPACING_Y, THICKNESS);

    #translate(TOOLHEAD_MAIN_PLACEMENT)
    rotate(TOOLHEAD_MAIN_ORIENTATION)
    molex(TOOLHEAD_LENGTH);

    #translate(LIGHT_MAIN_PLACEMENT)
    rotate(LIGHT_MAIN_ORIENTATION)
    molex(LIGHT_LENGTH);

    #translate(RUNOUT_MAIN_PLACEMENT)
    rotate(RUNOUT_MAIN_ORIENTATION)
    jst(RUNOUT_LENGTH);

    #translate(BED_MAIN_PLACEMENT)
    rotate(BED_MAIN_ORIENTATION)
    xc60();
  }
}

module bed_panel() {
  difference() {
    rounded_rect(BED_WIDTH, BED_LENGTH, THICKNESS, CORNER_DIA);

    #mounting_holes(MOUNT_HOLE_DIA, BED_MOUNT_HOLE_SPACING_X, BED_MOUNT_HOLE_SPACING_Y, THICKNESS);

    #translate(LIGHT_BED_PLACEMENT)
    rotate(LIGHT_BED_ORIENTATION)
    molex(LIGHT_LENGTH);

    #translate(BED_BED_PLACEMENT)
    rotate(BED_BED_ORIENTATION)
    xc60();
  }
}

bed_panel();
