MOUNT_HOLE_SPACING = 36;
MOUNT_HOLE_DIA = 2;
MOUNT_HOLE_HEAD_DIA = 5;
MOUNT_HOLE_OFFSET_X = 25;
MOUNT_HOLE_OFFSET_Y = 0;

FAN_DIA = 38;
FAN_HOLE_DIA = 3.5;
FAN_HOLE_SPACING = 32;
FAN_HOLE_HEAD_DIA = 8;

STRAIN_RELIEF_WIDTH = 10;
STRAIN_RELIEF_LENGTH = 65;
STRAIN_RELIEF_DIA = 5;
STRAIN_RELIEF_HOLE_DIA = 2;

THICKNESS = 2;

BOTTOM = true;

$fn = 50;

module body() {
  hull() {
    for(i = [-1, 1]) {
      translate([0, i * FAN_HOLE_SPACING/2, 0])
      cylinder(d = FAN_HOLE_HEAD_DIA, h = THICKNESS);

      if(BOTTOM) {
        translate([-FAN_HOLE_SPACING, i * FAN_HOLE_SPACING/2, 0])
        cylinder(d = FAN_HOLE_HEAD_DIA, h = THICKNESS);
      }

      translate([MOUNT_HOLE_OFFSET_X, MOUNT_HOLE_OFFSET_Y + i * MOUNT_HOLE_SPACING/2, 0])
      cylinder(d = MOUNT_HOLE_HEAD_DIA, h = THICKNESS);

      translate([STRAIN_RELIEF_LENGTH, i * STRAIN_RELIEF_WIDTH/2, 0])
      cylinder(d = STRAIN_RELIEF_DIA, h = THICKNESS);
    }
  }
}

module holes() {
  for(i = [-1, 1]) {
    translate([0, i * FAN_HOLE_SPACING/2, 0])
    cylinder(d = FAN_HOLE_DIA, h = THICKNESS);

    translate([-FAN_HOLE_SPACING, i * FAN_HOLE_SPACING/2, 0])
    cylinder(d = FAN_HOLE_DIA, h = THICKNESS);

    translate([MOUNT_HOLE_OFFSET_X, MOUNT_HOLE_OFFSET_Y + i * MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);

    translate([STRAIN_RELIEF_LENGTH, i * STRAIN_RELIEF_WIDTH/2, 0])
    cylinder(d = STRAIN_RELIEF_HOLE_DIA, h = THICKNESS);
  }
  translate([-FAN_HOLE_SPACING/2, 0, 0])
  cylinder(d = FAN_DIA, h = THICKNESS);
}

difference() {
  body();
  #holes();
}
