MOUNT_HOLE_SPACING = 36;
MOUNT_HOLE_DIA = 2;
MOUNT_HOLE_HEAD_DIA = 5;
MOUNT_HOLE_OFFSET_X = 10;
MOUNT_HOLE_OFFSET_Y = 2;

THICKNESS = 2;

MOTOR_HOLE_SPACING = 45;
MOTOR_HOLE_DIA = 3;
MOTOR_HOLE_HEAD_DIA = 6;
MOTOR_HOLE_ANGLE = -45;

MOTOR_DIA = 36;

$fn = 50;

module body() {
  rotate([0, 0, MOTOR_HOLE_ANGLE])
  hull() {
    for(i = [-1, 1]) {
      translate([i * MOTOR_HOLE_SPACING/2, 0, 0,])
      cylinder(d = MOTOR_HOLE_HEAD_DIA, h = THICKNESS);

      cylinder(d = MOTOR_DIA, h = THICKNESS);
    }
  }
  hull() {
    for(i = [-1, 1]) {
      translate([MOUNT_HOLE_OFFSET_X, i * MOUNT_HOLE_SPACING/2 + MOUNT_HOLE_OFFSET_Y, 0,])
      cylinder(d = MOUNT_HOLE_HEAD_DIA, h = THICKNESS);

      cylinder(d = MOTOR_DIA, h = THICKNESS);
    }
  }
}
module holes() {
  rotate([0, 0, MOTOR_HOLE_ANGLE])
  for(i = [-1, 1]) {
    translate([i * MOTOR_HOLE_SPACING/2, 0, 0,])
    cylinder(d = MOTOR_HOLE_DIA, h = THICKNESS);
  }
  for(i = [-1, 1]) {
    translate([MOUNT_HOLE_OFFSET_X, i * MOUNT_HOLE_SPACING/2 + MOUNT_HOLE_OFFSET_Y, 0,])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
  }
}
difference() {
  body();
  #holes();
}
