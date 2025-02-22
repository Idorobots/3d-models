COOLER_DIA = 60;
COOLER_HEAD_DIA = 6;

PROBE_WIDTH = 13.5;
PROBE_LENGTH = 20.5;
PROBE_THICKNESS = 2;
PROBE_POINT_HEIGHT = 13;
PROBE_POINT_OFFSET_X = 8.5;
PROBE_POINT_OFFSET_Y = 7.5;
PROBE_MOUNT_HOLE_DIA = 2;
PROBE_MOUNT_HOLE_OFFSET_X = 2;
PROBE_MOUNT_HOLE_OFFSET_Y = 2;
PROBE_MOUNT_HOLE_SPACING = 16;
PROBE_CABLE_HOLE_DIA = 4;
PROBE_CABLE_HOLE_OFFSET_X = 7;
PROBE_CABLE_HOLE_OFFSET_Y = 17;

MOUNT_CORNER_DIA = 3;
MOUNT_THICKNESS = 3;
MOUNT_OFFSET_Z = 10;

MOUNT_MAGNET_LIP = 1;
MOUNT_MAGNET_DIA = 6;
MOUNT_MAGNET_HEIGHT = 8;
MOUNT_MAGNET_HOLDER_DIA = 8;

$fn = 30;

module probe() {
  translate([-PROBE_POINT_OFFSET_X, PROBE_POINT_OFFSET_Y, 0]) {
    translate([0, -PROBE_LENGTH, 0])
    cube([PROBE_WIDTH, PROBE_LENGTH, PROBE_THICKNESS]);

    translate([PROBE_POINT_OFFSET_X, -PROBE_POINT_OFFSET_Y, 0])
    cylinder(d = 2, h = PROBE_POINT_HEIGHT);

    #translate([PROBE_MOUNT_HOLE_OFFSET_X, -PROBE_MOUNT_HOLE_OFFSET_Y, 0])
    cylinder(d = PROBE_MOUNT_HOLE_DIA, h = PROBE_POINT_HEIGHT, center = true);

    #translate([PROBE_MOUNT_HOLE_OFFSET_X, -PROBE_MOUNT_HOLE_OFFSET_Y - PROBE_MOUNT_HOLE_SPACING, 0])
    cylinder(d = PROBE_MOUNT_HOLE_DIA, h = PROBE_POINT_HEIGHT, center = true);

    #translate([PROBE_CABLE_HOLE_OFFSET_X, -PROBE_CABLE_HOLE_OFFSET_Y, 0])
    cylinder(d = PROBE_CABLE_HOLE_DIA, h = PROBE_POINT_HEIGHT, center = true);
  }
}

module probe_mount() {
  difference() {
    translate([-PROBE_POINT_OFFSET_X, PROBE_POINT_OFFSET_Y - PROBE_LENGTH, 0])
    hull() {
      for(i = [0, 1]) {
        for(j = [0, 1]) {
          translate([i * PROBE_WIDTH, j * PROBE_LENGTH, 0])
          cylinder(d = MOUNT_CORNER_DIA, h = MOUNT_THICKNESS);
        }
      }
    }

    translate([0, 0, MOUNT_THICKNESS-PROBE_THICKNESS])
    probe();
  }
}

module mount() {
  difference() {
    union() {
      for(i = [0:2]) {
          rotate([0, 0, i * 120])
          translate([-COOLER_DIA/2, 0, 0])
          cylinder(d = MOUNT_MAGNET_HOLDER_DIA, h = 2 * MOUNT_MAGNET_LIP + MOUNT_MAGNET_HEIGHT);
      }


    for(i = [0:2]) {
        hull() {
          rotate([0, 0, i * 120])
          translate([-COOLER_DIA/2, 0, MOUNT_MAGNET_HEIGHT/2 + 2 * MOUNT_MAGNET_LIP])
          cylinder(d = MOUNT_MAGNET_HOLDER_DIA, h = MOUNT_MAGNET_HEIGHT/2);

          translate([0, 0, MOUNT_OFFSET_Z])
          cylinder(d = MOUNT_MAGNET_HOLDER_DIA, h = MOUNT_THICKNESS);
        }
      }

      translate([0, 0, MOUNT_OFFSET_Z])
      probe_mount();
    }

    translate([0, 0, MOUNT_OFFSET_Z+MOUNT_THICKNESS-PROBE_THICKNESS])
    probe();

    for(i = [0:2]) {
        rotate([0, 0, i * 120])
        translate([-COOLER_DIA/2, 0, 0]) {
          cylinder(d = MOUNT_MAGNET_DIA, h = MOUNT_MAGNET_LIP + MOUNT_MAGNET_HEIGHT);
          cylinder(d = MOUNT_MAGNET_DIA - MOUNT_MAGNET_LIP, h = MOUNT_MAGNET_LIP + MOUNT_MAGNET_HEIGHT * 2);
        }
    }
  }
}

mount();
