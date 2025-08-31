WIDTH = 20;
LENGTH = 28;
HEIGHT = 8;

SLOT1_WIDTH = 15;
SLOT1_LENGTH = 26;
SLOT1_THICKNESS = 3;
SLOT1_HEIGHT = 3;
SLOT2_WIDTH = SLOT1_WIDTH;
SLOT2_LENGTH = SLOT1_LENGTH;
SLOT2_THICKNESS = 1;
SLOT2_HEIGHT = 0;

POCKET_WIDTH = 11;
POCKET_LENGTH = 16;
POCKET_HEIGHT = 6.5;

SPACER_WIDTH = 1.5;
SPACER_LENGTH = POCKET_LENGTH;

WIRE_HOLE_DIA = 3.5;
WIRE_HOLE_SPACING = 6;
WIRE_HOLE_HEIGHT = 4.5;

CORNER_DIA = 3;

$fn = 50;

difference() {
  translate([-WIDTH/2, -LENGTH/2, 0])
  cube(size = [WIDTH, LENGTH, HEIGHT]);

  #difference() {
    translate([-POCKET_WIDTH/2, -LENGTH/2, 0])
    cube(size = [POCKET_WIDTH, POCKET_LENGTH, POCKET_HEIGHT]);

    translate([-SPACER_WIDTH/2, -LENGTH/2, 0])
    cube(size = [SPACER_WIDTH, SPACER_LENGTH, POCKET_HEIGHT]);
  }

  #for(i = [-1, 1]) {
    translate([-SLOT1_WIDTH/2 + i * SLOT1_WIDTH, -LENGTH/2, SLOT1_HEIGHT])
    cube(size = [SLOT1_WIDTH, SLOT1_LENGTH, SLOT1_THICKNESS]);

    translate([-SLOT2_WIDTH/2 + i * SLOT2_WIDTH, -LENGTH/2, SLOT2_HEIGHT])
    cube(size = [SLOT2_WIDTH, SLOT2_LENGTH, SLOT2_THICKNESS]);

    translate([i * WIRE_HOLE_SPACING/2, -LENGTH/2, WIRE_HOLE_HEIGHT])
    rotate([-90, 0, 0])
    cylinder(d = WIRE_HOLE_DIA, h = LENGTH);

    translate([i * (WIDTH - CORNER_DIA)/2, -(LENGTH - CORNER_DIA)/2, 0])
    rotate([0, 0, i == 1 ? 90 : 0])
    difference() {
      translate([-CORNER_DIA/2, -CORNER_DIA/2, 0])
      cube(size = [CORNER_DIA/2, CORNER_DIA/2, HEIGHT]);
      cylinder(d = CORNER_DIA, h = HEIGHT);
    }

    translate([i * -(WIDTH - CORNER_DIA)/2, LENGTH/2, CORNER_DIA/2])
    rotate([90, 0, 0])
    rotate([0, 0, i == -1 ? 90 : 0])
    difference() {
      translate([-CORNER_DIA/2, -CORNER_DIA/2, 0])
      cube(size = [CORNER_DIA/2, CORNER_DIA/2, LENGTH]);
      cylinder(d = CORNER_DIA, h = LENGTH);
    }
  }
}
