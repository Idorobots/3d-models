ROD_MOUNT_HOLE_DIA = 4.5;
ROD_MOUNT_HOLE_SPACING = 50;
ROD_MOUNT_DIA = 7;
ROD_MOUNT_HEIGHT = 7;
ROD_MOUNT_OFFSET = 10;

MOUNT_DIA = 10;
MOUNT_HOLE_DIA = 3.5;
MOUNT_HOLE_SPACING = 20;

THICKNESS = 5;

$fn = 30;

difference() {
  union() {
    hull() {
      for(i = [-1, 1]) {
        translate([i * ROD_MOUNT_HOLE_SPACING/2, ROD_MOUNT_OFFSET, 0])
        cylinder(d = ROD_MOUNT_DIA, h = THICKNESS);

        translate([i * MOUNT_HOLE_SPACING/2, 0, 0])
        cylinder(d = MOUNT_DIA, h = THICKNESS);
      }
    }
    for(i = [-1, 1]) {
      translate([i * ROD_MOUNT_HOLE_SPACING/2, ROD_MOUNT_OFFSET, 0])
      cylinder(d = ROD_MOUNT_DIA, h = ROD_MOUNT_HEIGHT);
    }
  }

  #for(i = [-1, 1]) {
    translate([i * ROD_MOUNT_HOLE_SPACING/2, ROD_MOUNT_OFFSET, 0])
    cylinder(d = ROD_MOUNT_HOLE_DIA, h = ROD_MOUNT_HEIGHT);

    translate([i * MOUNT_HOLE_SPACING/2, 0, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
  }
}
