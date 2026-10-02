include <flat-effector.scad>;

BASE_INCLUDED = false;
PASSTHROUGH_COOLING = true;
LOAD_CELL = true;
MOUNT_HOLE_DIA = 4.5; // For metal inserts.
MOUNT_HOLE_HEIGHT = 8;
LOAD_CELL_MOUNT_HOLE_DIA = 4.5; // For metal inserts.

FAN_WIDTH = PASSTHROUGH_COOLING ? 32 : 42;
FAN_LENGTH = FAN_WIDTH;
FAN_THICKNESS = 10;
FAN_MOUNT_HOLE_DIA = 3;
FAN_MOUNT_HOLE_SPACING = PASSTHROUGH_COOLING ? 25 : 32;
FAN_MOUNT_HOLE_LENGTH = 16;

FAN_ANGLE = 2;
FAN_OFFSET_X = -31;
FAN_OFFSET_Z = 4;

FAN_CHANNEL_DIA_START = FAN_WIDTH - 1;
FAN_CHANNEL_DIA_END = FAN_CHANNEL_DIA_START;

MOUNT_BRACKET_THICKNESS = 1;

EXTRUDER_MOUNT_HOLE_DIA = 3;
EXTRUDER_MOUNT_HOLE_SPACING = 32;
EXTRUDER_MOUNT_HOLE_OFFSET = 2;
EXTRUDER_MOUNT_TUBE_DIA = 4;
EXTRUDER_MOUNT_TUBE_ADAPTER_DIA = 10;

BODY_HEIGHT = PASSTHROUGH_COOLING ? 32 : 25;
BODY_WIDTH = max(FAN_WIDTH, 42);
BODY_LENGTH_BOT = BODY_WIDTH;
BODY_LENGTH_TOP = 28;
BODY_CORNER_DIA_BOT = 15;
BODY_CORNER_DIA_TOP = 5;
BODY_TOP_THICKNESS = PASSTHROUGH_COOLING ? 7 : 2;

$fn = 100;

module fan() {
  translate([-FAN_WIDTH/2, -FAN_LENGTH/2, 0])
  cube([FAN_WIDTH, FAN_LENGTH, FAN_THICKNESS]);
}

module hotend_fan() {
  translate([FAN_OFFSET_X + FAN_THICKNESS/2, 0, FAN_LENGTH/2 + FAN_OFFSET_Z])
  rotate([0, 90 + FAN_ANGLE, 0]) {
    fan();
    translate([FAN_MOUNT_HOLE_SPACING/2, -FAN_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = FAN_MOUNT_HOLE_DIA, h = FAN_MOUNT_HOLE_LENGTH);
    translate([-FAN_MOUNT_HOLE_SPACING/2, FAN_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = FAN_MOUNT_HOLE_DIA, h = FAN_MOUNT_HOLE_LENGTH);
    translate([FAN_MOUNT_HOLE_SPACING/2, FAN_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = FAN_MOUNT_HOLE_DIA, h = FAN_MOUNT_HOLE_LENGTH);
    translate([-FAN_MOUNT_HOLE_SPACING/2, -FAN_MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = FAN_MOUNT_HOLE_DIA, h = FAN_MOUNT_HOLE_LENGTH);
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
  }
}

module fan_duct() {
  hull() {
    for(h = [FAN_CHANNEL_DIA_START/4 + FAN_OFFSET_Z - THICKNESS/2, (BODY_HEIGHT - BODY_TOP_THICKNESS)/2]) {
      translate([0, 0, h]) {
        // Fan duct
        intersection() {
          translate([FAN_OFFSET_X + FAN_THICKNESS/2, 0, FAN_CHANNEL_DIA_START/4])
          rotate([0, 90, 0])
          cylinder(d1 = FAN_CHANNEL_DIA_START, d2 = FAN_CHANNEL_DIA_END, h = LOAD_CELL_WIDTH * sqrt(2) + FAN_THICKNESS);

          w = LOAD_CELL_LENGTH * sqrt(2);
          cube([w, w, BODY_HEIGHT - BODY_TOP_THICKNESS], center = true);
        }
      }
    }
  }
}

module extruder_mount_holes() {
  translate([0, -EXTRUDER_MOUNT_HOLE_SPACING/2 - EXTRUDER_MOUNT_HOLE_OFFSET, 0])
  cylinder(d = EXTRUDER_MOUNT_HOLE_DIA, h = BODY_TOP_THICKNESS);

  cylinder(d = EXTRUDER_MOUNT_TUBE_DIA, h = BODY_TOP_THICKNESS);

  translate([0, EXTRUDER_MOUNT_HOLE_SPACING/2 - EXTRUDER_MOUNT_HOLE_OFFSET, 0])
  cylinder(d = EXTRUDER_MOUNT_HOLE_DIA, h = BODY_TOP_THICKNESS);
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
    union() {
      difference() {
        translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
        body();

        #translate([0, 0, HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS])
        air_channel();

        #translate([0, 0, HEATSINK_HOLE_THICKNESS + HEATSINK_FLANGE_THICKNESS])
        fan_duct();
      }

      if(PASSTHROUGH_COOLING) {
        translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
        cylinder(d = EXTRUDER_MOUNT_TUBE_ADAPTER_DIA, h = BODY_HEIGHT);
      }
    }

    #translate([0, 0, BODY_HEIGHT - BODY_TOP_THICKNESS + HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
    extruder_mount_holes();

    #heatsink();
    #hotend_fan();
    #translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
    rotate([180, 0, 0]) {
      load_cell_mount();
      base();
    }

    if(PASSTHROUGH_COOLING) {
      #translate([0, 0, -THICKNESS/2])
      passthrough_cooling();
    }
  }
}

fan_shroud();

if(BASE_INCLUDED) {
  translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
  rotate([180, 0, 0])
  base();
}
