WIDTH = 40;

ROD_MOUNT_DIA = 7;
ROD_MOUNT_INTERFACE_DIA = 5;
ROD_MOUNT_INTERFACE_LENGTH = 1.5;
ROD_MOUNT_LENGTH = 5.8;

ROD_HOLE_DIA = 3.5;

BAR_THICKNESS = 2;
BAR_WIDTH = ROD_MOUNT_DIA;
BAR_LENGTH = WIDTH - 2 * ROD_MOUNT_LENGTH;

MOUNT_HOLE_SPACING = 20;
MOUNT_HOLE_DIA = 3.5;

$fn = 50;

module rod_mount() {
  difference() {
    union() {
       hull() {
        translate([0, 0, 0.5])
        cube([BAR_WIDTH, BAR_WIDTH, 1], center = true);
        cylinder(d = ROD_MOUNT_DIA, h = ROD_MOUNT_LENGTH - ROD_MOUNT_INTERFACE_LENGTH);
       }
       translate([0, 0, ROD_MOUNT_LENGTH - ROD_MOUNT_INTERFACE_LENGTH])
       cylinder(d1 = ROD_MOUNT_DIA, d2 = ROD_MOUNT_INTERFACE_DIA, h = ROD_MOUNT_INTERFACE_LENGTH);
    }

    #cylinder(d = ROD_HOLE_DIA, h = ROD_MOUNT_LENGTH);
  }
}

difference() {
  union() {
    translate([0, 0, BAR_THICKNESS/2])
    cube([BAR_WIDTH, BAR_LENGTH, BAR_THICKNESS], center = true);

    for(i = [-1, 1]) {
      translate([0, i * BAR_LENGTH/2, ROD_MOUNT_DIA/2])
      rotate([i * -90, 0, 0])
      rod_mount();
    }
  }

  #for(i = [-1, 1]) {
    translate([0, i * MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = BAR_THICKNESS);
  }
}
