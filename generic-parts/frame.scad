FRAME_WIDTH = 100;
FRAME_LENGTH = 140;
FRAME_THICKNESS = 2;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_SPACING_X = 80;
MOUNT_HOLE_SPACING_Y = 130;

HOLE_CORNER_DIA = 10;
HOLE_WIDTH = FRAME_WIDTH - 20;
HOLE_LENGTH = (FRAME_LENGTH - 30)/2;
HOLE_SPACING = HOLE_LENGTH + 10;

$fn = 50;

module hole() {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (HOLE_WIDTH-HOLE_CORNER_DIA)/2, j * (HOLE_LENGTH-HOLE_CORNER_DIA)/2, 0])
        cylinder(d = HOLE_CORNER_DIA, h = FRAME_THICKNESS);
      }
    }
  }
}

module frame() {
  difference() {
    translate([-FRAME_WIDTH/2, -FRAME_LENGTH/2, 0])
    cube(size = [FRAME_WIDTH, FRAME_LENGTH, FRAME_THICKNESS]);

    for(i = [-1, 1]) {
      translate([i * MOUNT_HOLE_SPACING_X/2, -MOUNT_HOLE_SPACING_Y/2, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = FRAME_THICKNESS);

      translate([i * MOUNT_HOLE_SPACING_X/2, MOUNT_HOLE_SPACING_Y/2, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = FRAME_THICKNESS);

      translate([i * MOUNT_HOLE_SPACING_X/2, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = FRAME_THICKNESS);

      translate([0, i * HOLE_SPACING/2, 0])
      hole();
    }
  }
}

frame();
