BAR_WIDTH = 10;
BAR_THICKNESS = 2;
BAR_LENGTH = 140; // 100;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_SPACING = 130; // 80s;

MIDDLE_HOLE = true;

$fn = 30;

module bar() {
  difference() {
    translate([-BAR_WIDTH/2, -BAR_LENGTH/2, 0])
    cube(size = [BAR_WIDTH, BAR_LENGTH, BAR_THICKNESS]);

    translate([0, -MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = BAR_THICKNESS);

    translate([0, MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = BAR_THICKNESS);

    if(MIDDLE_HOLE) {
      cylinder(d = MOUNT_HOLE_DIA, h = BAR_THICKNESS);
    }
  }
}

bar();
