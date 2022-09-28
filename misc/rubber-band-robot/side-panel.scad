LENGTH = 86;
WIDTH = 22.5;
THICKNESS = 1.5;
CORNER_DIA = 10;

WHEEL_SPACING = 66;
WHEEL_HOLE_DIA = 15;

MOUNT_HOLE_DIA = 3.5;
MOUNT_HOLE_SPACING = 17;
MOUNT_HOLE_OFFSET = 12;

SLOT_LENGTH = 6;
SLOT_WIDTH = 4;
SLOT_OFFSET = 0;

HOLE_OFFSET = 21;
HOLE_DIA = 4.5;

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

module panel() {
  difference() {
    rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);

    // Wheels
    translate([-WHEEL_SPACING/2, 0, 0])
    cylinder(d = WHEEL_HOLE_DIA, h = THICKNESS);
    translate([WHEEL_SPACING/2, 0, 0])
    cylinder(d = WHEEL_HOLE_DIA, h = THICKNESS);

    // Mount holes
    translate([MOUNT_HOLE_OFFSET, -MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
    translate([MOUNT_HOLE_OFFSET, MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);

    // Motor tab slot
    hull() {
      translate([SLOT_OFFSET, -SLOT_LENGTH/2, 0])
      cylinder(d = SLOT_WIDTH, h = THICKNESS);
      translate([SLOT_OFFSET, SLOT_LENGTH/2, 0])
      cylinder(d = SLOT_WIDTH, h = THICKNESS);
    }

    // Gearbox nub hole
    translate([HOLE_OFFSET, 0, 0])
    cylinder(d = HOLE_DIA, h = THICKNESS);
  }
}

panel();
