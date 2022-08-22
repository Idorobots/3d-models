NECK_DIA = 22;
NECK_HEIGHT = 15;

HEAD_DIA = 35;
HEAD_HEIGHT = 10;
HEAD_CONE_HEIGHT = 5;

HOLE_DIA = 14;
SLOT_WIDTH = 2.5;
SLOT_LENGTH = 8;

$fn = 100;

module bidet() {
  difference() {
    union() {
      cylinder(d = HEAD_DIA, h = HEAD_HEIGHT);
      translate([0, 0, HEAD_HEIGHT])
      cylinder(d1 = HEAD_DIA, d2 = NECK_DIA, h = HEAD_CONE_HEIGHT);
      translate([0, 0, HEAD_HEIGHT + HEAD_CONE_HEIGHT])
      cylinder(d = NECK_DIA, h = NECK_HEIGHT);
    }
    
    #translate([0, 0, (HEAD_HEIGHT - SLOT_LENGTH)/2])
    cylinder(d = HOLE_DIA, h = NECK_HEIGHT + HEAD_HEIGHT + HEAD_CONE_HEIGHT);
    
  
    #translate([0, 0, SLOT_LENGTH/2 + (HEAD_HEIGHT - SLOT_LENGTH)/2])
    rotate([90, 0, 0])
    hull() {
      translate([0, -(SLOT_LENGTH-SLOT_WIDTH)/2, 0])
      cylinder(d = SLOT_WIDTH, h = HEAD_DIA/2);
      translate([0, (SLOT_LENGTH-SLOT_WIDTH)/2, 0])
      cylinder(d = SLOT_WIDTH, h = HEAD_DIA/2);
    }
  }
}

bidet();