WIDTH = 12;
LENGTH = 22;
HEIGHT = 12;
CORNER_DIA = 8;

CAVITY_WIDTH = 9.5;
CAVITY_LENGTH = 19;
CAVITY_HEIGHT = 7;

KEY_DIA_TOP = 12;
KEY_DIA_BOT = 9;
KEY_DEPTH = 2;

PIN_SPACING = 12;
PIN_OFFSET = -3;
PIN_DIA_TOP = 1.5;
PIN_DIA_BOT = 2;
PIN_HEIGHT_BOT = HEIGHT - 0.5;
PIN_HEIGHT_TOP = 2;

MAGNET_SPACING = 5;
MAGNET_DIA = 3.2;
MAGNET_OFFSET = -3;
MAGNET_HEIGHT = HEIGHT - 0.5;

USB_WIDTH = 3;
USB_LENGTH = 9;
USB_DEPTH = 16;
USB_OFFSET = 9.5;

$fn = 100;

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2, 0])
        cylinder(d = corner_dia, h = height);
      }
    }
  }
}

module key() {
  cylinder(d = KEY_DIA_TOP, h = KEY_DEPTH/2);
  translate([0, 0, KEY_DEPTH/2])
  cylinder(d1 = KEY_DIA_TOP, d2 = KEY_DIA_BOT, h = KEY_DEPTH/2);
}

module pin() {
  cylinder(d = PIN_DIA_TOP, h = PIN_HEIGHT_TOP);
  translate([0, 0, PIN_HEIGHT_TOP])
  cylinder(d = PIN_DIA_BOT, h = PIN_HEIGHT_BOT);
}

module usb() {
  rotate([90, 90, 0])
  rounded_rect(USB_WIDTH, USB_LENGTH, USB_DEPTH, USB_WIDTH);
}

module cavity() {
  rounded_rect(CAVITY_WIDTH, CAVITY_LENGTH, CAVITY_HEIGHT, CORNER_DIA);
}

difference() {
  rounded_rect(WIDTH, LENGTH, HEIGHT, CORNER_DIA);

  #translate([WIDTH/2, 0, 0])
  key();

  #for(i = [-1, 1]) {
    translate([PIN_OFFSET, i * PIN_SPACING/2, HEIGHT - PIN_HEIGHT_BOT - PIN_HEIGHT_TOP])
    pin();

    translate([MAGNET_OFFSET, i * MAGNET_SPACING/2, HEIGHT - MAGNET_HEIGHT])
    cylinder(d = MAGNET_DIA, h = MAGNET_HEIGHT);
  }

  #translate([0, LENGTH/2, USB_OFFSET])
  usb();

  #translate([0, 0, HEIGHT - CAVITY_HEIGHT])
  cavity();
}
