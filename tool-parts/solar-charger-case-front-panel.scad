OUTER_WIDTH = 75;
OUTER_HEIGHT = 12.5;

INNER_WIDTH = 72.5;
INNER_HEIGHT = 10;

INSIDE_THICKNESS = 10;
PANEL_THICKNESS = 3;
WALL_THICKNESS = 1;

CORNER_DIA = 10;

MOUNT_HOLE_HEIGHT = 8.5;
MOUNT_HOLE_DIA = 1;

PSU_LENGTH = 21;
PSU_WIDTH = 51;
PSU_THICKNESS = INNER_HEIGHT - 2 * WALL_THICKNESS;

USB_THICKNESS = 6;
USB_WIDTH = 13;
USB_OFFSET_X = PSU_WIDTH/2 - 8.5;
USB_OFFSET_Z = 5;

MICRO_THICKNESS = 3;
MICRO_WIDTH = 8;
MICRO_OFFSET_X = PSU_WIDTH/2 - 8;
MICRO_OFFSET_Z = 3;

LED_HOLE_DIA = 2;
LED_HOLE_OFFSET_X = 31.5 - PSU_WIDTH/2;
LED_HOLE_OFFSET_Z = PSU_THICKNESS/2;

PANEL_OFFSET_Z = WALL_THICKNESS;
PANEL_OFFSET_Y = -6;

CONNECTOR_WIDTH = 9;
CONNECTOR_HEIGHT = 5;
CONNECTOR_OFFSET = 25;

$fn = 50;

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

module mount_holes() {
  translate([0, 0, MOUNT_HOLE_HEIGHT])
  rotate([90, 0, 0])
  cylinder(d = MOUNT_HOLE_DIA, h = OUTER_WIDTH, center = true);
}

module psu() {
  translate([-PSU_WIDTH/2, -PSU_LENGTH/2, 0])
  cube(size = [PSU_WIDTH, PSU_LENGTH, PSU_THICKNESS]);
  translate([-MICRO_WIDTH/2 + MICRO_OFFSET_X, PSU_LENGTH/2, -MICRO_THICKNESS/2 + PSU_THICKNESS - MICRO_OFFSET_Z])
  cube(size = [MICRO_WIDTH, PANEL_THICKNESS, MICRO_THICKNESS]);

  translate([-USB_WIDTH/2 - USB_OFFSET_X, PSU_LENGTH/2, -USB_THICKNESS/2 + PSU_THICKNESS - USB_OFFSET_Z])
  cube(size = [USB_WIDTH, PANEL_THICKNESS, USB_THICKNESS]);

  translate([LED_HOLE_OFFSET_X, 0, LED_HOLE_OFFSET_Z])
  rotate([90, 0, 0])
  cylinder(d = LED_HOLE_DIA, h = PSU_LENGTH + 2 * PANEL_THICKNESS, center = true);
}

module solar_connector() {
  translate([-CONNECTOR_HEIGHT/2, -CONNECTOR_WIDTH/2, 0])
  cube(size = [CONNECTOR_HEIGHT, CONNECTOR_WIDTH, INNER_HEIGHT]);
}

module panel() {
  difference() {
    union() {
      rounded_rect(OUTER_HEIGHT, OUTER_WIDTH, PANEL_THICKNESS, CORNER_DIA);
      rounded_rect(INNER_HEIGHT, INNER_WIDTH, INSIDE_THICKNESS, CORNER_DIA);
    }

    wt = 2 * WALL_THICKNESS;
    #translate([0, 0, PANEL_THICKNESS])
    rounded_rect(INNER_HEIGHT - wt, INNER_WIDTH - wt, INSIDE_THICKNESS, CORNER_DIA - wt);

    #mount_holes();

    #translate([PSU_THICKNESS/2, PANEL_OFFSET_Y, PSU_LENGTH/2 + PANEL_OFFSET_Z])
    rotate([-90, 0, 90])
    psu();

    #translate([0, CONNECTOR_OFFSET, 0])
    solar_connector();
  }
}

panel();
