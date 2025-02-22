include <flat-effector.scad>;

PASSTHROUGH_COOLING = false;

FAN_WIDTH = 40;
FAN_LENGTH = FAN_WIDTH;
FAN_THICKNESS = 10;
FAN_MOUNT_HOLE_DIA = 3;
FAN_MOUNT_HOLE_SPACING = 35;
FAN_OFFSET = PASSTHROUGH_COOLING ? 24 : 15;

EXTRUDER_MOUNT = true;
EXTRUDER_MOUNT_HEIGHT = FAN_LENGTH - HEATSINK_HEIGHT - (HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS - THICKNESS);
EXTRUDER_MOUNT_INTERNAL_HEIGHT = 6;
EXTRUDER_MOUNT_DIA = 10;
EXTRUDER_MOUNT_INTERNAL_DIA = 6;
EXTRUDER_GUIDE_DIA = 2;

FAN_SHROUD_HEIGHT = EXTRUDER_MOUNT_HEIGHT + HEATSINK_HEIGHT + (HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS - THICKNESS);
FAN_SHROUD_CHANNEL_DIA = FAN_WIDTH - 3;
FAN_SHROUD_DIA = PASSTHROUGH_COOLING ? BLOWERS_SPACING : EXTRUDER_MOUNT_DIA;

$fn = 50;

module fan() {
  translate([-FAN_WIDTH/2, -FAN_LENGTH/2, 0])
  cube([FAN_WIDTH, FAN_LENGTH, FAN_THICKNESS]);
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
