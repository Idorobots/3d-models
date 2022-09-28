MOTOR_WIDTH = 42;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_SPACING = 31;
MOUNT_HOLE_OFFSET = (MOTOR_WIDTH - MOUNT_HOLE_SPACING)/2;
MOUNT_SHAFT_DIA = MOTOR_WIDTH - 2 * 3;
MOUNT_DIA = MOUNT_HOLE_OFFSET * 2;
MOUNT_THICKNESS = 2;

BAR_WIDTH = 20;
BAR_LENGTH = (MOTOR_WIDTH + MOUNT_HOLE_SPACING)/2 + BAR_WIDTH;
BAR_HOLE_DIA = 4;
BAR_HOLE_SPACING = 10;
BAR_HOLE_OFFSET = (MOTOR_WIDTH + MOUNT_HOLE_SPACING)/2 + BAR_WIDTH/2;
$fn = 50;

module bar() {
  difference() {
    translate([-MOUNT_HOLE_SPACING/2, -MOUNT_HOLE_OFFSET - MOUNT_THICKNESS, 0])
    cube(size = [BAR_LENGTH, MOUNT_THICKNESS, BAR_WIDTH]);

    translate([BAR_HOLE_OFFSET - MOUNT_HOLE_SPACING/2, -MOUNT_HOLE_OFFSET, BAR_WIDTH/2 - BAR_HOLE_SPACING/2])
    rotate([90, 0, 0])
    cylinder(d = BAR_HOLE_DIA, h = MOUNT_THICKNESS);

    translate([BAR_HOLE_OFFSET - MOUNT_HOLE_SPACING/2, -MOUNT_HOLE_OFFSET, BAR_WIDTH/2 + BAR_HOLE_SPACING/2])
    rotate([90, 0, 0])
    cylinder(d = BAR_HOLE_DIA, h = MOUNT_THICKNESS);
  }
}

module mount() {
  difference() {
    union() {
      hull() {
        translate([-MOUNT_HOLE_SPACING/2, 0, 0])
        cylinder(d = MOUNT_DIA, h = MOUNT_THICKNESS);

        translate([MOUNT_HOLE_SPACING/2, 0, 0])
        cylinder(d = MOUNT_DIA, h = MOUNT_THICKNESS);
      }

      bar();
    }
    translate([-MOUNT_HOLE_SPACING/2, 0, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_THICKNESS);

    translate([MOUNT_HOLE_SPACING/2, 0, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_THICKNESS);

    translate([0, MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_SHAFT_DIA, h = MOUNT_THICKNESS);
  }
}

mount();
