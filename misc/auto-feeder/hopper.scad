WALL_THICKNESS = 1.2;

AUGER_DIA = 54;
AUGER_LENGTH = 30;

SHAFT_LENGTH = 20;
SHAFT_DIA = 22.5;

BEARING_DIA = 22.5;
BEARING_THICKNESS = 5;

OUT_PORT_DIA = AUGER_DIA;
OUT_PORT_LENGTH = 50 - AUGER_LENGTH;

NEMA_MOUNT_OFFSET = 50;
NEMA_SHAFT_DIA = 25;
NEMA_MOUNT_DIA = 4;
NEMA_MOUNT_SPACING = 31;
NEMA_WIDTH = 42;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_SPACING = AUGER_LENGTH - 10;

$fn = 50;

module auger() {
  #union() {
    cylinder(d = AUGER_DIA, h = AUGER_LENGTH);
    translate([0, 0, AUGER_LENGTH + WALL_THICKNESS])
    cylinder(d = BEARING_DIA, h = BEARING_THICKNESS);
    cylinder(d = SHAFT_DIA, h = AUGER_LENGTH + SHAFT_LENGTH);
  }
}

module hopper_inside() {
  #union() {
    translate([0, 0, AUGER_DIA/3])
    cube(size = [AUGER_DIA, AUGER_LENGTH, AUGER_DIA/1.5], center = true);

    translate([0, 0, -(AUGER_DIA - OUT_PORT_DIA)/2])
    rotate([-90, 0, 0])
    cylinder(d = OUT_PORT_DIA, h = AUGER_LENGTH + OUT_PORT_LENGTH);

    translate([0, AUGER_LENGTH/2, 0])
    rotate([90, 0, 0])
    auger();
  }
}

module hopper_outside() {
  union() {
    wt = 2 * WALL_THICKNESS;

    translate([0, -BEARING_THICKNESS/2, AUGER_DIA/3])
    cube(size = [AUGER_DIA + wt, AUGER_LENGTH + BEARING_THICKNESS + wt, AUGER_DIA/1.5], center = true);

    translate([0, (AUGER_LENGTH + wt)/2, 0])
    rotate([90, 0, 0])
    cylinder(d = AUGER_DIA + wt, h = AUGER_LENGTH + BEARING_THICKNESS + wt);

    translate([0, -(AUGER_LENGTH + wt)/2, 0])
    rotate([90, 0, 0])
    cylinder(d = BEARING_DIA + wt, h = BEARING_THICKNESS);

    translate([0, (AUGER_LENGTH + wt)/2, -(AUGER_DIA - OUT_PORT_DIA)/2])
    rotate([-90, 0, 0])
    cylinder(d = OUT_PORT_DIA + wt, h = OUT_PORT_LENGTH);
  }
}

module nema_mount() {
  #union() {
    cylinder(d = NEMA_SHAFT_DIA, h = WALL_THICKNESS + BEARING_THICKNESS);
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * NEMA_MOUNT_SPACING/2, j * NEMA_MOUNT_SPACING/2, 0])
        cylinder(d = NEMA_MOUNT_DIA, h = WALL_THICKNESS + BEARING_THICKNESS);
      }
    }
  }
}

module nema_plate() {
  union() {
    hull() {
      for(i = [-1, 1]) {
        for(j = [-1, 1]) {
          translate([i * (NEMA_WIDTH-NEMA_MOUNT_DIA)/2, j * (NEMA_WIDTH-NEMA_MOUNT_DIA)/2, 0])
          cylinder(d = NEMA_MOUNT_DIA, h = WALL_THICKNESS + BEARING_THICKNESS);
        }
      }
    }

    hull() {
      for(i = [-1, 1]) {
        translate([i * (NEMA_WIDTH-NEMA_MOUNT_DIA)/2, (NEMA_WIDTH-NEMA_MOUNT_DIA)/2, 0])
        cylinder(d = NEMA_MOUNT_DIA, h = WALL_THICKNESS + BEARING_THICKNESS);
      }

      translate([0, NEMA_MOUNT_OFFSET, 0])
      cylinder(d = AUGER_DIA + 2 * WALL_THICKNESS, h = WALL_THICKNESS + BEARING_THICKNESS);
    }
  }
}

module mount_holes() {
  #for(angle = [[90, 0, 0], [90, 0, 90]]) {
    rotate(angle)
    for(i = [-1, 1]) {
      translate([i * MOUNT_HOLE_SPACING/2, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = AUGER_LENGTH * 2, center = true);
    }
  }
}

module drain_hole() {
  #cylinder(d = MOUNT_HOLE_DIA, h = AUGER_LENGTH * 2, center = true);
}

difference() {
  union() {
    translate([0, -AUGER_LENGTH/2, -NEMA_MOUNT_OFFSET])
    rotate([90, 0, 0])
    nema_plate();
    hopper_outside();
  }
  hopper_inside();

  translate([0, -AUGER_LENGTH/2, -NEMA_MOUNT_OFFSET])
  rotate([90, 0, 0])
  nema_mount();

  translate([0, 0, AUGER_DIA/1.5 - 5])
  mount_holes();

  drain_hole();
}
