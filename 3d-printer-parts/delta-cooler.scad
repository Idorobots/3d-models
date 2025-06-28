HEIGHT = 6;
WALL_THICKNESS = 1;

COOLER_DIA_BOT = 35;
COOLER_DIA_TOP = 44;

EXCLUSION_DIA_BOT = 23;
EXCLUSION_DIA_TOP = 35;

PORT_ANGLE = 25;
PORT_SPACING_ANGLES = [90, -90];
PORT_DUCT_LENGTH = 18;
PORT_DUCT_WIDTH = 6.5;
PORT_LENGTH = PORT_DUCT_LENGTH + 2 * WALL_THICKNESS;
PORT_WIDTH = PORT_DUCT_WIDTH + 2 * WALL_THICKNESS;
PORT_DEPTH = 35 * sin(PORT_ANGLE);

ACCESS_SLOT = true;
ACCESS_SLOT_ANGLE = 20;

DUCT_HEIGHT = HEIGHT - WALL_THICKNESS;
EXCLUSION_DIA_AT_DUCT_HEIGHT = EXCLUSION_DIA_BOT + (EXCLUSION_DIA_TOP-EXCLUSION_DIA_BOT)*(DUCT_HEIGHT/HEIGHT);
DUCT_INNER_DIA_BOT = EXCLUSION_DIA_BOT + 2 * WALL_THICKNESS;
DUCT_INNER_DIA_TOP = EXCLUSION_DIA_AT_DUCT_HEIGHT + 2 * WALL_THICKNESS;
COOLER_DIA_AT_DUCT_HEIGHT = COOLER_DIA_BOT + (COOLER_DIA_TOP-COOLER_DIA_BOT)*(DUCT_HEIGHT/HEIGHT);
DUCT_OUTER_DIA_BOT = COOLER_DIA_BOT - 2 * WALL_THICKNESS;
DUCT_OUTER_DIA_TOP = COOLER_DIA_AT_DUCT_HEIGHT - 2 * WALL_THICKNESS;
DUCT_BAR_ANGLES = [180];
DUCT_BAR_WIDTH = 1.5;

FAN_HOLE_DIA = 2;
FAN_HOLE_SPACING = 30;
FAN_MOUNT_DIA = 4.5;
FAN_MOUNT_INNER_SPACING = 26;
FAN_MOUNT_OUTER_SPACING = 32;
FAN_MOUNT_THICKNESS = 3;
FAN_MOUNT_OFFSET = 1.5;

COOLER_MOUNT_ANGLE = 25;
COOLER_MOUNT_SPACING_ANGLES = [90-30, 90+30, -60, 240];
COOLER_MOUNT_DIA = 55;
COOLER_MOUNT_HOLE_DIA = 3.5;
COOLER_MOUNT_HEAD_DIA = 6;
COOLER_MOUNT_WIDTH = (COOLER_DIA_TOP - EXCLUSION_DIA_TOP)/2;
COOLER_MOUNT_LENGTH = 8.5;
COOLER_MOUNT_THICKNESS = 6;

$fn = 100;

module exclusion() {
  factor = 1.5;
  D = EXCLUSION_DIA_BOT + factor * (EXCLUSION_DIA_TOP - EXCLUSION_DIA_BOT);
  union() {
    cylinder(d1 = EXCLUSION_DIA_BOT, d2 = D, h = factor * HEIGHT);
    translate([0, 0, factor * HEIGHT])
    cylinder(d = D, h = HEIGHT);
  }
}

module fan_mount() {
  difference() {
    union() {
      hull() {
        translate([0, -PORT_DEPTH, FAN_MOUNT_OFFSET])
        cylinder(d = FAN_MOUNT_DIA, h = FAN_MOUNT_THICKNESS);
        translate([0, PORT_DEPTH/2, FAN_MOUNT_OFFSET])
        cylinder(d = FAN_MOUNT_DIA, h = FAN_MOUNT_THICKNESS);
      }
      hull () {
        translate([(FAN_MOUNT_OUTER_SPACING-PORT_LENGTH)/2, -WALL_THICKNESS, -FAN_MOUNT_THICKNESS + FAN_MOUNT_OFFSET])
        cylinder(d = FAN_MOUNT_DIA, h = FAN_MOUNT_THICKNESS + WALL_THICKNESS);

        translate([0, -WALL_THICKNESS, FAN_MOUNT_OFFSET])
        cylinder(d = FAN_MOUNT_DIA, h = FAN_MOUNT_THICKNESS);

        translate([0, -PORT_DEPTH, FAN_MOUNT_OFFSET])
        cylinder(d = FAN_MOUNT_DIA, h = FAN_MOUNT_THICKNESS);
      }
    }

    translate([0, PORT_DEPTH/2, FAN_MOUNT_OFFSET])
    cylinder(d = FAN_HOLE_DIA, h = FAN_MOUNT_THICKNESS);
  }
}

module port_duct() {
  intersection() {
    rotate([PORT_ANGLE, 0, 0])
    translate([-PORT_DUCT_LENGTH/2, -PORT_DEPTH, 0])
    cube([PORT_DUCT_LENGTH, PORT_DEPTH * 2, PORT_DUCT_WIDTH]);

    translate([0, 0, WALL_THICKNESS])
    cylinder(d = COOLER_DIA_TOP * 2, h = 3 * HEIGHT);
  }
}

