WIDTH = 13;
HEIGHT = 4;
LENGTH = 56;
BAR_LENGTH = 36;
BAR_WIDTH_MID = 8;
BAR_WIDTH_OUT = 10;
SLOT_WIDTH = 0.3;
SLOT_LENGTH = (WIDTH - min(BAR_WIDTH_OUT, BAR_WIDTH_MID))/2;

module bar() {
  #translate([0, BAR_LENGTH/2, 0])
  hull() {
    translate([0, 0.5, 0])
    cube(size = [BAR_WIDTH_MID, 1, HEIGHT], center = true);
    translate([0, (LENGTH - BAR_LENGTH)/2, 0])
    cube(size = [BAR_WIDTH_OUT, 1, HEIGHT], center = true);
  }
}

module slot() {
  #translate([(WIDTH - SLOT_LENGTH)/2, 0, 0])
  cube(size = [SLOT_LENGTH, SLOT_WIDTH, HEIGHT], center = true);
}

module spool() {
  difference() {
    cube(size = [WIDTH, LENGTH, HEIGHT], center = true);
    bar();
    rotate([0, 0, 180])
    bar();
    slot();
    rotate([0, 0, 180])
    slot();
  }
}

spool();
