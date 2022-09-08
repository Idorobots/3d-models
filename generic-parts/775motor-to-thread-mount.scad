MOUNT_DIA = 25;
MOUNT_HEIGHT = 20;
MOUNT_HOLE_DIA = 14;

MOTOR_DIA = 35;
MOTOR_SHAFT_DIA = MOUNT_HOLE_DIA;
MOTOR_PLATE_THICKNESS = 5;

MOTOR_HOLES_DIA = 3.5;
MOTOR_HOLES_HEAD_DIA = 5.5;
MOTOR_HOLES_SPACING = 21;

THREAD_DIA = MOUNT_HOLE_DIA;
THREAD_PITCH = 1.5;
THREAD_HEIGHT = MOUNT_HEIGHT;

INCLUDE_THREAD = true;

$fn = 50;

use <thread.scad>;

module adapter() {
  difference() {
    cylinder(d = MOUNT_DIA, h = MOUNT_HEIGHT, $fn = 6);
    cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HEIGHT);
    
    translate([0, -MOTOR_HOLES_SPACING/2, 0])
    cylinder(d = MOTOR_HOLES_HEAD_DIA, h = MOUNT_HEIGHT);
    
    translate([0, MOTOR_HOLES_SPACING/2, 0])
    cylinder(d = MOTOR_HOLES_HEAD_DIA, h = MOUNT_HEIGHT);
  }
  
  translate([0, 0, MOUNT_HEIGHT])
  difference() {
    cylinder(d = MOTOR_DIA, h = MOTOR_PLATE_THICKNESS);
    
    cylinder(d = MOTOR_SHAFT_DIA, h = MOTOR_PLATE_THICKNESS);
    
    translate([0, -MOTOR_HOLES_SPACING/2, 0])
    cylinder(d = MOTOR_HOLES_DIA, h = MOTOR_PLATE_THICKNESS);
    
    translate([0, MOTOR_HOLES_SPACING/2, 0])
    cylinder(d = MOTOR_HOLES_DIA, h = MOTOR_PLATE_THICKNESS);
  }

  if(INCLUDE_THREAD) {
    thread(THREAD_DIA, THREAD_HEIGHT, THREAD_PITCH);
  }
}

adapter();