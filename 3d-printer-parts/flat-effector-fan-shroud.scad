use <proxxon-cable-extruder-v3.scad>;

include <flat-effector.scad>;

PASSTHROUGH_COOLING = false;

FAN_WIDTH = 40;
FAN_LENGTH = FAN_WIDTH;
FAN_THICKNESS = 10;
FAN_MOUNT_HOLE_DIA = 3;
FAN_MOUNT_HOLE_SPACING = 35;
FAN_OFFSET = PASSTHROUGH_COOLING ? 24 : 16;

EXTRUDER_MOUNT = true;
EXTRUDER_MOUNT_BUILT_IN = false;
EXTRUDER_HEIGHT = 29; // Body height + port height.
EXTRUDER_WIDTH = 22;
EXTRUDER_MOUNT_HEIGHT = FAN_LENGTH - HEATSINK_HEIGHT - (HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS - THICKNESS);
EXTRUDER_MOUNT_OFFSET = EXTRUDER_MOUNT_BUILT_IN ? 0 : 2.5;
EXTRUDER_MOUNT_INTERNAL_HEIGHT = 4;
EXTRUDER_MOUNT_DIA = 8;
EXTRUDER_MOUNT_INTERNAL_DIA = 6;
EXTRUDER_GUIDE_DIA = 2;
EXTRUDER_MOUNT_STANDOFF_HEIGHT = 3 + EXTRUDER_MOUNT_OFFSET; // Same as bolt head dia + offset.
EXTRUDER_MOUNT_STANDOFF_DIA = 6; // Same as bolt head dia.

FAN_SHROUD_HEIGHT = EXTRUDER_MOUNT_HEIGHT + HEATSINK_HEIGHT + (HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS - THICKNESS);
FAN_SHROUD_WIDTH = 27;
FAN_SHROUD_CHANNEL_DIA = FAN_WIDTH - 2;
FAN_SHROUD_CHANNEL_DIA_END = FAN_WIDTH - 5;
FAN_SHROUD_DIA = PASSTHROUGH_COOLING ? BLOWERS_SPACING : EXTRUDER_MOUNT_DIA;
FAN_SHROUD_CHANNEL_OFFSET = HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS + HEATSINK_HEIGHT + 0.5;

EXTRUDER_FRONT_SUPPORT_THICKNESS = 0;
FLAP_EXCLUSION_OFFSET = 1.5;

MOUNT_HOLE_DIA = 4.5; // For metal inserts.
MOUNT_HOLE_HEIGHT = 10;
LOAD_CELL_MOUNT_HOLE_DIA = 4.5; // For metal inserts.

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

module translate_extruder() {
  translate([0, 0, EXTRUDER_HEIGHT/2])
  rotate([0, 0, 90])
  children();
}

