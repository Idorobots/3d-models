HEATSINK_HOLE_DIA = 5;
HEATSINK_HOLE_THICKNESS = 0;
HEATSINK_FLANGE_DIA = 5;
HEATSINK_FLANGE_THICKNESS = 2.5;
HEATSINK_DIA = 14;
HEATSINK_HEIGHT = 20;
HEATSINK_MOUNT_DIA = 7;
HEATSINK_MOUNT_THICKNESS = 2;
HEATSINK_PIPE_DIA = 3;
HEATSINK_PIPE_LENGTH = 4;

PASSTHROUGH_COOLING = false;

ROD_MOUNT_INTEGRATED = true;
ROD_MOUNT_OFFSET = 5;
use <magnetic-delta-rod-mount.scad>;

ROD_MOUNT_DIA = PASSTHROUGH_COOLING ? 75 : 65;
ROD_MOUNT_WIDTH = ROD_MOUNT_INTEGRATED ? 40 : 28;
ROD_MOUNT_HOLE_DIA = 3;
ROD_MOUNT_HOLE_SPACING = 20;
ROD_MOUNT_CORNER_DIA = 7;

BASE_CENTER_DIA = ROD_MOUNT_DIA - ROD_MOUNT_CORNER_DIA;
BASE_CENTER_NUB_DIA = 7;
THICKNESS = 5;

MOUNT_HOLE_DIA = 3;
MOUNT_HOLE_SPACING = 25;
MOUNT_HOLE_HEIGHT = 6 + THICKNESS;

BLOWER_WIDTH = 40;
BLOWER_LENGTH = BLOWER_WIDTH;
BLOWER_THICKNESS = 10;
BLOWER_PORT_WIDTH = 30;
BLOWER_MOUNT_HOLE_DIA = 2;
BLOWER_MOUNT_HOLE_SPACING = 35;

BLOWERS_OFFSET = 0;
BLOWERS_SPACING = 44;

COOLER_MOUNT = !PASSTHROUGH_COOLING;
COOLER_MOUNT_DIA = 55; // 60;
COOLER_MOUNT_HOLE_DIA = 4.5;
COOLER_MOUNT_SHAFT_DIA = 7;
COOLER_MOUNT_SHAFT_LENGTH = 0;
COOLER_MOUNT_ANGLES = [-30, 30, -150, 150]; // [60, 180, -60];

LOAD_CELL = true;

LOAD_CELL_WIDTH = 30;
LOAD_CELL_LENGTH = 30;
LOAD_CELL_DEPTH = 2;
LOAD_CELL_THICKNESS = 3;
LOAD_CELL_MOUNT_HOLE_HEAD_DIA = 6;
LOAD_CELL_MOUNT_HOLE_SPACING = 28;
LOAD_CELL_MOUNT_HOLE_DIA = 3;
LOAD_CELL_MOUNT_HOLE_TAB = 3;
LOAD_CELL_CUTOUT_WIDTH = 15;
LOAD_CELL_CUTOUT_DEPTH = 4;
LOAD_CELL_CUTOUT_OFFSET = LOAD_CELL_LENGTH/2;

$fn = 100;

module heatsink() {
  cylinder(d = HEATSINK_HOLE_DIA, h = HEATSINK_HOLE_THICKNESS);

  translate([0, 0, HEATSINK_HOLE_THICKNESS])
  cylinder(d = HEATSINK_FLANGE_DIA, h = HEATSINK_FLANGE_THICKNESS);

  translate([0, 0, HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS])
  cylinder(d = HEATSINK_DIA, h = HEATSINK_HEIGHT);

  translate([0, 0, HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS])
  cylinder(d = HEATSINK_DIA, h = HEATSINK_HEIGHT);

  translate([0, 0, HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS + HEATSINK_HEIGHT])
  cylinder(d = HEATSINK_MOUNT_DIA, h = HEATSINK_MOUNT_THICKNESS);

  translate([0, 0, HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS + HEATSINK_HEIGHT + HEATSINK_MOUNT_THICKNESS])
  cylinder(d = HEATSINK_PIPE_DIA, h = HEATSINK_PIPE_LENGTH);
}

module blower() {
  translate([-BLOWER_WIDTH/2, -BLOWER_LENGTH/2, 0])
  cube([BLOWER_WIDTH, BLOWER_LENGTH, BLOWER_THICKNESS]);
  translate([-BLOWER_PORT_WIDTH/2, -BLOWER_LENGTH/2 - THICKNESS, 0])
  cube([BLOWER_PORT_WIDTH, BLOWER_LENGTH, BLOWER_THICKNESS]);

  translate([BLOWER_MOUNT_HOLE_SPACING/2, -BLOWER_MOUNT_HOLE_SPACING/2, 0])
  cylinder(d = BLOWER_MOUNT_HOLE_DIA, h = BLOWER_THICKNESS * 2);
  translate([-BLOWER_MOUNT_HOLE_SPACING/2, BLOWER_MOUNT_HOLE_SPACING/2, 0])
  cylinder(d = BLOWER_MOUNT_HOLE_DIA, h = BLOWER_THICKNESS * 2);
  translate([BLOWER_MOUNT_HOLE_SPACING/2, BLOWER_MOUNT_HOLE_SPACING/2, 0])
  cylinder(d = BLOWER_MOUNT_HOLE_DIA, h = BLOWER_THICKNESS * 2);
  translate([-BLOWER_MOUNT_HOLE_SPACING/2, -BLOWER_MOUNT_HOLE_SPACING/2, 0])
  cylinder(d = BLOWER_MOUNT_HOLE_DIA, h = BLOWER_THICKNESS * 2);
}

