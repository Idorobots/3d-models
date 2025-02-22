PLATFORM_THICKNESS = 6;
PLATFORM_DIA = 48;
PLATFORM_CENTER_HOLE_DIA = 24;

SIDE_CUTOUT_DEPTH = 1;

ROD_SPACING = 41;
ROD_MOUNT_HOLE_DIA = 3;
ROD_MOUNT_HOLE_HEAD_DIA = 5;
ROD_MOUNT_DIA = 12;
ROD_MOUNT_HEIGHT = 6;

MOUNT_HOLES = 3;
MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_HEAD_DIA = 8;
MOUNT_HOLE_SPACING = 20;

MOUNT_THICKNESS = PLATFORM_THICKNESS;
MOUNT_CENTER_HOLE_DIA = 16;

CLAMP_THICKNESS = 4;
CLAMP_WIDTH = MOUNT_CENTER_HOLE_DIA + 10;

SHROUD_HEIGHT = 30;
SHROUD_FAN_HOLE_DIA_IN = 25;
SHROUD_FAN_HOLE_DIA_OUT = 40;
SHROUD_FAN_HOLE_ANGLE = 70;

SHROUD_FAN_MOUNT_HOLE_SPACING = 35;
SHROUD_FAN_MOUNT_HOLE_DIA = 3;

$fn = 100;

module rod_mount() {
  rotate([90, 0, 0])
  translate([0, 0, -ROD_SPACING/2])
  difference() {
    hull() {
      cylinder(d1 = ROD_MOUNT_HOLE_HEAD_DIA, d2 = ROD_MOUNT_DIA, h = ROD_MOUNT_HEIGHT);
      translate([0, 0, ROD_SPACING-ROD_MOUNT_HEIGHT])
      cylinder(d2 = ROD_MOUNT_HOLE_HEAD_DIA, d1 = ROD_MOUNT_DIA, h = ROD_MOUNT_HEIGHT);
    }
    cylinder(d = ROD_MOUNT_HOLE_DIA, h = ROD_SPACING);
  }
}

module platform() {
  difference() {
    intersection() {
      union() {
        cylinder(d = PLATFORM_DIA - SIDE_CUTOUT_DEPTH*2, h = PLATFORM_THICKNESS, center = true);
        for(i = [0:2]) {
          rotate([0, 0, i * 120])
          translate([PLATFORM_DIA/2, 0, 0])
          rod_mount();
        }
      }
      cylinder(d = PLATFORM_DIA *2 , h = PLATFORM_THICKNESS, center = true);
    }

    cylinder(d = PLATFORM_CENTER_HOLE_DIA, h = PLATFORM_THICKNESS, center = true);

    for(i = [0:2]) {
      rotate([0, 0, i * 120])
      translate([MOUNT_HOLE_SPACING, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = PLATFORM_THICKNESS, center = true);
    }
  }
}

module mount() {
  difference() {
    hull() {
      for(i = [0:2]) {
        rotate([0, 0, i * 120])
        translate([MOUNT_HOLE_SPACING, 0, 0])
        cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_THICKNESS);
      }
    }
    for(i = [0:2]) {
      rotate([0, 0, i * 120])
      translate([MOUNT_HOLE_SPACING, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_THICKNESS);
    }

    cylinder(d = MOUNT_CENTER_HOLE_DIA, h = MOUNT_THICKNESS);
  }
}

module clamp() {

}

module shroud() {
  difference() {
    hull() {
        cylinder(d = PLATFORM_DIA - SIDE_CUTOUT_DEPTH*2, h = PLATFORM_THICKNESS);
        translate([0, 0, SHROUD_HEIGHT - MOUNT_THICKNESS + PLATFORM_THICKNESS])
        mount();
    }
    for(i = [0:2]) {
      rotate([0, 0, i * 120])
      translate([MOUNT_HOLE_SPACING, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = SHROUD_HEIGHT + PLATFORM_THICKNESS);
    }

    cylinder(d = PLATFORM_CENTER_HOLE_DIA, h = SHROUD_HEIGHT + PLATFORM_THICKNESS);

    #for(i = [0:1]) {
      rotate([0, 0, i * 120 + 60])
      translate([MOUNT_HOLE_SPACING, 0, SHROUD_HEIGHT/2 + PLATFORM_THICKNESS])
      rotate([0, SHROUD_FAN_HOLE_ANGLE, 0]) {
        cylinder(d1 = SHROUD_FAN_HOLE_DIA_IN, d2 = SHROUD_FAN_HOLE_DIA_OUT, h = SHROUD_HEIGHT + PLATFORM_THICKNESS, center = true);
        for(i = [-1, 1]) {
          for(j = [-1, 1]) {
            translate([i * SHROUD_FAN_MOUNT_HOLE_SPACING/2, j * SHROUD_FAN_MOUNT_HOLE_SPACING/2, 0])
            cylinder(d = SHROUD_FAN_MOUNT_HOLE_DIA, h = SHROUD_HEIGHT);
          }
        }
      }
    }
  }
}

platform();

translate([0, 0, -PLATFORM_THICKNESS/2])
shroud();

translate([0, 0, SHROUD_HEIGHT + 5])
mount();
