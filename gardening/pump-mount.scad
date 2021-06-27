MOUNT_DIA = 130;
MOUNT_THICKNESS = 1;

MOUNT_HOLE_SPACING = 40;
MOUNT_HOLE_DIA = 3.5;

PUMP_DOVE_WIDTH = 23.5;
PUMP_DOVE_LENGTH = 27;
PUMP_DOVE_HEIGHT = 4;
PUMP_DOVE_SIDE = PUMP_DOVE_WIDTH/sqrt(2);

PUMP_DIA = 24;
PUMP_LENGTH = 42;

PUMP_MOUNT_WIDTH = 30;
PUMP_MOUNT_LENGTH = 25;
PUMP_MOUNT_HEIGHT = 5;

PUMP_MOUNT_OFFSET_X = 42;
PUMP_MOUNT_OFFSET_Y = 15;

$fn = 50;

module dove() {
  union() {
    intersection() {
      rotate([0, 45, 0])
      cube(size = [PUMP_DOVE_SIDE, PUMP_DOVE_LENGTH, PUMP_DOVE_SIDE], center = true);
      
      translate([0, 0, PUMP_DOVE_HEIGHT/2])
      cube(size = [PUMP_DOVE_WIDTH, PUMP_DOVE_LENGTH, PUMP_DOVE_HEIGHT], center = true);
    }
    
    translate([0, 0, PUMP_DIA/2])
    rotate([90, 0, 0])
    cylinder(d = PUMP_DIA, h = PUMP_LENGTH, center = true);

  }
}

module pump_mount() {
  difference() {
    translate([0, 0, PUMP_MOUNT_HEIGHT/2])
    cube(size = [PUMP_MOUNT_WIDTH, PUMP_MOUNT_LENGTH, PUMP_MOUNT_HEIGHT], center = true);
    dove();
  }
} 

module mount_base() {
  difference() {
    cylinder(d = MOUNT_DIA, h = MOUNT_THICKNESS);
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * MOUNT_HOLE_SPACING/2, j * MOUNT_HOLE_SPACING/2, 0])
        cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_THICKNESS);
      }
    }
  }
}

mount_base();
translate([PUMP_MOUNT_OFFSET_X, PUMP_MOUNT_OFFSET_Y, MOUNT_THICKNESS])
pump_mount();