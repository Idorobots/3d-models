WIDTH = 40;

ROD_MOUNT_DIA = 7;
ROD_MOUNT_THICKNESS = 5;
ROD_HOLE_SPACING = 50;
ROD_HOLE_DIA = 4.5;

BAR_THICKNESS = 2;
BAR_WIDTH = 7;
BAR_LENGTH = 28.8;

MOUNT_HOLE_SPACING = 20;
MOUNT_HOLE_DIA = 3.5;

$fn = 50;

module rod_mount(bar = true) {
  difference() {
    hull() {
      for(i = [-1, 1]) {
        translate([i * ROD_HOLE_SPACING/2, 0, 0])
        cylinder(d = ROD_MOUNT_DIA, h = ROD_MOUNT_THICKNESS);

        translate([i * BAR_LENGTH/2, 0, 0])
        cylinder(d = BAR_WIDTH, h = ROD_MOUNT_THICKNESS);
      }
    }

    if(bar) {
      #translate([-BAR_LENGTH/2, -BAR_WIDTH/2, BAR_THICKNESS])
      cube([BAR_LENGTH, BAR_WIDTH, ROD_MOUNT_THICKNESS]);
    }

    #for(i = [-1, 1]) {
      translate([i * ROD_HOLE_SPACING/2, 0, 0])
      cylinder(d = ROD_HOLE_DIA, h = ROD_MOUNT_THICKNESS);

      translate([i * MOUNT_HOLE_SPACING/2, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = ROD_MOUNT_THICKNESS);
    }
  }
}

rod_mount();
