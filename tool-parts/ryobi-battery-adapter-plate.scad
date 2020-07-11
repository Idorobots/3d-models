RISER_WIDTH = 54;
RISER_LENGTH = 79;
RISER_HEIGHT = 3.5; // TODO

CONNECTOR_WIDTH = 47;
CONNECTOR_LENGTH = 37;
CONNECTOR_HEIGHT = 3.5;
CONNECTOR_OFFSET = 20.5;

BASE_WIDTH = 71;
BASE_LENGTH = 131;
BASE_HEIGHT = 3;
BASE_FRONT_DIA = 75;
BASE_FRONT_OFFSET = 0;
BASE_BACK_DIA = 77;
BASE_BACK_OFFSET = 65;
BASE_OFFSET = -28;

CHANNEL_WIDTH = 24;
CHANNEL_LENGTH = 24;
CHANNEL_HEIGHT = 50;
CHANNEL_OFFSET = 48;

TABS_WIDTH = 13;
TABS_LENGTH = 23;
TABS_HEIGHT = BASE_HEIGHT;
TABS_OFFSET = 33;

TOP_MOUNT_HOLES_DIA = 3;
TOP_MOUNT_HOLES_SPACING_X = 52.5;
TOP_MOUNT_HOLES_SPACING_Y = 40;
TOP_MOUNT_HOLES_HEIGHT = 23;
TOP_MOUNT_HOLES_OFFSET = 27;

BOTTOM_MOUNT_HOLES_DIA = 3;
BOTTOM_MOUNT_HOLES_SPACING_X_FRONT = 48;
BOTTOM_MOUNT_HOLES_SPACING_X_BACK = 11;
BOTTOM_MOUNT_HOLES_SPACING_Y = 120;
BOTTOM_MOUNT_HOLES_HEIGHT = 23;
BOTTOM_MOUNT_HOLES_OFFSET = -21;

SLOT_WIDTH = 10;
SLOT_LENGTH = 1;
SLOT_HEIGHT = 23;

$fn = 50;

module base() {
    intersection() {
        union() {
            translate([-BASE_WIDTH/2, 0, 0])
            cube(size = [BASE_WIDTH, RISER_LENGTH, BASE_HEIGHT]);
            translate([0, BASE_FRONT_OFFSET, 0])
            cylinder(d = BASE_FRONT_DIA, h = BASE_HEIGHT);
            translate([0, BASE_BACK_OFFSET, 0])
            cylinder(d = BASE_BACK_DIA, h = BASE_HEIGHT);
        }
        translate([-BASE_WIDTH/2, BASE_OFFSET, 0])
        cube(size = [BASE_WIDTH, BASE_LENGTH, BASE_HEIGHT]);
    }
}

module riser() {
  translate([-RISER_WIDTH/2, 0, 0])
      cube(size = [RISER_WIDTH, RISER_LENGTH, RISER_HEIGHT]);
}

module connector() {
  translate([-CONNECTOR_WIDTH/2, 0, 0])
      cube(size = [CONNECTOR_WIDTH, CONNECTOR_LENGTH, CONNECTOR_HEIGHT]);
}

module channel() {
  translate([-CHANNEL_WIDTH/2, 0, 0])
      cube(size = [CHANNEL_WIDTH, CHANNEL_LENGTH, CHANNEL_HEIGHT]);
}

module tabs() {
  translate([-TABS_WIDTH/2 - (BASE_WIDTH-TABS_WIDTH)/2, 0, 0])
      cube(size = [TABS_WIDTH, TABS_LENGTH, TABS_HEIGHT]);

  translate([-TABS_WIDTH/2 + (BASE_WIDTH-TABS_WIDTH)/2, 0, 0])
      cube(size = [TABS_WIDTH, TABS_LENGTH, TABS_HEIGHT]);
    
}

module top_holes() {
    translate([0, TOP_MOUNT_HOLES_SPACING_Y/2, 0])
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * TOP_MOUNT_HOLES_SPACING_X/2, j * TOP_MOUNT_HOLES_SPACING_Y/2, 0])
            cylinder(d = TOP_MOUNT_HOLES_DIA, h = TOP_MOUNT_HOLES_HEIGHT);
        }
    }
}

module bottom_holes() {
    translate([0, BOTTOM_MOUNT_HOLES_SPACING_Y/2, 0])
    union() {
        for(i = [-1, 1]) {
            translate([i * BOTTOM_MOUNT_HOLES_SPACING_X_FRONT/2, -BOTTOM_MOUNT_HOLES_SPACING_Y/2, 0])
            cylinder(d = BOTTOM_MOUNT_HOLES_DIA, h = BOTTOM_MOUNT_HOLES_HEIGHT);
        }

        for(i = [-1, 1]) {
            translate([i * BOTTOM_MOUNT_HOLES_SPACING_X_BACK/2, BOTTOM_MOUNT_HOLES_SPACING_Y/2, 0])
            cylinder(d = BOTTOM_MOUNT_HOLES_DIA, h = BOTTOM_MOUNT_HOLES_HEIGHT);
        }
    }    
}

module slot() {
    translate([-SLOT_WIDTH/2, -SLOT_LENGTH, 0])
    cube(size = [SLOT_WIDTH, SLOT_LENGTH, SLOT_HEIGHT]);
}

difference() {
  union() {
    base();
    translate([0, 0, BASE_HEIGHT])
    riser();
    translate([0, CONNECTOR_OFFSET, BASE_HEIGHT + RISER_HEIGHT])
    connector();
  }
  
  #translate([0, CHANNEL_OFFSET, 0])
  channel();
  
  #translate([0, TABS_OFFSET, 0])
  tabs();
  
  #translate([0, TOP_MOUNT_HOLES_OFFSET, 0])
  top_holes();

  #translate([0, BOTTOM_MOUNT_HOLES_OFFSET, 0])
  bottom_holes();
  
  #translate([0, CONNECTOR_OFFSET, 0])
  slot();

  #translate([0, CONNECTOR_OFFSET + CONNECTOR_LENGTH + SLOT_LENGTH, 0])
  slot();

  #slot();

  #translate([0, RISER_LENGTH + SLOT_LENGTH, 0])
  slot();
}