module passthrough_cooling() {
  translate([BLOWERS_OFFSET, BLOWERS_SPACING/2 + BLOWER_THICKNESS/2, THICKNESS + BLOWER_LENGTH/2])
  rotate([90, 0, 0])
  blower();

  translate([BLOWERS_OFFSET, -BLOWERS_SPACING/2 -BLOWER_THICKNESS/2, THICKNESS + BLOWER_LENGTH/2])
  rotate([90, 0, 180])
  blower();
}

module mount_holes() {
  for(i = [0:5]) {
    rotate([0, 0, i * 60]) {
      translate([MOUNT_HOLE_SPACING/2, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HOLE_HEIGHT, center = true);
    }
  }
}

module load_cell_mount() {
  h = max(THICKNESS, HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS);
  translate([0, 0, h/2])
  intersection() {
    cube([LOAD_CELL_WIDTH, LOAD_CELL_LENGTH, h], center = true);
    w = LOAD_CELL_MOUNT_HOLE_SPACING * sqrt(2) - LOAD_CELL_MOUNT_HOLE_TAB * 2;
    rotate([0, 0, 45])
    cube([w, w, h], center = true);
  }

  translate([LOAD_CELL_CUTOUT_OFFSET, 0, h/2])
  cube([LOAD_CELL_CUTOUT_DEPTH * 2, LOAD_CELL_CUTOUT_WIDTH, h], center = true);

  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * LOAD_CELL_MOUNT_HOLE_SPACING/2, j * LOAD_CELL_MOUNT_HOLE_SPACING/2, 0])
      cylinder(d = LOAD_CELL_MOUNT_HOLE_DIA, h = MOUNT_HOLE_HEIGHT, center = true);
    }
  }

  translate([0, 0, LOAD_CELL_DEPTH * 1.5])
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * LOAD_CELL_MOUNT_HOLE_SPACING/2, j * LOAD_CELL_MOUNT_HOLE_SPACING/2, (LOAD_CELL_THICKNESS - LOAD_CELL_DEPTH)/2])
        cylinder(d = LOAD_CELL_MOUNT_HOLE_HEAD_DIA, h = LOAD_CELL_THICKNESS, center = true);
      }
    }
  }
}

module base() {
  difference() {
    union() {
      cylinder(d = BASE_CENTER_NUB_DIA, h = HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS);
      cylinder(d = BASE_CENTER_DIA, h = THICKNESS);

      for(i = [0:2]) {
        rotate([0, 0, i * 120]) {
          l = ROD_MOUNT_WIDTH - ROD_MOUNT_CORNER_DIA;
          hull() {
            translate([ROD_MOUNT_DIA/2, -l/2, 0])
            cylinder(d = ROD_MOUNT_CORNER_DIA, h = THICKNESS);

            translate([ROD_MOUNT_DIA/2, l/2, 0])
            cylinder(d = ROD_MOUNT_CORNER_DIA, h = THICKNESS);

            translate([0, -l/2, 0])
            cylinder(d = ROD_MOUNT_CORNER_DIA, h = THICKNESS);

            translate([0, l/2, 0])
            cylinder(d = ROD_MOUNT_CORNER_DIA, h = THICKNESS);
          }

          if(ROD_MOUNT_INTEGRATED) {
            translate([ROD_MOUNT_DIA/2, 0, ROD_MOUNT_OFFSET])
            rotate([180, 0, 90])
            rod_mount(false);

          }
        }
      }

      if(COOLER_MOUNT) {
        hull() {
          for(a = COOLER_MOUNT_ANGLES) {
            rotate([0, 0, a])
            translate([COOLER_MOUNT_DIA/2, 0, 0])
            cylinder(d = COOLER_MOUNT_SHAFT_DIA, h = THICKNESS);
          }
        }

        for(a = COOLER_MOUNT_ANGLES) {
          rotate([0, 0, a])
          translate([COOLER_MOUNT_DIA/2, 0, 0])
          cylinder(d = COOLER_MOUNT_SHAFT_DIA, h = THICKNESS + COOLER_MOUNT_SHAFT_LENGTH);
        }
      }
    }

    #for(i = [0:2]) {
      rotate([0, 0, i * 120]) {
        translate([ROD_MOUNT_DIA/2, -ROD_MOUNT_HOLE_SPACING/2, 0])
        cylinder(d = ROD_MOUNT_HOLE_DIA, h = THICKNESS);

        translate([ROD_MOUNT_DIA/2, ROD_MOUNT_HOLE_SPACING/2, 0])
        cylinder(d = ROD_MOUNT_HOLE_DIA, h = THICKNESS);
      }
    }

    #if(COOLER_MOUNT) {
      for(a = COOLER_MOUNT_ANGLES) {
        rotate([0, 0, a]) {
          translate([COOLER_MOUNT_DIA/2, 0, 0])
          cylinder(d = COOLER_MOUNT_HOLE_DIA, h = THICKNESS + COOLER_MOUNT_SHAFT_LENGTH);
        }
      }
    }

    #if(LOAD_CELL) {
      load_cell_mount();
    } else {
      mount_holes();
    }

    #translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
    rotate([180, 0, 0])
    heatsink();

    #if(PASSTHROUGH_COOLING) {
      #translate([0, 0, THICKNESS])
      rotate([180, 0, 0])
      passthrough_cooling();
    }
  }
}

base();