module fan_shroud() {
  extruder_mount_offset = HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS + HEATSINK_HEIGHT + EXTRUDER_MOUNT_OFFSET;
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
            if(EXTRUDER_MOUNT) {
              translate([-FAN_SHROUD_WIDTH/2, -(FAN_WIDTH-FAN_SHROUD_DIA)/2, 0])
              cylinder(d = FAN_SHROUD_DIA, h = FAN_SHROUD_HEIGHT);

              translate([-FAN_SHROUD_WIDTH/2, (FAN_WIDTH-FAN_SHROUD_DIA)/2, 0])
              cylinder(d = FAN_SHROUD_DIA, h = FAN_SHROUD_HEIGHT);
            } else {
              d = MOUNT_HOLE_SPACING + MOUNT_HOLE_DIA * 2;
              cylinder(d = d, h = FAN_SHROUD_HEIGHT/2);
              translate([0, 0, FAN_SHROUD_HEIGHT/2])
              cylinder(d1 = d, d2 = FAN_SHROUD_DIA, h = FAN_SHROUD_HEIGHT/2);
            }
          }
        }

        if(EXTRUDER_MOUNT) {
          translate([0, 0, extruder_mount_offset])
          translate_extruder() {
            body();
            #extruder_bottom(); // For pretty "preview"
          }
        }

        // Main fan channel.
        translate([0, 0, FAN_LENGTH/2 + THICKNESS])
        rotate([0, -90, 0])
        intersection() {
          h = FAN_OFFSET + FAN_SHROUD_WIDTH + MOUNT_HOLE_DIA - EXTRUDER_FRONT_SUPPORT_THICKNESS;
          translate([0, 0, -FAN_OFFSET])
          cylinder(d1 = FAN_SHROUD_CHANNEL_DIA, d2 = FAN_SHROUD_CHANNEL_DIA_END, h = h);

          if(EXTRUDER_MOUNT) {
            translate([-(FAN_SHROUD_CHANNEL_DIA - FAN_SHROUD_CHANNEL_OFFSET)/2, 0, 0])
            cube([FAN_SHROUD_CHANNEL_OFFSET, FAN_SHROUD_CHANNEL_DIA, FAN_SHROUD_HEIGHT], center = true);
          }
        }

        if(EXTRUDER_MOUNT) {
          #translate([0, 0, extruder_mount_offset])
          translate_extruder()
          extruder_top();

          // Flap clearance
          translate([FAN_OFFSET/2 + FLAP_EXCLUSION_OFFSET, FAN_WIDTH/2, FAN_LENGTH])
          rotate([0, -90, 0])
          cylinder(d = FAN_SHROUD_CHANNEL_DIA, h = EXTRUDER_WIDTH);
        } else {
          translate([0, 0, THICKNESS + FAN_SHROUD_HEIGHT - EXTRUDER_MOUNT_INTERNAL_HEIGHT])
          cylinder(d = EXTRUDER_MOUNT_DIA, h = EXTRUDER_MOUNT_INTERNAL_HEIGHT);
        }
      }

      if(EXTRUDER_MOUNT) {
        if(EXTRUDER_MOUNT_BUILT_IN) {
          // Either the full bottom part, or...
          translate([0, 0, extruder_mount_offset])
          translate_extruder()
          extruder_bottom();
        } else {
          // a way to mount the full extruder.
          translate([0, 0, extruder_mount_offset])
          translate_extruder() {
            translate_bolts()
            translate([0, 0, -EXTRUDER_WIDTH/2 - EXTRUDER_MOUNT_OFFSET])
            cylinder(d = EXTRUDER_MOUNT_STANDOFF_DIA, h = EXTRUDER_MOUNT_STANDOFF_HEIGHT);
          }
        }
      } else {
        translate([0, 0, THICKNESS + FAN_SHROUD_HEIGHT - EXTRUDER_MOUNT_INTERNAL_HEIGHT])
        cylinder(d = EXTRUDER_MOUNT_DIA, h = EXTRUDER_MOUNT_INTERNAL_HEIGHT);
      }
    }

    if(EXTRUDER_MOUNT && !EXTRUDER_MOUNT_BUILT_IN) {
      #translate([0, 0, extruder_mount_offset])
      translate_extruder()
      translate_bolts()
      translate([0, 0, -EXTRUDER_HEIGHT/2])
      cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HOLE_HEIGHT);
    }
    #translate([0, 0, FAN_SHROUD_HEIGHT - EXTRUDER_MOUNT_INTERNAL_HEIGHT + THICKNESS])
    cylinder(d = EXTRUDER_MOUNT_INTERNAL_DIA, h = EXTRUDER_MOUNT_INTERNAL_HEIGHT);

    cylinder(d = HEATSINK_DIA, h = THICKNESS + HEATSINK_FLANGE_THICKNESS);

    #heatsink();
    #if(LOAD_CELL) {
      load_cell_mount();
    } else {
      rotate([0, 0, 60])
      mount_holes();
    }

    #hotend_fan();
    #translate([0, 0, HEATSINK_FLANGE_THICKNESS + HEATSINK_HOLE_THICKNESS])
    rotate([180, 0, 0])
    base();

    if(PASSTHROUGH_COOLING) {
      #passthrough_cooling();
    }
  }
}

fan_shroud();
