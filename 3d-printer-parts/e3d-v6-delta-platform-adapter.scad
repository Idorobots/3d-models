MOUNT_HOLES = 3;
MOUNT_HOLE_DIA = 4.5;
MOUNT_HOLE_HEAD_DIA = 8;
MOUNT_HOLE_SPACING = 25/2;

MOUNT_THICKNESS = 5;

CENTER_HOLE_DIA = 6;
PLATFORM_THICKNESS = 6;

NUB_LIP_DIA = 13;
NUB_LIP_THICKNESS = PLATFORM_THICKNESS;
NUB_DIA = 16;
NUB_THICKNESS = NUB_LIP_THICKNESS - 2;

ACCESSORY_MOUNT_HOLE_DIA = 2;
ACCESSORY_MOUNT_HOLE_SPACING_X = 24/2;
ACCESSORY_MOUNT_HOLE_SPACING_Y = 10;

$fn = 50;

module mount() {
  difference() {
    union() {
      hull() {
        for(i = [0:MOUNT_HOLES-1]) {
          rotate([0, 0, i * 120])
          translate([MOUNT_HOLE_SPACING, 0, 0])
          cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_THICKNESS);
        }
      }
      translate([0, 0, MOUNT_THICKNESS]) {
        cylinder(d = NUB_LIP_DIA, h = NUB_LIP_THICKNESS);
        cylinder(d = NUB_DIA, h = NUB_THICKNESS);
      }
    }

    for(i = [0:MOUNT_HOLES-1]) {
      rotate([0, 0, i * 120])
      translate([MOUNT_HOLE_SPACING, 0, 0])
      cylinder(d = MOUNT_HOLE_DIA, h = MOUNT_THICKNESS);
    }
    cylinder(d = CENTER_HOLE_DIA, h = MOUNT_THICKNESS + NUB_LIP_THICKNESS);

    for(i = [0:MOUNT_HOLES-1]) {
      rotate([0, 0, i * 120 + 60]) {
        translate([ACCESSORY_MOUNT_HOLE_SPACING_X, -ACCESSORY_MOUNT_HOLE_SPACING_Y/2, 0])
        cylinder(d = ACCESSORY_MOUNT_HOLE_DIA, h = MOUNT_THICKNESS);
        translate([ACCESSORY_MOUNT_HOLE_SPACING_X, ACCESSORY_MOUNT_HOLE_SPACING_Y/2, 0])
        cylinder(d = ACCESSORY_MOUNT_HOLE_DIA, h = MOUNT_THICKNESS);
      }
    }
  }
}

mount();
