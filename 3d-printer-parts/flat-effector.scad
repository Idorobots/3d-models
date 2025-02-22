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

MOUNT_HOLE_DIA = 2.5;
MOUNT_HOLE_SPACING = 25;

BLOWER_WIDTH = 40;
BLOWER_LENGTH = BLOWER_WIDTH;
BLOWER_THICKNESS = 10;
BLOWER_PORT_WIDTH = 30;
BLOWER_MOUNT_HOLE_DIA = 2;
BLOWER_MOUNT_HOLE_SPACING = 35;

BLOWERS_OFFSET = -2;
BLOWERS_SPACING = 35;

$fn = 50;

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

module passthrough_cooling() {
  translate([BLOWERS_OFFSET, BLOWERS_SPACING/2 + BLOWER_THICKNESS/2, THICKNESS + BLOWER_LENGTH/2])
  rotate([90, 0, 0])
  blower();

  translate([BLOWERS_OFFSET, -BLOWERS_SPACING/2 -BLOWER_THICKNESS/2, THICKNESS + BLOWER_LENGTH/2])
  rotate([90, 0, 180])
  blower();
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

//base();
