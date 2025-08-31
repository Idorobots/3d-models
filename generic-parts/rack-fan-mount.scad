FAN_HOLE_SPACING = 90;
FAN_HOLE_DIA = 4.5;

BAR_WIDTH = 15;
BAR_LENGTH = 168;
THICKNESS = 2;

MOUNT_DIA = 6;
MOUNT_LENGTH = 3;
MOUNT_OFFSET = MOUNT_DIA/2-0.5;

$fn = 100;

intersection() {
  translate([-BAR_LENGTH/2 - MOUNT_LENGTH, -BAR_WIDTH/2, 0])
  cube(size = [BAR_LENGTH + 2 * MOUNT_LENGTH, BAR_WIDTH, MOUNT_DIA]);
  difference() {
    union() {
      hull() {
        translate([-(BAR_LENGTH-BAR_WIDTH)/2, 0, 0])
        cylinder(d = BAR_WIDTH, h = THICKNESS);

        translate([(BAR_LENGTH-BAR_WIDTH)/2, 0, 0])
        cylinder(d = BAR_WIDTH, h = THICKNESS);
      }

      for(i = [-1, 1]) {
        translate([i * BAR_LENGTH/2, 0, MOUNT_OFFSET])
        rotate([0, i * 90, 0]) {
          sphere(d = MOUNT_DIA);
          cylinder(d = MOUNT_DIA, h = MOUNT_LENGTH);
        }
      }
    }

      #for(i = [-1, 1]) {
        translate([i * FAN_HOLE_SPACING/2, 0, 0])
        cylinder(d = FAN_HOLE_DIA, h = THICKNESS);
      }
  }
}
