THICKNESS = 2;
WIDTH = 7;
LENGTH = 25;
CORNER_DIA = 1;

RAIL_THICKNESS = 2.5;

MOUNT_DIA = 2.8;
MOUNT_OFFSET = 4.5;
MOUNT_PLACEMENT = 0.80 * LENGTH;

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

module mount() {
  hull() {
    translate([0, 0, THICKNESS + MOUNT_OFFSET - MOUNT_DIA/2])
    rotate([0, 90, 0])
    cylinder(d = MOUNT_DIA + 2 * THICKNESS, h = WIDTH, center = true);
    rounded_rect(WIDTH, 2 * (LENGTH - MOUNT_PLACEMENT), THICKNESS, CORNER_DIA);
  }
}

module mount_hole() {
  #translate([0, 0, THICKNESS + MOUNT_OFFSET - MOUNT_DIA/2])
  rotate([0, 90, 0])
  cylinder(d = MOUNT_DIA, h = WIDTH, center = true);
}

module lever() {
  difference() {
    union() {
      rounded_rect(WIDTH, LENGTH, THICKNESS, CORNER_DIA);
      translate([0, MOUNT_PLACEMENT - LENGTH/2, 0])
      mount();
    }
    translate([0, MOUNT_PLACEMENT - LENGTH/2, ])
    mount_hole();
    
    translate([0, 0, THICKNESS])
    rounded_rect(RAIL_THICKNESS, LENGTH, 10, CORNER_DIA);
  }
}

lever();