NUB_DIA = 3;
NUB_LENGTH = 4;
HEX_DIA = 9;
HEX_LENGTH = 8;

DIA = 11;
HEIGHT = 13;

SPACING = 18;

$fn = 50;

module inside() {
  cylinder(d = HEX_DIA, h = HEX_LENGTH, $fn = 6);
  translate([0, 0, HEX_LENGTH])
  cylinder(d = NUB_DIA, h = NUB_LENGTH);
}

module isolator() {
  difference() {
    hull() {
      translate([-SPACING/2, 0, 0])
      cylinder(d = DIA, h = HEIGHT);
      translate([SPACING/2, 0, 0])
      cylinder(d = DIA, h = HEIGHT);
    }
    #translate([-SPACING/2, 0, 0])
    inside();

    #translate([SPACING/2, 0, 0])
    inside();
  }
}

isolator();