module port() {
  intersection() {
    rotate([PORT_ANGLE, 0, 0])
    union() {
      translate([-PORT_LENGTH/2, -PORT_DEPTH/2, 0])
      cube([PORT_LENGTH, PORT_DEPTH, PORT_WIDTH]);

      translate([-(FAN_MOUNT_INNER_SPACING + FAN_MOUNT_OUTER_SPACING)/4, 0, PORT_WIDTH - WALL_THICKNESS])
      fan_mount();

      translate([(FAN_MOUNT_INNER_SPACING + FAN_MOUNT_OUTER_SPACING)/4, 0, PORT_WIDTH - WALL_THICKNESS])
      mirror([1, 0, 0])
      fan_mount();
    }

    cylinder(d = COOLER_DIA_TOP * 2, h = 3 * HEIGHT);
  }
}

module access_slot_duct() {
  hull() {
    rotate([0, 0, -ACCESS_SLOT_ANGLE/2])
    translate([-WALL_THICKNESS/2, 0, 0])
    cube(size = [WALL_THICKNESS, COOLER_DIA_BOT, 2 * HEIGHT]);

    rotate([0, 0, ACCESS_SLOT_ANGLE/2])
    translate([-WALL_THICKNESS/2, 0, 0])
    cube(size = [WALL_THICKNESS, COOLER_DIA_BOT, 2 * HEIGHT]);
  }
}

module duct_base() {
  cylinder(d1 = DUCT_OUTER_DIA_BOT, d2 = DUCT_OUTER_DIA_TOP, h = DUCT_HEIGHT);
}

module access_slot() {
  union() {
    translate([WALL_THICKNESS, 0, 0])
    rotate([0, 0, -ACCESS_SLOT_ANGLE/2])
    translate([-WALL_THICKNESS/2, 0, 0])
    cube(size = [WALL_THICKNESS, COOLER_DIA_BOT, HEIGHT]);
    translate([-WALL_THICKNESS, 0, 0])
    rotate([0, 0, ACCESS_SLOT_ANGLE/2])
    translate([-WALL_THICKNESS/2, 0, 0])
    cube(size = [WALL_THICKNESS, COOLER_DIA_BOT, HEIGHT]);
  }
}

module duct() {
  union() {
    difference() {
      union() {
        duct_base();
        for(a = PORT_SPACING_ANGLES) {
          rotate([0, 0, a])
          translate([0, COOLER_DIA_BOT/2 - WALL_THICKNESS * 1.5, 0])
          port_duct();
        }
      }

      cylinder(d1 = DUCT_INNER_DIA_BOT, d2 = DUCT_INNER_DIA_BOT + 2.5 * (DUCT_INNER_DIA_TOP - DUCT_INNER_DIA_BOT), h = 2.5 * DUCT_HEIGHT);

      for(a = DUCT_BAR_ANGLES) {
        rotate([0, 0, a])
        translate([-DUCT_BAR_WIDTH/2, 0, 0])
        cube([DUCT_BAR_WIDTH, DUCT_OUTER_DIA_BOT, WALL_THICKNESS]);
      }

      if(ACCESS_SLOT) {
        access_slot();
      }
    }
    if(ACCESS_SLOT) {
      access_slot_duct();
    }
  }
}

module mount() {
  translate([COOLER_MOUNT_LENGTH * cos(COOLER_MOUNT_ANGLE), 0, 0])
  rotate([0, COOLER_MOUNT_ANGLE, 0])
  difference() {
    union() {
      hull() {
        translate([-COOLER_MOUNT_LENGTH, 0, 0])
        rotate([0, -COOLER_MOUNT_ANGLE, 0])
        cylinder(d = COOLER_MOUNT_WIDTH, h = COOLER_MOUNT_THICKNESS/2);
        rotate([90, 0, 0])
        translate([0, 0, -COOLER_MOUNT_THICKNESS/2])
        cylinder(d = COOLER_MOUNT_WIDTH, h = COOLER_MOUNT_THICKNESS);
      }
      translate([-COOLER_MOUNT_LENGTH, 0, 0])
      rotate([0, -COOLER_MOUNT_ANGLE, 0])
      translate([0, 0, -COOLER_MOUNT_THICKNESS/2])
      cylinder(d = COOLER_MOUNT_HEAD_DIA, h = COOLER_MOUNT_THICKNESS);
    }
    translate([-COOLER_MOUNT_LENGTH, 0, 0])
    rotate([0, -COOLER_MOUNT_ANGLE, 0])
    translate([0, 0, -COOLER_MOUNT_THICKNESS])
    cylinder(d = COOLER_MOUNT_HOLE_DIA, h = 2*COOLER_MOUNT_THICKNESS);
  }
}

module body() {
  union() {
    cylinder(d1 = COOLER_DIA_BOT, d2 = COOLER_DIA_TOP, h = HEIGHT);
    translate([0, 0, HEIGHT])
    cylinder(d = COOLER_DIA_TOP, h = HEIGHT/2 + WALL_THICKNESS);
    for(a = PORT_SPACING_ANGLES) {
      rotate([0, 0, a])
      translate([0, COOLER_DIA_BOT/2 + WALL_THICKNESS, 0])
      port();
    }
    for(a = COOLER_MOUNT_SPACING_ANGLES) {
      rotate([0, 0,  a])
      translate([-COOLER_MOUNT_DIA/2, 0, HEIGHT])
      mount();
    }
  }
}

module cooler() {
  difference() {
    body();
    exclusion();
    duct();
  }
}

cooler();
