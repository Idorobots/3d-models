WIDTH = 42;
SPACING = 50;
SLOT_LENGTH = 10;
LENGTH = SPACING + WIDTH + SLOT_LENGTH;
THICKNESS = 5;
CORNER_DIA = 5;

MOTOR_HOLE_SPACING = 31;
MOTOR_HOLE_DIA = 3;
MOTOR_SHAFT_DIA = 23;
MOTOR_SLOT_LENGTH = SLOT_LENGTH;

OUT_HOLE_SPACING = MOTOR_HOLE_SPACING;
OUT_HOLE_DIA = MOTOR_HOLE_DIA;
OUT_SHAFT_DIA = 6;
OUT_BEARING_DIA = 13.2;
OUT_BEARING_AT = 3;
OUT_BEARING_THICKNESS = 8;
OUT_BEARING_HOUSING_DIA = MOTOR_SHAFT_DIA;

IDLER_SLOT_LENGTH = 5;
IDLER_SLOT_DIA = 3;
IDLER_SLOT_OFFSET = MOTOR_HOLE_SPACING/2 - IDLER_SLOT_LENGTH/2;

$fn = 50;

module mount_holes(width, length, thickness, dia, slot_length) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      hull() {
        translate([0, -slot_length/2, 0])
        cylinder(d = dia, h = thickness);
        translate([0, slot_length/2, 0])
        cylinder(d = dia, h = thickness);
      }
    }
  }
}

module rounded_rect(width, length, thickness, corner_dia) {
  hull() {
    mount_holes(width - corner_dia, length - corner_dia, thickness, corner_dia, 0);
  }
}

module reductor() {
  difference() {
    union() {
      translate([0, -SLOT_LENGTH/2, 0])
      rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);
      translate([0, SPACING/2, 0])
      cylinder(d = OUT_BEARING_HOUSING_DIA, h = OUT_BEARING_THICKNESS + OUT_BEARING_AT);
    }
    translate([0, -(SPACING + SLOT_LENGTH)/2, 0]) {
      mount_holes(MOTOR_HOLE_SPACING, MOTOR_HOLE_SPACING, THICKNESS, MOTOR_HOLE_DIA, MOTOR_SLOT_LENGTH);
      mount_holes(0, 0, THICKNESS, MOTOR_SHAFT_DIA, MOTOR_SLOT_LENGTH);
    }
    translate([0, SPACING/2, 0]) {
      mount_holes(OUT_HOLE_SPACING, OUT_HOLE_SPACING, THICKNESS, OUT_HOLE_DIA, 0);
      cylinder(d = OUT_SHAFT_DIA, h = THICKNESS);
      translate([0, 0, OUT_BEARING_AT])
      cylinder(d = OUT_BEARING_DIA, h = OUT_BEARING_THICKNESS);
    }
    translate([IDLER_SLOT_OFFSET, 0, 0])
    hull() {
      mount_holes(IDLER_SLOT_LENGTH, 0, THICKNESS, IDLER_SLOT_DIA, 0);
    }
  }
}

reductor();
