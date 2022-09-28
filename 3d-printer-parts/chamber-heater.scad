HEATER_LENGTH = 115;
HEATER_WIDTH = 35;
HEATER_HEIGHT = 26;
HEATER_HOLE_SPACING_X = 22;
HEATER_HOLE_SPACING_Y = 105;
HEATER_HOLE_DIA = 5;
HEATER_PORT_WIDTH = 30; // 25;
HEATER_PORT_LENGTH = 66; // 55;

BLOWER_WIDTH = 78;
BLOWER_LENGTH = 78;
BLOWER_HEIGHT = 33; // 30;
BLOWER_HOLE_SPACING_X = 67;
BLOWER_HOLE_SPACING_Y = 46;
BLOWER_HOLE_DIA = 5;
BLOWER_PORT_WIDTH = BLOWER_HEIGHT - 1.5;
BLOWER_PORT_LENGTH = 40;

HEATER_OFFSET = 60;
BLOWER_OFFSET = HEATER_WIDTH - BLOWER_HEIGHT;

$fn = 30;

module blower_port() {
  translate([BLOWER_WIDTH/2 - BLOWER_PORT_LENGTH, BLOWER_WIDTH/2, 0])
  cube(size = [BLOWER_PORT_LENGTH, 1, BLOWER_PORT_WIDTH]);
}

module blower_holes(dia = BLOWER_HOLE_DIA) {
  for(i = [-1, 1]) {
    translate([i * BLOWER_HOLE_SPACING_X/2, -i * BLOWER_HOLE_SPACING_Y/2, 0])
    cylinder(d = dia, h = BLOWER_HEIGHT);
  }
}

module blower() {
  union() {
    hull() {
      cylinder(d = BLOWER_WIDTH, h = BLOWER_HEIGHT);
      blower_holes(dia = 2 * BLOWER_HOLE_DIA);
    }
    translate([BLOWER_WIDTH/2 - BLOWER_PORT_LENGTH, 0, 0])
    cube(size = [BLOWER_PORT_LENGTH, BLOWER_WIDTH/2, BLOWER_PORT_WIDTH]);
  }
}

module heater_port() {
  translate([-HEATER_PORT_LENGTH/2, -1, (HEATER_WIDTH - HEATER_PORT_WIDTH)/2])
  cube(size = [HEATER_PORT_LENGTH, 1, HEATER_PORT_WIDTH]);
}

module heater_holes() {
  translate([0, 0, HEATER_WIDTH/2])
  rotate([-90, 0, 0])
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * HEATER_HOLE_SPACING_Y/2, j * HEATER_HOLE_SPACING_X/2, 0])
      cylinder(d = HEATER_HOLE_DIA, h = HEATER_HEIGHT);
    }
  }
}

module heater() {
  union() {
    translate([-HEATER_LENGTH/2, 0, 0])
    cube(size = [HEATER_LENGTH, HEATER_HEIGHT, HEATER_WIDTH]);

    translate([-HEATER_PORT_LENGTH/2, 0, (HEATER_WIDTH - HEATER_PORT_WIDTH)/2])
  cube(size = [HEATER_PORT_LENGTH, HEATER_HEIGHT, HEATER_PORT_WIDTH]);

    heater_holes();
  }
}

module body() {
  hull() {
    scale([1.0, 1.0, 1.0 + BLOWER_OFFSET/BLOWER_HEIGHT])
    blower();
    translate([0, HEATER_OFFSET, 0])
    heater();
  }
}

module port() {
  hull() {
    translate([0, 0, BLOWER_OFFSET])
    blower_port();
    translate([0, HEATER_OFFSET, 0])
    heater_port();
  }
}

module assembly() {
  difference() {
    body();
    #port();

    translate([0, 0, BLOWER_OFFSET])
    blower();
    translate([0, HEATER_OFFSET, 0])
    heater();

    #blower_holes();

    #translate([0, HEATER_OFFSET - 2 * HEATER_HEIGHT, 0])
    scale([1.0, 2.0, 1.0])
    heater_holes();
  }
}

assembly();
