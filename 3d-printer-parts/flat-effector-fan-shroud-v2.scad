include <flat-effector.scad>;

PASSTHROUGH_COOLING = false;
LOAD_CELL = true;
MOUNT_HOLE_DIA = 4.5; // For metal inserts.
MOUNT_HOLE_HEIGHT = 15;
LOAD_CELL_MOUNT_HOLE_DIA = 4.5; // For metal inserts.

FAN_WIDTH = 41;
FAN_LENGTH = FAN_WIDTH;
FAN_THICKNESS = 10;
FAN_MOUNT_HOLE_DIA = 3;
FAN_MOUNT_HOLE_SPACING = 32;

FAN_ANGLE = 5;
FAN_OFFSET_X = -30;
FAN_OFFSET_Z = THICKNESS + 1;

FAN_CHANNEL_DIA_START = 40;
FAN_CHANNEL_DIA_END = 36;

MOUNT_BRACKET_THICKNESS = 1;

EXTRUDER_MOUNT_HOLE_DIA = 3;
EXTRUDER_MOUNT_HOLE_SPACING = 32;
EXTRUDER_MOUNT_HOLE_OFFSET = 2;
EXTRUDER_MOUNT_TUBE_DIA = 4;

BODY_HEIGHT = 25;
BODY_WIDTH = FAN_WIDTH;
BODY_LENGTH_BOT = BODY_WIDTH;
BODY_LENGTH_TOP = 22;
BODY_CORNER_DIA_BOT = 15;
BODY_CORNER_DIA_TOP = 5;
BODY_TOP_THICKNESS = 2;

$fn = 50;

module fan() {
  translate([-FAN_WIDTH/2, -FAN_LENGTH/2, 0])
  cube([FAN_WIDTH, FAN_LENGTH, FAN_THICKNESS]);
}

module hotend_fan() {
  translate([FAN_OFFSET_X + FAN_THICKNESS/2, 0, THICKNESS + FAN_LENGTH/2 + FAN_OFFSET_Z])
  rotate([0, 90 + FAN_ANGLE, 0]) {
    fan();
    translate([FAN_MOUNT_HOLE_SPACING/2, -FAN_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = FAN_MOUNT_HOLE_DIA, h = FAN_THICKNESS * 2);
    translate([-FAN_MOUNT_HOLE_SPACING/2, FAN_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = FAN_MOUNT_HOLE_DIA, h = FAN_THICKNESS * 2);
    translate([FAN_MOUNT_HOLE_SPACING/2, FAN_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = FAN_MOUNT_HOLE_DIA, h = FAN_THICKNESS * 2);
    translate([-FAN_MOUNT_HOLE_SPACING/2, -FAN_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = FAN_MOUNT_HOLE_DIA, h = FAN_THICKNESS * 2);
  }
}

module air_channel() {
  h = BODY_HEIGHT - BODY_TOP_THICKNESS;
  translate([0, 0, h/2]) {
    // Internal chamber.
    intersection() {
      union() {
        cube([LOAD_CELL_WIDTH, LOAD_CELL_LENGTH, h], center = true);

        translate([0, 0, MOUNT_BRACKET_THICKNESS])
        cube([LOAD_CELL_WIDTH + LOAD_CELL_CUTOUT_DEPTH * 2, LOAD_CELL_LENGTH + LOAD_CELL_CUTOUT_DEPTH * 2, h - MOUNT_BRACKET_THICKNESS], center = true);
      }

      w = LOAD_CELL_MOUNT_HOLE_SPACING * sqrt(2) - LOAD_CELL_MOUNT_HOLE_TAB * 2;
      rotate([0, 0, 45])
      cube([w, w, h], center = true);
    }

    // Fan duct
    intersection() {
      translate([FAN_OFFSET_X + FAN_THICKNESS/2, 0, FAN_LENGTH/4 + FAN_OFFSET_Z])
      rotate([0, 90 + FAN_ANGLE, 0])
      cylinder(d1 = FAN_CHANNEL_DIA_START, d2 = FAN_CHANNEL_DIA_END, h = LOAD_CELL_WIDTH * sqrt(2) + FAN_THICKNESS);

      w = LOAD_CELL_LENGTH * sqrt(2);
      cube([w, w, h], center = true);
    }
  }
}

module extruder_mount_holes() {
  translate([0, -EXTRUDER_MOUNT_HOLE_SPACING/2 - EXTRUDER_MOUNT_HOLE_OFFSET, 0])
  cylinder(d = EXTRUDER_MOUNT_HOLE_DIA, h = MOUNT_HOLE_HEIGHT);

  cylinder(d = EXTRUDER_MOUNT_TUBE_DIA, h = MOUNT_HOLE_HEIGHT);

  translate([0, EXTRUDER_MOUNT_HOLE_SPACING/2 - EXTRUDER_MOUNT_HOLE_OFFSET, 0])
  cylinder(d = EXTRUDER_MOUNT_HOLE_DIA, h = MOUNT_HOLE_HEIGHT);
}

module body() {
  hull() {
    for(j = [-1, 1]) {
      translate([(BODY_LENGTH_BOT - BODY_CORNER_DIA_BOT)/2, j * (BODY_WIDTH - BODY_CORNER_DIA_BOT)/2, 0])
      cylinder(d = BODY_CORNER_DIA_BOT, h = MOUNT_BRACKET_THICKNESS);

      translate([(BODY_LENGTH_TOP - BODY_CORNER_DIA_TOP)/2, j * (BODY_WIDTH - BODY_CORNER_DIA_TOP)/2, BODY_HEIGHT - MOUNT_BRACKET_THICKNESS])
      cylinder(d = BODY_CORNER_DIA_TOP, h = MOUNT_BRACKET_THICKNESS);
    }

    for(j = [-1, 1]) {
      translate([-(BODY_LENGTH_BOT - BODY_CORNER_DIA_BOT)/2, j * (BODY_WIDTH - BODY_CORNER_DIA_BOT)/2, 0])
      cylinder(d = BODY_CORNER_DIA_BOT, h = MOUNT_BRACKET_THICKNESS);

      translate([-(BODY_LENGTH_BOT - BODY_CORNER_DIA_TOP)/2, j * (BODY_WIDTH - BODY_CORNER_DIA_TOP)/2, BODY_HEIGHT - MOUNT_BRACKET_THICKNESS])
      cylinder(d = BODY_CORNER_DIA_TOP, h = MOUNT_BRACKET_THICKNESS);
    }
  }
}

module fan_shroud() {
  difference() {
    translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
    body();

    #translate([0, 0, HEATSINK_HEIGHT + HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS])
    extruder_mount_holes();

    #translate([0, 0, HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS])
    air_channel();

    #heatsink();
    #load_cell_mount();
    #hotend_fan();
    #translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
    rotate([180, 0, 0])
    base();
  }
}

fan_shroud();
