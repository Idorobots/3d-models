MOUNT_HOLE_DIA = 3;
MOUNT_HOLE_SPACING = 32;

WIDTH = 9;
LENGTH = 39;
THICKNESS = 2.5;

TUBE_DIA = 4;
TUBE_OFFSET = 2;

ADAPTER_OUTER_DIA = 12;
ADAPTER_INNER_DIA = 9.5;
ADAPTER_LENGTH = 6;

$fn = 50;

difference() {
  union() {
    translate([0, -TUBE_OFFSET, THICKNESS/2])
    cube([WIDTH, LENGTH, THICKNESS], center = true);
    cylinder(d = ADAPTER_OUTER_DIA, h = THICKNESS + ADAPTER_LENGTH);
  }

  #cylinder(d = TUBE_DIA, h = THICKNESS + ADAPTER_LENGTH);

  #translate([0, 0, THICKNESS])
  cylinder(d = ADAPTER_INNER_DIA, h = ADAPTER_LENGTH);

  #translate([0, -MOUNT_HOLE_SPACING/2 - TUBE_OFFSET, 0])
  cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);

  #translate([0, MOUNT_HOLE_SPACING/2 - TUBE_OFFSET, 0])
  cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
}
