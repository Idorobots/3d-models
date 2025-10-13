WIDTH = 190;
HEIGHT = 25;
CORNER_DIA = 15;

WALL_THICKNESS = 1.5;

MOUNT_HOLE_DIA = 4.5;
MOUNT_HOLE_SPACING = 168;

PORTS = false;
SWITCH_WIDTH = 13;
SWITCH_LENGTH = 19;
SWITCH_OFFSET = -5;

IEC_WIDTH = 20;
IEC_LENGTH = 27;
IEC_HOLE_SPACING = 40;
IEC_HOLE_DIA = 3.2;
IEC_OFFSET = 30;

$fn = 50;

module mount_holes(width, length, height, dia) {
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * width/2, j * length/2, 0])
      cylinder(d = dia, h = height);
    }
  }
}

module outside() {
  hull()
  mount_holes(WIDTH-CORNER_DIA, WIDTH-CORNER_DIA, HEIGHT, CORNER_DIA);
}

module inside() {
  hull()
  mount_holes(WIDTH-CORNER_DIA - 2 * WALL_THICKNESS, WIDTH-CORNER_DIA - 2 * WALL_THICKNESS, HEIGHT, CORNER_DIA);
}

module iec() {
  cube(size = [IEC_LENGTH, WALL_THICKNESS * 2, IEC_WIDTH]);
  translate([-IEC_HOLE_SPACING/2 + IEC_LENGTH/2, 0, IEC_WIDTH/2])
  rotate([-90, 0, 0])
  cylinder(d = IEC_HOLE_DIA, h = WALL_THICKNESS * 2);

  translate([IEC_HOLE_SPACING/2 + IEC_LENGTH/2, 0, IEC_WIDTH/2])
  rotate([-90, 0, 0])
  cylinder(d = IEC_HOLE_DIA, h = WALL_THICKNESS * 2);
}

module switch() {
  cube(size = [SWITCH_LENGTH, WALL_THICKNESS * 2, SWITCH_WIDTH]);
}

module ports() {
  translate([IEC_OFFSET, 0, (HEIGHT + WALL_THICKNESS - IEC_WIDTH)/2])
  iec();

  translate([SWITCH_OFFSET, 0, (HEIGHT + WALL_THICKNESS - SWITCH_WIDTH)/2])
  switch();
}

intersection() {
  difference() {
    outside();

    #translate([0, 0, WALL_THICKNESS])
    inside();

    #mount_holes(MOUNT_HOLE_SPACING, MOUNT_HOLE_SPACING, HEIGHT, MOUNT_HOLE_DIA);

    #if(PORTS) {
      translate([0, WIDTH/2 - 2 * WALL_THICKNESS, 0])
      ports();
    }
  }

  translate([0, WIDTH/2, 0])
  cube(size = [WIDTH, WIDTH, 2 * HEIGHT], center = true);
}
