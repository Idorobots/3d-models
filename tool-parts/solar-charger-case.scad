WIDTH = 62;
LENGTH = 125;
HEIGHT = 12;
CORNER_DIA = 3;
WALL_THICKNESS = 1;

CHARGER_WIDTH = 36;
CHARGER_LENGTH = 26;
CHARGER_THICKNESS = HEIGHT - 2 * WALL_THICKNESS;
CHARGER_OFFSET = 5;

CONNECTOR_WIDTH = 12;
CONNECTOR_LENGTH = 20;
CONNECTOR_THICKNESS = 10;
CONNECTOR_BASE_WIDTH = 6;
CONNECTOR_BASE_LENGTH = 5;
CONNECTOR_TAB_WIDTH = 1.5;

PSU_LENGTH = 21;
PSU_WIDTH = 51;
PSU_THICKNESS = HEIGHT - 2 * WALL_THICKNESS;

USB_THICKNESS = 8;
USB_WIDTH = 15;
USB_OFFSET_X = PSU_WIDTH/2 - 8;
USB_OFFSET_Z = 6;

MICRO_THICKNESS = 4;
MICRO_WIDTH = 9;
MICRO_OFFSET_X = PSU_WIDTH/2 - 8;
MICRO_OFFSET_Z = 3;

BATTERY_WIDTH = WIDTH - 2 * WALL_THICKNESS;
BATTERY_LENGTH = LENGTH - 4 * WALL_THICKNESS - CHARGER_LENGTH - PSU_LENGTH;
BATTERY_THICKNESS = HEIGHT - 2 * WALL_THICKNESS;
BATTERY_OFFSET = LENGTH/2 - BATTERY_LENGTH/2 - PSU_LENGTH - 2 * WALL_THICKNESS;

MOUNT_HOLE_DIA = 2.5;
MOUNT_HOLE_SPACING_X =  WIDTH - 2 * WALL_THICKNESS - MOUNT_HOLE_DIA;
MOUNT_HOLE_SPACING_Y_1 = LENGTH - 2 * WALL_THICKNESS - MOUNT_HOLE_DIA;
MOUNT_HOLE_SPACING_Y_2 = BATTERY_LENGTH + 2 * WALL_THICKNESS + MOUNT_HOLE_DIA;

WIRE_CHANNEL_DIA = 8;

$fn = 30;

module mount_holes(width, length, height, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

module rounded_rect(width, length, height, corner_dia) {
  hull()
  mount_holes(width - corner_dia, length - corner_dia, height, corner_dia);
}

module psu() {
  translate([-PSU_WIDTH/2, -PSU_LENGTH/2, 0])
  cube(size = [PSU_WIDTH, PSU_LENGTH, PSU_THICKNESS]);
  translate([-MICRO_WIDTH/2 + MICRO_OFFSET_X, PSU_LENGTH/2, -MICRO_THICKNESS/2 + PSU_THICKNESS - MICRO_OFFSET_Z])
  cube(size = [MICRO_WIDTH, 2 * WALL_THICKNESS, MICRO_THICKNESS]);

  translate([-USB_WIDTH/2 - USB_OFFSET_X, PSU_LENGTH/2, -USB_THICKNESS/2 + PSU_THICKNESS - USB_OFFSET_Z])
  cube(size = [USB_WIDTH, 2 * WALL_THICKNESS, USB_THICKNESS]);
}

module charger() {
  translate([-CHARGER_WIDTH/2, -CHARGER_LENGTH/2, 0])
  cube(size = [CHARGER_WIDTH, CHARGER_LENGTH, CHARGER_THICKNESS]);
}

module charger_connector() {
  difference() {
    translate([-CONNECTOR_WIDTH/2, -CONNECTOR_LENGTH/2, 0])
    cube(size = [CONNECTOR_WIDTH, CONNECTOR_LENGTH, CONNECTOR_THICKNESS]);

    #for(i = [-1, 1]) {
      translate([i * (CONNECTOR_BASE_WIDTH/2 + CONNECTOR_TAB_WIDTH/4) - CONNECTOR_TAB_WIDTH/2, -CONNECTOR_LENGTH/2, 0])
      cube(size = [CONNECTOR_TAB_WIDTH, CONNECTOR_BASE_LENGTH, CONNECTOR_THICKNESS]);
    }
  }
}

module battery() {
  translate([-BATTERY_WIDTH/2, -BATTERY_LENGTH/2, 0])
  cube(size = [BATTERY_WIDTH, BATTERY_LENGTH, BATTERY_THICKNESS]);
}

module wire_channel() {
  rotate([90, 0, 0])
  cylinder(d = WIRE_CHANNEL_DIA, h = 10, center = true);
}

module mounts() {
  mount_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y_1, HEIGHT, MOUNT_HOLE_DIA);
  translate([0, BATTERY_OFFSET, 0])
  mount_holes(MOUNT_HOLE_SPACING_X, MOUNT_HOLE_SPACING_Y_2, HEIGHT, MOUNT_HOLE_DIA);
}

module bottom() {
    difference() {
      rounded_rect(WIDTH, LENGTH, HEIGHT - WALL_THICKNESS, CORNER_DIA);

      #translate([0, (LENGTH - PSU_LENGTH)/2 - WALL_THICKNESS, 0])
      psu();

      #translate([-(WIDTH - CHARGER_WIDTH)/2 + WALL_THICKNESS + CHARGER_OFFSET, -(LENGTH - CHARGER_LENGTH)/2 + WALL_THICKNESS, 0])
      charger();

      #translate([(WIDTH - CONNECTOR_LENGTH)/2, -(LENGTH - CHARGER_LENGTH)/2 + WALL_THICKNESS, 0])
      rotate([0, 0, -90])
      charger_connector();

      #translate([0, BATTERY_OFFSET, 0])
      battery();

      #translate([0, 0, - 2 * WALL_THICKNESS])
      mounts();

      #translate([0, -BATTERY_LENGTH/2])
      wire_channel();
      #translate([-PSU_WIDTH/2.5, BATTERY_LENGTH/2])
      wire_channel();
      #translate([PSU_WIDTH/2.5, BATTERY_LENGTH/2])
      wire_channel();
    }
}

module top() {
    difference() {
      rounded_rect(WIDTH, LENGTH, WALL_THICKNESS, CORNER_DIA);
      #mounts();
    }
}

!bottom();
translate([0, 0, -20])
top();
