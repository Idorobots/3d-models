LENGTH = 65;
WIDTH = 22;
THICKNESS = 1.5;

WHEEL_HOLE_DIA = WIDTH;

MOUNT_HOLE_DIA = 3.5;
MOUNT_HOLE_SPACING = 17;
MOUNT_HOLE_OFFSET = 12;

SLOT_LENGTH = 6;
SLOT_WIDTH = 3;
SLOT_OFFSET = 1;

HOLE_OFFSET = 21;
HOLE_DIA = 4;

$fn = 30;

module panel() {
  difference() {
    hull() {
      translate([-LENGTH/2, 0, 0])
      cylinder(d = WIDTH, h = THICKNESS);
      translate([LENGTH/2, 0, 0])
      cylinder(d = WIDTH, h = THICKNESS);
    }
    
    translate([-LENGTH/2, 0, 0])
    cylinder(d = WHEEL_HOLE_DIA, h = THICKNESS);
    translate([LENGTH/2, 0, 0])
    cylinder(d = WHEEL_HOLE_DIA, h = THICKNESS);

    translate([MOUNT_HOLE_OFFSET, -MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
    translate([MOUNT_HOLE_OFFSET, MOUNT_HOLE_SPACING/2, 0])
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
    
    hull() {
      translate([SLOT_OFFSET, -SLOT_LENGTH/2, 0])
      cylinder(d = SLOT_WIDTH, h = THICKNESS);
      translate([SLOT_OFFSET, SLOT_LENGTH/2, 0])
      cylinder(d = SLOT_WIDTH, h = THICKNESS);
    }
    
    translate([HOLE_OFFSET, 0, 0])
    cylinder(d = HOLE_DIA, h = THICKNESS);
  }
}

panel();
