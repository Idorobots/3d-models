PLATE_THICKNESS = 1;
PLATE_LENGTH = 50;
PLATE_WIDTH = 15;

TOP_PLATE = true;
TOP_PLATE_HEIGHT = 10;

NOB_SIZE = 4.75;
NOB_LIP_SIZE = NOB_SIZE;
NOB_LIP_THICKNESS = 0;
NOB_LENGTH = 2.5;

CHAIN_EXCLUSION_WIDTH = NOB_LIP_SIZE != NOB_SIZE ? PLATE_WIDTH - NOB_LIP_SIZE : 8;
CHAIN_EXCLUSION_LENGTH = 10;

module plate() {
  difference() {
    union() {
      cube(size = [PLATE_LENGTH, PLATE_WIDTH, PLATE_THICKNESS], center = true);
      translate([0, (PLATE_WIDTH - NOB_LIP_SIZE)/2, PLATE_THICKNESS/2]) {
        translate([0, 0, NOB_LIP_THICKNESS/2])
        cube(size = [NOB_LIP_SIZE, NOB_LIP_SIZE, NOB_LIP_THICKNESS], center = true);

        translate([0, 0, NOB_LENGTH/2])
        cube(size = [NOB_SIZE, NOB_SIZE, NOB_LENGTH], center = true);
      }

      if(TOP_PLATE) {
        translate([0, (PLATE_WIDTH - PLATE_THICKNESS)/2, -TOP_PLATE_HEIGHT/2])
        cube(size = [PLATE_LENGTH, PLATE_THICKNESS, TOP_PLATE_HEIGHT], center = true);
      }
    }

    #translate([0, -(PLATE_WIDTH - CHAIN_EXCLUSION_WIDTH)/2, 0])
    cube(size = [CHAIN_EXCLUSION_LENGTH, CHAIN_EXCLUSION_WIDTH, PLATE_THICKNESS], center = true);
  }
}

plate();
