TRACKS = false;

SERVO_WIDTH = 12.5;
SERVO_LENGTH = 32.5;//23;
SERVO_OFFSET = 4;
SERVO_TAB_THICKNESS = 0;//2;
SERVO_MOUNT_HOLE_DIA = 1.5;
SERVO_MOUNT_HOLE_SPACING = 27;

WIDTH = 90;
LENGTH = 90;
THICKNESS = TRACKS ? 3 : 1.5;
HEIGHT = 22 + SERVO_TAB_THICKNESS + THICKNESS;

CORNER_DIA = 10;

TRACK_WIDTH = 15;
TRACK_THICKNESS = TRACKS ? 1.5 : 0;

THETHER_DIA = 10;
THETHER_OFFSET = -2;

SLOT_WIDTH = 3;
SLOT_LENGTH = 5;
SLOT_SPACING = 38;

SLOT_OFFSET = (HEIGHT-22)/2;

$fn = 30;


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

module thether() {
  rotate([90, 0, 0])
  cylinder(d = THETHER_DIA, h = HEIGHT, center = true);
}

module servo() {
  rotate([90, 0, 0]) {
    cube(size = [SERVO_LENGTH, SERVO_WIDTH, HEIGHT], center = true);
    translate([-SERVO_MOUNT_HOLE_SPACING/2, 0, 0])
    cylinder(d = SERVO_MOUNT_HOLE_DIA, h = HEIGHT, center = true);
    translate([SERVO_MOUNT_HOLE_SPACING/2, 0, 0])
    cylinder(d = SERVO_MOUNT_HOLE_DIA, h = HEIGHT, center = true);
  }
}

module slots() {
  rotate([90, 0, 90]) {
    for(i = [-1, 1]) {
      translate([0, i * SLOT_SPACING/2, 0])
      hull() {
        translate([-SLOT_LENGTH/2, 0, 0])
        cylinder(d = SLOT_WIDTH, h = THICKNESS * 2);
        translate([SLOT_LENGTH/2, 0, 0])
        cylinder(d = SLOT_WIDTH, h = THICKNESS * 2);
      }
    }
  }
}

module cover() {
  difference() {
    rounded_rect(HEIGHT, LENGTH, WIDTH, CORNER_DIA);

    translate([THICKNESS, THICKNESS, 0])
    rounded_rect(HEIGHT, LENGTH, WIDTH, CORNER_DIA);

    translate([0, TRACK_THICKNESS, 0])
    rounded_rect(HEIGHT, LENGTH, TRACK_WIDTH, CORNER_DIA);

    translate([0, TRACK_THICKNESS, WIDTH - TRACK_WIDTH])
    rounded_rect(HEIGHT, LENGTH, TRACK_WIDTH, CORNER_DIA);

    #translate([LENGTH/2 + THETHER_OFFSET, -HEIGHT/2, WIDTH/2])
    thether();

    #translate([SERVO_OFFSET, -HEIGHT/2, WIDTH/2])
    servo();

    #translate([-LENGTH/2, SLOT_OFFSET, WIDTH/2])
    slots();
  }
}

cover();
