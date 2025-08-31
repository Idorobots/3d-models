FAN1_HOLE_DIA = 4.5;
FAN1_HOLE_SPACING = 106;
FAN1_MOUNT_WIDTH = 8;

FAN2_HOLE_DIA = FAN1_HOLE_DIA;
FAN2_HOLE_SPACING = 90; // 106;
FAN2_MOUNT_WIDTH = 8;

FAN_SPACING = 15; // 39.5; // 50;
FAN_SPACING_SPLIT = 1.0; // 0.5;

THICKNESS = 2;
BAR_WIDTH = 12;
BAR_LENGTH = 100;

$fn = 100;

difference() {
  union() {
    hull() {
      translate([-(BAR_LENGTH-BAR_WIDTH)/2, 0, 0])
      cylinder(d = BAR_WIDTH, h = THICKNESS);
      translate([(BAR_LENGTH-BAR_WIDTH)/2, 0, 0])
      cylinder(d = BAR_WIDTH, h = THICKNESS);
    }

    for(i = [-1, 1]) {
      hull() {
        translate([i * FAN1_HOLE_SPACING/2, -FAN_SPACING * FAN_SPACING_SPLIT, 0])
        cylinder(d = FAN1_MOUNT_WIDTH, h = THICKNESS);
        translate([i * (BAR_LENGTH-BAR_WIDTH)/2, 0, 0])
        cylinder(d = BAR_WIDTH, h = THICKNESS);
      }
      hull() {
        translate([i * FAN2_HOLE_SPACING/2, FAN_SPACING * (1 - FAN_SPACING_SPLIT), 0])
        cylinder(d = FAN2_MOUNT_WIDTH, h = THICKNESS);
        translate([i * (BAR_LENGTH-BAR_WIDTH)/2, 0, 0])
        cylinder(d = BAR_WIDTH, h = THICKNESS);
      }
    }
  }

  #for(i = [-1, 1]) {
    translate([i * FAN1_HOLE_SPACING/2, -FAN_SPACING * FAN_SPACING_SPLIT, 0])
    cylinder(d = FAN1_HOLE_DIA, h = THICKNESS);
    translate([i * FAN2_HOLE_SPACING/2, FAN_SPACING * (1 - FAN_SPACING_SPLIT), 0])
    cylinder(d = FAN2_HOLE_DIA, h = THICKNESS);
  }
}
