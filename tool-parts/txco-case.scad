TXCO_WIDTH = 72;
TXCO_LENGTH = 91;
TXCO_HEIGHT = 25;

TXCO_OFFSET_Z = 5;
TXCO_BOARD_THICKNESS = 2.5;

TXCO_MOUNT_HOLE_SPACING_X = 65;
TXCO_MOUNT_HOLE_SPACING_Y = 83;
TXCO_MOUNT_HOLE_DIA = 3;
TXCO_MOUNT_HOLE_STANDOFF_DIA = 8;

TXCO_PORT_DIA = 7;
TXCO_PORT_SPACING = TXCO_WIDTH - 2 * 13.5;
TXCO_PORT_OFFSET_Z = 1.5;

TXCO_LED_DIA = 5;
TXCO_LED_OFFSET_X = 47.5;
TXCO_LED_OFFSET_Y = 16;

WALL_THICKNESS = 2;
WIDTH = TXCO_WIDTH + 2 * WALL_THICKNESS;
LENGTH = TXCO_LENGTH + 2 * WALL_THICKNESS;
HEIGHT = TXCO_HEIGHT + 2 * WALL_THICKNESS + TXCO_OFFSET_Z;
CORNER_DIA = 5;

$fn = 50;

module txco() {
  translate([-TXCO_WIDTH/2, -TXCO_LENGTH/2, 0])
  cube(size = [TXCO_WIDTH, TXCO_LENGTH, TXCO_HEIGHT]);

  translate([-TXCO_WIDTH/2, -TXCO_LENGTH/2, -TXCO_OFFSET_Z])
  cube(size = [TXCO_WIDTH, TXCO_LENGTH, TXCO_OFFSET_Z]);

  translate([TXCO_LED_OFFSET_X - TXCO_WIDTH/2, TXCO_LED_OFFSET_Y - TXCO_LENGTH/2, TXCO_HEIGHT])
  cylinder(d = TXCO_LED_DIA, h = WALL_THICKNESS * 2);

  for(i = [-1, 1]) {
    translate([i * TXCO_PORT_SPACING/2, TXCO_LENGTH/2, TXCO_PORT_OFFSET_Z])
    rotate([-90, 0, 0])
    cylinder(d = TXCO_PORT_DIA, h = WALL_THICKNESS * 2);
  }
}

module mount_holes(width, length, height, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

module internals() {
  union() {
    difference() {
      txco();

      translate([0, 0, -TXCO_OFFSET_Z])
      mount_holes(TXCO_MOUNT_HOLE_SPACING_X, TXCO_MOUNT_HOLE_SPACING_Y, TXCO_OFFSET_Z, TXCO_MOUNT_HOLE_STANDOFF_DIA);

      translate([0, 0, TXCO_BOARD_THICKNESS])
      mount_holes(TXCO_MOUNT_HOLE_SPACING_X, TXCO_MOUNT_HOLE_SPACING_Y, TXCO_HEIGHT, TXCO_MOUNT_HOLE_STANDOFF_DIA);
    }
    translate([0, 0, -TXCO_OFFSET_Z - WALL_THICKNESS])
    mount_holes(TXCO_MOUNT_HOLE_SPACING_X, TXCO_MOUNT_HOLE_SPACING_Y, TXCO_HEIGHT + TXCO_OFFSET_Z + WALL_THICKNESS, TXCO_MOUNT_HOLE_DIA);
  }
}

module case() {
  difference() {
    translate([0, 0, -TXCO_OFFSET_Z - WALL_THICKNESS])
    hull()
    mount_holes(WIDTH - 2*WALL_THICKNESS, LENGTH - 2*WALL_THICKNESS, HEIGHT, CORNER_DIA);

    #internals();
  }
}

// Top
!difference() {
  case();
  translate([-TXCO_WIDTH/2, -TXCO_LENGTH/2, -HEIGHT])
  cube(size = [TXCO_WIDTH, TXCO_LENGTH, HEIGHT]);
}

// Bottom
intersection() {
  case();
  translate([-TXCO_WIDTH/2, -TXCO_LENGTH/2, -HEIGHT])
  cube(size = [TXCO_WIDTH, TXCO_LENGTH, HEIGHT]);
}
