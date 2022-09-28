GEARBOX_WIDTH = 18;
GEARBOX_HEIGHT = 22;
GEARBOX_MOUNT_DIA = 2.5;
GEARBOX_MOUNT_SPACING = 17;
GEARBOX_MOUNT_OFFSET = 4;

FRAME_LENGTH = 58;
FRAME_MIDDLE_WIDTH = 20;
FRAME_AXLE_WIDTH = 19;
FRAME_WIDTH  = FRAME_MIDDLE_WIDTH + 2 * GEARBOX_WIDTH ;
FRAME_HEIGHT = GEARBOX_HEIGHT;

SLOT_WIDTH = 14;
SLOT_OFFSET = 8;
SLOT_LENGTH = FRAME_LENGTH - FRAME_AXLE_WIDTH - SLOT_OFFSET;

BEARING_DIA = 9.5;
BEARING_THICKNESS = 6;

WALL_THICKNESS = 3;
MIDDLE_CHANNEL_WIDTH = FRAME_MIDDLE_WIDTH - 2 * WALL_THICKNESS;
AXLE_CHANNEL_WIDTH = FRAME_AXLE_WIDTH - 2 * WALL_THICKNESS;

SERVO_WIDTH = 24;
SERVO_MOUNT_DIA = 1.5;
SERVO_MOUNT_SPACING = 27;
SERVO_MOUNT_OFFSET = 6.5;

THETHER_DIA = 10;

$fn = 30;

module gearbox_mount() {
  rotate([90, 0, 0])
  for(i = [-1, 1]) {
    translate([0, i * GEARBOX_MOUNT_SPACING/2, 0])
    cylinder(d = GEARBOX_MOUNT_DIA, h = FRAME_MIDDLE_WIDTH, center = true);
  }
}

module frame() {
   union() {
    translate([0, -FRAME_MIDDLE_WIDTH/2, 0])
    cube(size = [FRAME_LENGTH, FRAME_MIDDLE_WIDTH, FRAME_HEIGHT]);

    translate([0, -FRAME_WIDTH/2, 0])
    cube(size = [FRAME_AXLE_WIDTH, FRAME_WIDTH, FRAME_HEIGHT]);
  }
}

module axle_mount() {
  l = FRAME_WIDTH - 2 * BEARING_THICKNESS;
  rotate([90, 0, 0]) {
    cylinder(d = BEARING_DIA, h = FRAME_WIDTH, center = true);
    cylinder(d = AXLE_CHANNEL_WIDTH, h = l, center = true);
  }
  translate([0, 0, WALL_THICKNESS])
  cube(size = [AXLE_CHANNEL_WIDTH, l, FRAME_HEIGHT], center = true);
}

module middle_channel() {
  translate([WALL_THICKNESS, 0, FRAME_HEIGHT/2])
  rotate([0, 90, 0])
  cylinder(d = MIDDLE_CHANNEL_WIDTH, h = FRAME_LENGTH - FRAME_AXLE_WIDTH - WALL_THICKNESS, center = true);
}

module slot() {
  cube(size = [SLOT_LENGTH, FRAME_MIDDLE_WIDTH, SLOT_WIDTH], center = true);
}

module servo_mount() {
  for(i = [-1, 1]) {
    translate([i * SERVO_MOUNT_SPACING/2, 0, 0])
    cylinder(d = SERVO_MOUNT_DIA, h = FRAME_HEIGHT, center = true);
  }

  cube(size = [SERVO_WIDTH, MIDDLE_CHANNEL_WIDTH, FRAME_HEIGHT], center = true);
}

module thether() {
  rotate([0, 90, 0])
  cylinder(d = THETHER_DIA, h = WALL_THICKNESS * 2, center = true);
}

module front_axle() {
  difference() {
    frame();

    #translate([FRAME_LENGTH - GEARBOX_MOUNT_OFFSET, 0, FRAME_HEIGHT/2])
    gearbox_mount();

    #translate([FRAME_AXLE_WIDTH/2, 0, FRAME_HEIGHT/2])
    axle_mount();

    #translate([FRAME_AXLE_WIDTH, 0, 0])
    middle_channel();

    #translate([FRAME_LENGTH - SLOT_OFFSET - SLOT_LENGTH/2, 0, FRAME_HEIGHT/2])
    slot();

    #translate([FRAME_LENGTH - SERVO_MOUNT_SPACING/2 - SERVO_MOUNT_OFFSET, 0, FRAME_HEIGHT])
    servo_mount();

    #translate([0, 0, FRAME_HEIGHT])
    thether();
  }
}

front_axle();
