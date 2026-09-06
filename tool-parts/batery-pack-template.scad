CONTACT_WIDTH = 5.5;
CONTACT_LENGTH = 8;
CONTACT_DIA = 2;

CONTACT_SPACING = 57;

CELLS = 5;
CELL_SPACING = 23;

WIDTH = 72;
LENGTH = 105;
THICKNESS = 2;

$fn = 100;

module contact() {
  translate([0, -CONTACT_LENGTH/2, 0])
  cylinder(d = CONTACT_DIA, h = THICKNESS);
  translate([CONTACT_WIDTH/2, CONTACT_LENGTH/2, 0])
  cylinder(d = CONTACT_DIA, h = THICKNESS);
  translate([-CONTACT_WIDTH/2, CONTACT_LENGTH/2, 0])
  cylinder(d = CONTACT_DIA, h = THICKNESS);
}

module cell() {
  translate([0, -CONTACT_SPACING/2, 0])
  contact();
  translate([0, CONTACT_SPACING/2, 0])
  rotate([0, 0, 180])
  contact();
}

module battery() {
  for(i = [0:CELLS-1]) {
    translate([i * CELL_SPACING - (CELLS - 1) * CELL_SPACING/2, 0, 0])
    cell();
  }
}

difference() {
  translate([-LENGTH/2, -WIDTH/2, 0])
  cube(size = [LENGTH, WIDTH, THICKNESS]);
  #battery();
}
