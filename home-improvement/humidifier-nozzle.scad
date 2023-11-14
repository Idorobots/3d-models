WALL_THICKNESS = 1;
BASE_DIA = 35;
BASE_HEIGHT = 12;

NOZZLE_WIDTH = 15;
NOZZLE_DIA = 6;
NOZZLE_ANGLE = 85;

NOZZLE_LENGTH = 16;
NOZZLE_HEIGHT = 32;

BRIM_DIA = BASE_DIA + 34;
BRIM_THICKNESS = WALL_THICKNESS;

$fn = 50;

module duct(wt = 0) {
    dia = (NOZZLE_WIDTH + 2 * wt + BASE_DIA)/2;
    hull() {
        cylinder(d = BASE_DIA + 2 * wt, h = BASE_HEIGHT);
        translate([0, 0, dia/2])
        sphere(d = dia);

        nozzle_dia = NOZZLE_DIA + 2 * wt;
        translate([0, NOZZLE_LENGTH, NOZZLE_HEIGHT - NOZZLE_DIA])
        rotate([-NOZZLE_ANGLE, 0, 0]) {
            translate([-(NOZZLE_WIDTH-NOZZLE_DIA)/2, 0, 0])
            cylinder(d = nozzle_dia, h = 2);
            translate([(NOZZLE_WIDTH-NOZZLE_DIA)/2, 0, 0])
            cylinder(d = nozzle_dia, h = 2);
        }
        translate([0, 0, dia/2])
        sphere(d = dia);
    }
}

module neg() {
    duct();
}

module pos() {
    duct(WALL_THICKNESS);
}

module nozzle() {
   difference() {
      union() {
          pos();
          cylinder(d = BRIM_DIA, h = BRIM_THICKNESS);
      }
       #neg();
   }
}

nozzle();
