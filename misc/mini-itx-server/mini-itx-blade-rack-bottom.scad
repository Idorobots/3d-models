HEIGHT = 10;
HEIGHT_MIDDLE = 5;
WIDTH = 162;
WIDTH_MIDDLE = WIDTH - 2 * 20;
THICKNESS = 2.5;
CORNER_DIA = 4;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_HEAD_DIA = 6;
MOUNT_HOLE_OFFSET = 5;
MOUNT_HOLE_SPACING_TOP = WIDTH - 2 * MOUNT_HOLE_OFFSET;
MOUNT_HOLE_SPACING_BOT = WIDTH_MIDDLE + 2 * MOUNT_HOLE_OFFSET;

$fn = 30;

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

module mounting_holes(spacing) {
  #for(i = [-1, 1]) {
    translate([-MOUNT_HOLE_OFFSET, i * spacing/2, 0]) {
      cylinder(d = MOUNT_HOLE_DIA, h = HEIGHT);
      translate([0, 0, HEIGHT/2])
      cylinder(d = MOUNT_HOLE_HEAD_DIA, h = HEIGHT/2);
    }
  }
}

difference() {
  union() {
    hull() {
    translate([-HEIGHT_MIDDLE/2, 0, 0])
    rounded_rect(HEIGHT_MIDDLE, WIDTH, THICKNESS, CORNER_DIA);

    translate([-THICKNESS, 0, HEIGHT_MIDDLE/2])
    rotate(90, [0, 1, 0])
    rounded_rect(HEIGHT_MIDDLE, WIDTH, THICKNESS, CORNER_DIA);
    }
    w = (WIDTH-WIDTH_MIDDLE)/2;
    
    translate([-HEIGHT/2, (WIDTH - w)/2, 0])
    rounded_rect(HEIGHT, w, THICKNESS, CORNER_DIA);

    translate([-HEIGHT/2, -(WIDTH - w)/2, 0])
    rounded_rect(HEIGHT, w, THICKNESS, CORNER_DIA);

    translate([-THICKNESS, -(WIDTH - w)/2, HEIGHT/2])
    rotate(90, [0, 1, 0])
    rounded_rect(HEIGHT, w, THICKNESS, CORNER_DIA);

    translate([-THICKNESS, (WIDTH - w)/2, HEIGHT/2])
    rotate(90, [0, 1, 0])
    rounded_rect(HEIGHT, w, THICKNESS, CORNER_DIA);
  }
  translate([0, 0, -THICKNESS])
  mounting_holes(MOUNT_HOLE_SPACING_BOT);
  
  translate([THICKNESS, 0, 2 * MOUNT_HOLE_OFFSET])
  rotate(-90, [0, 1, 0])
  mounting_holes(MOUNT_HOLE_SPACING_TOP);
}