GEAR_INNER_DIA = 5.5;//6;
GEAR_INNER_WIDTH = 4;

GEAR_OUTER_DIA = 26;
GEAR_WIDTH = 14;

GEAR_CROWN_WIDTH = 6;
GEAR_CROWN_DIA = 22;

SHAFT_LENGTH = GEAR_WIDTH + 5;
SHAFT_DIA = 10;
SHAFT_BOLT_DIA = SHAFT_DIA;
SHAFT_BOLT_LENGTH = 5;// 3;

ROUND_SHAFT = true;

$fn = 50;

module shaft() {
  intersection() {
    cylinder(d = GEAR_INNER_DIA, h = SHAFT_LENGTH);
    if(!ROUND_SHAFT) {
      cube(size = [GEAR_INNER_WIDTH, GEAR_INNER_DIA, 2 * SHAFT_LENGTH], center = true);
    }
  }

  cylinder(d = SHAFT_BOLT_DIA, h = SHAFT_BOLT_LENGTH);
}

module gear() {
  difference(){
    union() {
      ch = (GEAR_WIDTH - GEAR_CROWN_WIDTH)/2;
      cylinder(d1 = GEAR_CROWN_DIA, d2 = GEAR_OUTER_DIA, h = ch);

      translate([0, 0, ch])
      cylinder(d = GEAR_OUTER_DIA, h = GEAR_CROWN_WIDTH);

      translate([0, 0, ch + GEAR_CROWN_WIDTH])
      cylinder(d1 = GEAR_OUTER_DIA, d2 = GEAR_CROWN_DIA, h = ch);

      cylinder(d = SHAFT_DIA, h = SHAFT_LENGTH);
    }

    shaft();
  }
}

gear();
