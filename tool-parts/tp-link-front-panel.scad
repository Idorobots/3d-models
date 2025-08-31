PANEL_WIDTH = 18;
PANEL_LENGTH = 108;
PANEL_HOLE_DIA = 3.5;
PANEL_HOLE_SPACING_X = 10;
PANEL_HOLE_SPACING_Y = 91;
PANEL_HOLE_OFFSET_X = -1;
PANEL_HOLE_OFFSET_Y = -5.5;
PANEL_HOLE_HEIGHT = 7;
PANEL_THICKNESS = 2;

PORT_WIDTH = 15;
PORT_LENGTH = 25;
PORT_THICKNESS = 7;
PORT_OFFSET_X = -5;
PORT_OFFSET_Y = 47;
PORT_OFFSET_Z = -PORT_THICKNESS;

LEDS_NUM = 14;
LEDS_SPACING_X = 9;
LEDS_SPACING_Y = 7;
LEDS_OFFSET_X = 6;
LEDS_OFFSET_Y = 10;
LED_HEIGHT = 10;
LED_DIA = 3;

CASE_WIDTH = 30;
CASE_LENGTH = 115;
CASE_THICKNESS = 8;
CASE_CORNER_DIA = 1;

COVER_WIDTH = CASE_WIDTH;
COVER_LENGTH = CASE_LENGTH;
COVER_THICKNESS = 2.5;
COVER_CORNER_DIA = CASE_CORNER_DIA;

COVER_HOLE_DIA = 5;
COVER_HOLE_SPACING_X = 16;
COVER_HOLE_SPACING_Y = 49;
COVER_HOLE_HEIGHT = 5;

PANEL_OFFSET_X = -1;
PANEL_OFFSET_Y = 0;
PANEL_OFFSET_Z = 5;

MOUNT_HOLE_DIA = 3;
MOUNT_HOLE_HEIGHT = 5;
MOUNT_HOLE_SPACING_X = 24;
MOUNT_HOLE_SPACING_Y = 105;

$fn = 50;

module mounting_holes(width, length, height, dia, odd = true) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      if(odd || i == j) {
        translate([i * width/2, j * length/2, 0])
        cylinder(d = dia, h = height);
      }
    }
  }
}

module panel() {
  difference() {
    translate([-PANEL_WIDTH/2, -PANEL_LENGTH/2, 0])
    cube(size = [PANEL_WIDTH, PANEL_LENGTH, PANEL_THICKNESS]);

  translate([PANEL_HOLE_OFFSET_X, PANEL_HOLE_OFFSET_Y, 0])
    mounting_holes(PANEL_HOLE_SPACING_X, PANEL_HOLE_SPACING_Y, PANEL_HOLE_HEIGHT, PANEL_HOLE_DIA, false);
  }

  translate([PORT_OFFSET_X, PORT_OFFSET_Y, PORT_OFFSET_Z])
  translate([-PORT_WIDTH/2, -PORT_LENGTH/2, 0])
  cube(size = [PORT_WIDTH, PORT_LENGTH, PORT_THICKNESS]);

  #for(i = [0:LEDS_NUM-1]) {
    translate([LEDS_OFFSET_X, LEDS_OFFSET_Y, 0])
    translate([-PANEL_WIDTH/2, -PANEL_LENGTH/2, 0])
    translate([0, i * LEDS_SPACING_Y, 0]) {
      cylinder(d = LED_DIA, h = LED_HEIGHT);
      translate([LEDS_SPACING_X, 0, 0])
      cylinder(d = LED_DIA, h = LED_HEIGHT);
    }
  }
}

module case() {
  hull() {
    mounting_holes(CASE_WIDTH - CASE_CORNER_DIA, CASE_LENGTH - CASE_CORNER_DIA, CASE_THICKNESS, CASE_CORNER_DIA);
  }
}

module cover() {
  hull() {
    mounting_holes(COVER_WIDTH - COVER_CORNER_DIA, COVER_LENGTH - COVER_CORNER_DIA, COVER_THICKNESS, COVER_CORNER_DIA);
  }
}

// CASE
difference() {
  case();
  #translate([PANEL_OFFSET_X, PANEL_OFFSET_Y, PANEL_OFFSET_Z])
  panel();

  #translate([PANEL_OFFSET_X, PANEL_OFFSET_Y, 0])
  translate([-PANEL_WIDTH/2, -PANEL_LENGTH/2, 0])
  cube(size = [PANEL_WIDTH, PANEL_LENGTH, PANEL_OFFSET_Z]);

  #mounting_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, MOUNT_HOLE_HEIGHT, MOUNT_HOLE_DIA);
}

// COVER
!difference() {
  translate([0, 0, -COVER_THICKNESS])
  cover();
  #translate([PANEL_OFFSET_X, PANEL_OFFSET_Y, PANEL_OFFSET_Z])
  panel();

  #translate([0, 0, -COVER_THICKNESS]) {
    mounting_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y, MOUNT_HOLE_HEIGHT, MOUNT_HOLE_DIA);

    mounting_holes(COVER_HOLE_SPACING_X, COVER_HOLE_SPACING_Y, COVER_HOLE_HEIGHT, COVER_HOLE_DIA);
  }
}
