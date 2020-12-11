BOX_DIA = 250;
BOX_ADJUST_OFFSET = 2;

MOUNT_WIDTH = 24;
MOUNT_LENGTH = 36;
MOUNT_HEIGHT = 16;
MOUNT_CORNER_DIA = 2;
MOUNT_THICKNESS = BOX_ADJUST_OFFSET + 2;

MOUNT_HOLE_DIA = 4.5;
MOUNT_HOLE_HEAD_DIA = 8;
MOUNT_HOLE_SPACING = 24;

PASSTHROUGH_OFFSET = 2;
PASSTHROUGH_DIA = 9.5;
PASSTHROUGH_ANGLE = 60;

ROUND = true;

$fn = 100;

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2, (height - corner_dia)/2])
        sphere(d = corner_dia);

        translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2, -(height - corner_dia)/2])
        sphere(d = corner_dia);
      }
    }
  }
}

module passthrough() {
  difference() {
    union() {
      rotate([0, PASSTHROUGH_ANGLE - 90, 0])
      if(ROUND) {
        rounded_rect(MOUNT_WIDTH, MOUNT_LENGTH, MOUNT_HEIGHT, MOUNT_CORNER_DIA);        
      } else {
        cube(size = [MOUNT_WIDTH, MOUNT_LENGTH, MOUNT_HEIGHT], center = true);
      }
    }

    #translate([0, 0, -BOX_DIA/2 + BOX_ADJUST_OFFSET])
    rotate([90, 0, 0])
    cylinder(d = BOX_DIA, h = 100, center = true);

    #translate([0, 0, PASSTHROUGH_OFFSET])
    rotate([0, PASSTHROUGH_ANGLE, 0])
    cylinder(d = PASSTHROUGH_DIA, h = MOUNT_WIDTH * 2, center = true);

    #translate([0, -MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HEIGHT * 2, center = true);
 
    #translate([0, -MOUNT_HOLE_SPACING/2, MOUNT_THICKNESS])
    cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HEIGHT);

    #translate([0, MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_HEIGHT * 2, center = true);

    #translate([0, MOUNT_HOLE_SPACING/2, MOUNT_THICKNESS])
    cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HEIGHT);
  }
}

passthrough();