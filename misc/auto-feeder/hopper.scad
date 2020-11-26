WALL_THICKNESS = 1.5;

AUGER_DIA = 52;
AUGER_LENGTH = 52;

SHAFT_LENGTH = 20;
SHAFT_DIA = 8.5;

BEARING_DIA = 22;
BEARING_THICKNESS = 8;

OUT_PORT_DIA = 20;
OUT_PORT_LENGTH = 10;

NEMA_MOUNT_OFFSET = 50;
NEMA_SHAFT_DIA = 23;
NEMA_MOUNT_DIA = 3.5;
NEMA_MOUNT_SPACING = 31;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_SPACING = 40;

$fn = 30;

module auger() {
  #union() {
    cylinder(d = AUGER_DIA, h = AUGER_LENGTH);
    translate([0, 0, AUGER_LENGTH + WALL_THICKNESS])
    cylinder(d = BEARING_DIA, h = BEARING_THICKNESS);
    translate([0, 0, -WALL_THICKNESS])
    cylinder(d = SHAFT_DIA, h = AUGER_LENGTH + SHAFT_LENGTH);
    hull() {
      cylinder(d = SHAFT_DIA, h = AUGER_LENGTH + SHAFT_LENGTH);
      translate([0, AUGER_DIA/2, 0])
      cylinder(d = SHAFT_DIA, h = AUGER_LENGTH + SHAFT_LENGTH);
    }
  }
}

module hopper_inside() {
  #union() {
    translate([0, 0, AUGER_DIA/2])
    cube(size = [AUGER_DIA, AUGER_LENGTH, AUGER_DIA], center = true);
    
    translate([0, 0, -(AUGER_DIA - OUT_PORT_DIA)/2])
    rotate([-90, 0, 0])
    cylinder(d = OUT_PORT_DIA, h = AUGER_LENGTH);
  
    translate([0, AUGER_LENGTH/2, 0])
    rotate([90, 0, 0])
    auger();
  }
}

module hopper_outside() {
  union() {
    wt = 2 * WALL_THICKNESS;
    
    translate([0, 0, AUGER_DIA/2])
    cube(size = [AUGER_DIA + wt, AUGER_LENGTH + wt, AUGER_DIA], center = true);

    translate([0, (AUGER_LENGTH + wt)/2, 0])
    rotate([90, 0, 0])
    cylinder(d = AUGER_DIA + wt, h = AUGER_LENGTH + wt);
    
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
    cylinder(d = NEMA_SHAFT_DIA, h = WALL_THICKNESS);
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * NEMA_MOUNT_SPACING/2, j * NEMA_MOUNT_SPACING/2, 0])
        cylinder(d = NEMA_MOUNT_DIA, h = WALL_THICKNESS);
      }
    }
  }
}

module nema_plate() {
  union() {
    hull() {
      for(i = [-1, 1]) {
        for(j = [-1, 1]) {
          translate([i * NEMA_MOUNT_SPACING/2, j * NEMA_MOUNT_SPACING/2, 0])
          cylinder(d = NEMA_MOUNT_DIA * 2, h = WALL_THICKNESS);
        }
      }
    }
    
    hull() {
      for(i = [-1, 1]) {
        translate([i * NEMA_MOUNT_SPACING/2, NEMA_MOUNT_SPACING/2, 0])
        cylinder(d = NEMA_MOUNT_DIA * 2, h = WALL_THICKNESS);
      }
      
      translate([0, NEMA_MOUNT_OFFSET, 0])
      cylinder(d = AUGER_DIA + 2 * WALL_THICKNESS, h = WALL_THICKNESS);
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
  
  translate([0, 0, AUGER_LENGTH - 2 * MOUNT_HOLE_DIA])
  mount_holes();
  
  drain_hole();
}