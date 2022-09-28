MOUNT_HOLE_DIA = 3.5;
MOUNT_HOLE_SPACING = 40;

SLOT_OFFSET = 6.5;
SLOT_LENGTH = 32;
SLOT_WIDTH = 10;

HEIGHT = 20;
WALL_THICKNESS = 0.6;
THICKNESS = 2;

OUTPUT_WIDTH = 2.5;
OUTPUT_ANGLE = 5;

$fn = 100;

module duct(width, length, height, output_width) {
  intersection() {
    translate([0, (height * 2 - width)/2, 0])
    rotate([0, 90, 0])
    difference() {
      cylinder(d = height * 2, h = length, center = true);
      hull() {
        translate([-(width - output_width), 0, 0])
        cylinder(d = height * 2 - width * 2, h = length * 2, center = true);
        cylinder(d = height * 2 - width * 2, h = length * 2, center = true);
      }
    }

    translate([-length/2, -(SLOT_WIDTH + SLOT_OFFSET)/2, 0])
    cube(size = [length, SLOT_WIDTH + SLOT_OFFSET, height]);
  }
}

module holes() {
  #union() {
    cube(size = [SLOT_LENGTH, SLOT_WIDTH, THICKNESS * 2], center = true);

    for(i = [-1, 1]) {
      translate([i * MOUNT_HOLE_SPACING/2, SLOT_OFFSET, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS * 2, center = true);
    }

    duct(SLOT_WIDTH, SLOT_LENGTH, HEIGHT - WALL_THICKNESS, OUTPUT_WIDTH);
  }
}

module cooler() {
  wt = 2 * WALL_THICKNESS;
  union() {
    translate([-(SLOT_LENGTH + wt)/2, -(SLOT_WIDTH + wt)/2, 0])
    cube(size = [SLOT_LENGTH + wt, SLOT_WIDTH + wt, THICKNESS]);

    for(i = [-1, 1]) {
      hull() {
        translate([i * MOUNT_HOLE_SPACING/2, SLOT_OFFSET, 0])
        cylinder(d = MOUNT_HOLE_DIA + 2 * THICKNESS, h = THICKNESS);

        translate([i * (SLOT_LENGTH - MOUNT_HOLE_DIA)/2 -(MOUNT_HOLE_DIA + wt)/2, -(SLOT_WIDTH + wt)/2, 0])
        cube(size = [MOUNT_HOLE_DIA + wt, SLOT_WIDTH + wt, THICKNESS]);
      }
    }

    duct(SLOT_WIDTH + wt, SLOT_LENGTH + wt, HEIGHT, OUTPUT_WIDTH + wt);
  }
}

module cutoff() {
  wt = 2 * WALL_THICKNESS;
  #translate([0, SLOT_WIDTH + wt + SLOT_OFFSET, HEIGHT - (OUTPUT_WIDTH + wt)])
  rotate([OUTPUT_ANGLE, 0, 0])
  translate([0, -SLOT_WIDTH/2, 0])
  cube(size = [SLOT_LENGTH + wt, SLOT_WIDTH, SLOT_WIDTH * 2], center = true);
}

difference() {
  cooler();
  holes();
  cutoff();
}
