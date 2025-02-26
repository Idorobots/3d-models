SHAFT_DIA = 40;
SHAFT_CHAIN_DIA = 60;
SHAFT_CHAIN_LENGTH = 26;
SHAFT_LENGTH = 60;

CASE_DIA = 70;
CASE_HEIGHT = SHAFT_CHAIN_LENGTH + 14;
CASE_CORNER_DIA = 10;

MOUNT_HOLE_DIA = 4.5;
MOUNT_HOLE_HEAD_DIA = 7;
MOUNT_HOLE_DEPTH = 12;

ORING_WIDTH = 2.5;

$fn = 100;

module coupler() {
  cylinder(d = SHAFT_DIA, h = SHAFT_LENGTH, center = true);
  cylinder(d = SHAFT_CHAIN_DIA, h = SHAFT_CHAIN_LENGTH, center = true);
}

module ring(dia, width) {
  rotate_extrude()
  translate([-(dia - width)/2, 0, 0])
  circle(d = width);
}

module body() {
  hull() {
    translate([0, 0, (CASE_HEIGHT - CASE_CORNER_DIA)/2])
    ring(CASE_DIA, CASE_CORNER_DIA);

    translate([0, 0, -(CASE_HEIGHT - CASE_CORNER_DIA)/2])
    ring(CASE_DIA, CASE_CORNER_DIA);
  }
}

module case() {
  intersection() {
    difference() {
      body();
      #coupler();

      #translate([0, 0, CASE_HEIGHT/2 - (CASE_HEIGHT - SHAFT_CHAIN_LENGTH)/4])
      ring(SHAFT_DIA + ORING_WIDTH,  ORING_WIDTH);

      #translate([0, 0, -CASE_HEIGHT/2 + (CASE_HEIGHT - SHAFT_CHAIN_LENGTH)/4])
      ring(SHAFT_DIA + ORING_WIDTH,  ORING_WIDTH);

      #for(i = [0, 1]) {
        rotate([0, 0, i*180])
        for(j = [1, -1]) {
          translate([-(CASE_DIA/2 - MOUNT_HOLE_HEAD_DIA/2), 0, j * (CASE_HEIGHT/2 - MOUNT_HOLE_HEAD_DIA/2)]) {
            rotate([-90, 0, 0])
            translate([0, 0, -MOUNT_HOLE_DEPTH/2])
            cylinder(d = MOUNT_HOLE_DIA, h = CASE_DIA);
            rotate([-90, 0, 0])
            translate([0, 0, MOUNT_HOLE_DEPTH/2])
            cylinder(d = MOUNT_HOLE_HEAD_DIA, h = CASE_DIA/2);
          }
        }
      }
    }

    translate([-CASE_DIA/2, 0, -CASE_HEIGHT/2])
    cube([CASE_DIA, CASE_DIA/2, CASE_HEIGHT]);
  }
}

case();
