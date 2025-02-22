HEATSINK_HOLE_DIA = 4;
HEATSINK_HOLE_THICKNESS = 1;
HEATSINK_FLANGE_DIA = 5;
HEATSINK_FLANGE_THICKNESS = 2.5;
HEATSINK_DIA = 14;
HEATSINK_HEIGHT = 20;
HEATSINK_MOUNT_DIA = 7;
HEATSINK_MOUNT_THICKNESS = 2;
HEATSINK_PIPE_DIA = 3;
HEATSINK_PIPE_LENGTH = 4;

PASSTHROUGH_COOLING = false;

ROD_MOUNT_DIA = PASSTHROUGH_COOLING ? 65 : 48;
ROD_MOUNT_WIDTH = 28;
ROD_MOUNT_HOLE_DIA = 3;
ROD_MOUNT_HOLE_SPACING = 20;
ROD_MOUNT_CORNER_DIA = 7;

BASE_CENTER_DIA = ROD_MOUNT_DIA - ROD_MOUNT_CORNER_DIA;
BASE_CENTER_NUB_DIA = 7;
THICKNESS = 2;

MOUNT_HOLE_DIA = 3;
MOUNT_HOLE_SPACING = 25;

FAN_WIDTH = 40;
FAN_LENGTH = FAN_WIDTH;
FAN_THICKNESS = 10;
FAN_MOUNT_HOLE_DIA = 3;
FAN_MOUNT_HOLE_SPACING = 35;
FAN_OFFSET = PASSTHROUGH_COOLING ? 24 : 15;

BLOWER_WIDTH = 40;
BLOWER_LENGTH = BLOWER_WIDTH;
BLOWER_THICKNESS = 10;
BLOWER_PORT_WIDTH = 30;
BLOWER_MOUNT_HOLE_DIA = 2;
BLOWER_MOUNT_HOLE_SPACING = 35;

BLOWERS_OFFSET = -2;
BLOWERS_SPACING = 35;

EXTRUDER_MOUNT = false;
EXTRUDER_MOUNT_HEIGHT = FAN_LENGTH - HEATSINK_HEIGHT - (HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS - THICKNESS);
EXTRUDER_MOUNT_INTERNAL_HEIGHT = 6;
EXTRUDER_MOUNT_DIA = 10;
EXTRUDER_MOUNT_INTERNAL_DIA = 6;
EXTRUDER_GUIDE_DIA = 2;

FAN_SHROUD_HEIGHT = EXTRUDER_MOUNT_HEIGHT + HEATSINK_HEIGHT + (HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS - THICKNESS);
FAN_SHROUD_CHANNEL_DIA = FAN_WIDTH - 3;
FAN_SHROUD_DIA = PASSTHROUGH_COOLING ? BLOWERS_SPACING : EXTRUDER_MOUNT_DIA;

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
  cylinder(d = HEATSINK_MOUNT_DIA, h = HEATSINK_MOUNT_THICKNESS, $fn = 6);

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

module fan() {
  translate([-FAN_WIDTH/2, -FAN_LENGTH/2, 0])
  cube([FAN_WIDTH, FAN_LENGTH, FAN_THICKNESS]);
}

module passthrough_cooling() {
  translate([BLOWERS_OFFSET, BLOWERS_SPACING/2 + BLOWER_THICKNESS/2, THICKNESS + BLOWER_LENGTH/2])
  rotate([90, 0, 0])
  blower();

  translate([BLOWERS_OFFSET, -BLOWERS_SPACING/2 -BLOWER_THICKNESS/2, THICKNESS + BLOWER_LENGTH/2])
  rotate([90, 0, 180])
  blower();
}

module hotend_fan_body() {
  translate([FAN_OFFSET +FAN_THICKNESS/2, 0, THICKNESS + FAN_LENGTH/2])
  rotate([0, -90, 0])
  fan();
}

