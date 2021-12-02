PLATE_DIA = 200;
WIDTH = 150;//70;
HEIGHT = 25;//50;

THICKNESS = 1.2;
WALL_THICKNESS = 2;

MOTOR_MOUNT_SPACING = 55;
MOTOR_MOUNT_DIA = 4;
MOTOR_SHAFT_DIA = 15;
MOTOR_SHAFT_OFFSET = 20;

LED_DRIVER_MOUNT_DIA = 4;
LED_DRIVER_MOUNT_SPACING_X = 110;
LED_DRIVER_MOUNT_SPACING_Y = 26;
LED_DRIVER_MOUNT_OFFSET = 50;

LED_ARM_WIDTH = 70;
LED_ARM_MOUNT_SPACING = 55;
LED_ARM_MOUNT_LENGTH = 2;
LED_ARM_MOUNT_DIA = 15;
LED_ARM_MOUNT_HOLE_DIA = 4;
LED_ARM_CHANNEL_DIA = 5;

POWER_BLOCK_MOUNT_SPACING = 30;
POWER_BLOCK_MOUNT_DIA = 4;
POWER_BLOCK_MOUNT_OFFSET = -70;

POWER_PORT_DIA = 20;

$fn = 100;

module motor_mount_holes() {
  #union() {
    cylinder(d = MOTOR_SHAFT_DIA, h = HEIGHT, center = true);
    for(i = [-1, 1]) {
      translate([-MOTOR_SHAFT_OFFSET, i * MOTOR_MOUNT_SPACING/2, 0])
      cylinder(d = MOTOR_MOUNT_DIA, h = HEIGHT, center = true);
    }
  }
}

module led_arm_mount() {
  rotate([0, 90, 0])
  difference() {
    union() {
      for(i = [-1, 1]) {
        translate([0, i * LED_ARM_MOUNT_SPACING/2, LED_ARM_MOUNT_LENGTH - PLATE_DIA/2])
        cylinder(d = LED_ARM_MOUNT_DIA, h = PLATE_DIA/2);
      }
    }
    
    translate([0, 0, -PLATE_DIA/2])
    rotate([0, 90, 0])
    cylinder(d = PLATE_DIA, h = WIDTH, center = true);
  }
}

module led_arm_mount_holes() {
  #rotate([0, 90, 0])
  translate([0, 0, -PLATE_DIA/4])
  union() {
    for(i = [-1, 1]) {
      translate([0, i * LED_ARM_MOUNT_SPACING/2, 0])
      cylinder(d = LED_ARM_MOUNT_HOLE_DIA, h = PLATE_DIA/2);
    }

    cylinder(d = LED_ARM_CHANNEL_DIA, h = PLATE_DIA/2);
  }
}

module led_driver_mount() {
  #union() {
    for(i = [-1, 1]) {
      translate([i * LED_DRIVER_MOUNT_SPACING_X/2, i*LED_DRIVER_MOUNT_SPACING_Y/2, 0])
      cylinder(d = LED_DRIVER_MOUNT_DIA, h = HEIGHT, center = true);
    }
  }
}

module power_port() {
  #rotate([0, 90, 0])
  cylinder(d = POWER_PORT_DIA, h = PLATE_DIA/2, center = true);
}

module power_block_mount() {
  #union() {
    for(i = [-1, 1]) {
      translate([0, i * POWER_BLOCK_MOUNT_SPACING/2, 0])
      cylinder(d = POWER_BLOCK_MOUNT_DIA, h = HEIGHT, center = true);
    }
  }
}

module chopped_cylinder(dia, width, height) {
  intersection() {
    cylinder(d = dia, h = height);
    cube(size = [dia, width, 2 * height], center = true);
  }
}

module base() {
  difference() {
    wt = 2 * WALL_THICKNESS;
    chopped_cylinder(PLATE_DIA, WIDTH, HEIGHT);
    translate([0, 0, -THICKNESS])
    chopped_cylinder(PLATE_DIA - wt, WIDTH - wt, HEIGHT);
  }
}

difference() {
  union() {
    base();
    translate([PLATE_DIA/2, 0, HEIGHT - LED_ARM_MOUNT_DIA/2])
    led_arm_mount();
  }
  translate([0, 0, HEIGHT])
  motor_mount_holes();
  
  translate([0, LED_DRIVER_MOUNT_OFFSET, HEIGHT])
  led_driver_mount();
  
  translate([PLATE_DIA/2, 0, HEIGHT - LED_ARM_MOUNT_DIA/2])
  led_arm_mount_holes();
  
  translate([-PLATE_DIA/2, 0, HEIGHT/2])
  power_port();
  
  translate([POWER_BLOCK_MOUNT_OFFSET, 0, HEIGHT])
  power_block_mount();
}