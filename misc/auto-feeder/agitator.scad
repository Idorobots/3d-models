LENGTH = 50;
THICKNESS = 3;

BAR_WIDTH = 8;
TIP_DIA = 20;
AUGER_DIA = 25;

$fn = 100;

module agitator() {
  difference() {
    union() {
      translate([LENGTH/2, 0, 0])
      cylinder(d = AUGER_DIA + 2 * THICKNESS, h = THICKNESS);
      translate([-LENGTH/2, 0, 0])
      cylinder(d = TIP_DIA, h = THICKNESS);
      translate([-LENGTH/2, -BAR_WIDTH/2, 0])
      cube(size = [LENGTH, BAR_WIDTH, THICKNESS]);
    }
    translate([LENGTH/2, 0, 0])
    cylinder(d = AUGER_DIA, h = THICKNESS);
  }
}

agitator();