module hotend_fan() {
  translate([FAN_OFFSET +FAN_THICKNESS/2, 0, THICKNESS + FAN_LENGTH/2])
  rotate([0, -90, 0]) {
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

module extruder_mount() {
  difference() {
    cylinder(d = EXTRUDER_MOUNT_DIA, h = EXTRUDER_MOUNT_HEIGHT);
    cylinder(d = EXTRUDER_GUIDE_DIA, h = EXTRUDER_MOUNT_HEIGHT);
    translate([0, 0, EXTRUDER_MOUNT_HEIGHT - EXTRUDER_MOUNT_INTERNAL_HEIGHT])
    cylinder(d = EXTRUDER_MOUNT_INTERNAL_DIA, h = EXTRUDER_MOUNT_INTERNAL_HEIGHT);
  }
}

module mount_holes() {
  for(i = [0:2]) {
    rotate([0, 0, i * 120]) {
      translate([MOUNT_HOLE_SPACING/2, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS * 4);
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
          hull() {
            l = ROD_MOUNT_WIDTH - ROD_MOUNT_CORNER_DIA;
            translate([ROD_MOUNT_DIA/2, -l/2, 0])
            cylinder(d = ROD_MOUNT_CORNER_DIA, h = THICKNESS);

            translate([ROD_MOUNT_DIA/2, l/2, 0])
            cylinder(d = ROD_MOUNT_CORNER_DIA, h = THICKNESS);

            translate([0, -l/2, 0])
            cylinder(d = ROD_MOUNT_CORNER_DIA, h = THICKNESS);

            translate([0, l/2, 0])
            cylinder(d = ROD_MOUNT_CORNER_DIA, h = THICKNESS);
          }
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

    #mount_holes();
    #heatsink();

    if(PASSTHROUGH_COOLING) {
      #passthrough_cooling();
    }
  }
}

module fan_shroud() {
  difference() {
    union() {
      difference() {
        hull() {
          hotend_fan_body();

          translate([0, 0, THICKNESS])
          if(PASSTHROUGH_COOLING) {
            translate([-BLOWER_WIDTH/2 + BLOWERS_OFFSET, -FAN_SHROUD_DIA/2, 0])
            cube([BLOWER_WIDTH, FAN_SHROUD_DIA, FAN_SHROUD_HEIGHT]);
          } else {
            cylinder(d1 = MOUNT_HOLE_SPACING + MOUNT_HOLE_DIA * 2, d2 = FAN_SHROUD_DIA, h = FAN_SHROUD_HEIGHT);
          }
        }

        #translate([0, 0, FAN_LENGTH/2 + THICKNESS])
        rotate([0, -90, 0])
        cylinder(d = FAN_SHROUD_CHANNEL_DIA, h = FAN_SHROUD_HEIGHT * 2, center = true);
      }

      if(EXTRUDER_MOUNT) {
        translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS + HEATSINK_HEIGHT])
        extruder_mount();
      } else {
        translate([0, 0, THICKNESS + FAN_SHROUD_HEIGHT - EXTRUDER_MOUNT_INTERNAL_HEIGHT])
        cylinder(d = EXTRUDER_MOUNT_DIA, h = EXTRUDER_MOUNT_INTERNAL_HEIGHT);
      }
    }

    #translate([0, 0, FAN_SHROUD_HEIGHT - EXTRUDER_MOUNT_INTERNAL_HEIGHT + THICKNESS])
    cylinder(d = EXTRUDER_MOUNT_INTERNAL_DIA, h = EXTRUDER_MOUNT_INTERNAL_HEIGHT);

    cylinder(d = HEATSINK_DIA, h = THICKNESS + HEATSINK_FLANGE_THICKNESS);

    #heatsink();
    #mount_holes();
    #hotend_fan();
    #base();

    if(PASSTHROUGH_COOLING) {
      #passthrough_cooling();
    }
  }
}

fan_shroud();
base();
