SERVO_WIDTH = 12;
SERVO_LENGTH = 22;
SERVO_HEIGHT = 28;

SERVO_TAB_LENGTH = 32;
SERVO_TAB_THICKNESS = 2.5;
SERVO_TAB_HEIGHT = 17;

SERVO_NUB_DIA = 6;
SERVO_NUB_HEIGHT = 5;
SERVO_NUB_OFFSET = SERVO_LENGTH/2 - 6;

SERVO_MOUNT_HOLE_DIA = 2;
SERVO_MOUNT_HOLE_SPACING = 28;

SERVO_ARM_DIA1 = 7.5;
SERVO_ARM_DIA2 = 4;
SERVO_ARM_LENGTH = 22;
SERVO_ARM_THICKNESS = 4;
SERVO_ARM_FLAT_THICKNESS = 1.5;
SERVO_ARM_HEIGHT = SERVO_HEIGHT + SERVO_NUB_HEIGHT - SERVO_ARM_THICKNESS;

TOWER_SPACING = 0;

TOWER_MOUNT_WIDTH = SERVO_WIDTH;
TOWER_MOUNT_LENGTH = 2 * SERVO_ARM_LENGTH + 4;
TOWER_MOUNT_HEIGHT = SERVO_WIDTH + SERVO_ARM_THICKNESS + TOWER_SPACING;
TOWER_MOUNT_THICKNESS = SERVO_ARM_THICKNESS + TOWER_SPACING;
TOWER_MOUNT_CORNER_DIA = SERVO_ARM_DIA1;
TOWER_MOUNT_LIP = 1;

TOWER_LENGTH = 60;
TOWER_WIDTH = 80;
TOWER_BASE_THICKNESS = TOWER_SPACING + SERVO_ARM_THICKNESS;
TOWER_CORNER_DIA = 10;


$fn = 30;

module servo() {
  translate([0, SERVO_NUB_OFFSET, 0]) {
    translate([-SERVO_WIDTH/2, -SERVO_LENGTH/2, 0])
    cube(size = [SERVO_WIDTH, SERVO_LENGTH, SERVO_HEIGHT]);

    translate([-SERVO_WIDTH/2, -SERVO_TAB_LENGTH/2, SERVO_TAB_HEIGHT])
    cube(size = [SERVO_WIDTH, SERVO_TAB_LENGTH, SERVO_TAB_THICKNESS]);
    
    translate([0, -SERVO_NUB_OFFSET, 0])
    cylinder(d = SERVO_NUB_DIA, h = SERVO_HEIGHT + SERVO_NUB_HEIGHT);

    for(i = [-1, 1]) {
      translate([0, i * SERVO_MOUNT_HOLE_SPACING/2, 0])
      cylinder(d = SERVO_MOUNT_HOLE_DIA, h = SERVO_HEIGHT);
    }
  }
}

module servo_arm(sides = 1) {
  for(i = [1 : sides]) {
    rotate([0, 0, i * 360/sides])
    translate([0, 0, SERVO_ARM_THICKNESS - SERVO_ARM_FLAT_THICKNESS])
    hull() {
      cylinder(d = SERVO_ARM_DIA1, h = SERVO_ARM_FLAT_THICKNESS);
      translate([0, SERVO_ARM_LENGTH - SERVO_ARM_DIA1/2 - SERVO_ARM_DIA2/2, 0])
      cylinder(d = SERVO_ARM_DIA2, h = SERVO_ARM_FLAT_THICKNESS);
    }
    
    cylinder(d = SERVO_ARM_DIA1, h = SERVO_ARM_THICKNESS);
  }
}

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (length - corner_dia)/2, j * (width - corner_dia)/2, 0])
        cylinder(d = corner_dia, h = height);
      }
    }
  }
}

module servo_placement() {
  #translate([0, 0, TOWER_SPACING])
  rotate([0, 0, -90]) {
    translate([0, 0, -SERVO_ARM_HEIGHT])
    servo();
    servo_arm(1);
  }
  
  delta = -SERVO_ARM_LENGTH - 2 * TOWER_MOUNT_LIP;
  #translate([delta, -TOWER_SPACING + TOWER_MOUNT_THICKNESS/2, SERVO_WIDTH/2 + TOWER_MOUNT_THICKNESS + TOWER_SPACING])
  rotate([90, 90, 0]) {
    translate([0, 0, -SERVO_ARM_HEIGHT])
    servo();
    rotate([0, 0, -5.5])
    servo_arm(1);    
  }
}

module tower_mount() {
  difference() {
    translate([-TOWER_MOUNT_LENGTH/2 + SERVO_ARM_LENGTH - SERVO_ARM_DIA1/2 + TOWER_MOUNT_LIP, 0, 0])
    union() {
      rounded_rect(TOWER_MOUNT_WIDTH, TOWER_MOUNT_LENGTH, TOWER_MOUNT_THICKNESS, TOWER_MOUNT_CORNER_DIA);

      l = TOWER_MOUNT_LENGTH - SERVO_ARM_LENGTH - 2 * TOWER_MOUNT_LIP;
      rotate([90, 0, 0])
      translate([-TOWER_MOUNT_LENGTH/2 + l/2, TOWER_MOUNT_HEIGHT/2, -TOWER_MOUNT_THICKNESS/2])
      rounded_rect(TOWER_MOUNT_HEIGHT, l, TOWER_MOUNT_THICKNESS, TOWER_MOUNT_CORNER_DIA);

    }
    
    servo_placement();
  }
}

tower_mount();
