BASE_DIA = 12;
BASE_THICKNESS = 1;

PIN_DIA = 6;
PIN_LIP_DIA = 6.5;
PIN_SLOT_WIDTH = 2;
PIN_LIP_HEIGHT = 2.4;
PIN_SQUISH = 0.85;

PIN_LENGTH = BASE_THICKNESS + PIN_LIP_HEIGHT + PIN_LIP_DIA - PIN_DIA + 0.5;

$fn = 50;

union() {
  cylinder(d = BASE_DIA, h = BASE_THICKNESS);

  intersection() {
    difference() {
      union() {
        cylinder(d = PIN_DIA, h = PIN_LENGTH);

        translate([0, 0, PIN_LIP_HEIGHT + BASE_THICKNESS])
        rotate_extrude()
        translate([-PIN_DIA/2, 0, 0])
        scale([1.0, 2.0])
        circle(d = PIN_LIP_DIA-PIN_DIA);
      }
      translate([-PIN_LIP_DIA/2, -PIN_SLOT_WIDTH/2, BASE_THICKNESS])
      cube(size = [PIN_LIP_DIA, PIN_SLOT_WIDTH, PIN_LENGTH]);
    }
      translate([-PIN_DIA/2 * PIN_SQUISH, -PIN_LIP_DIA/2, BASE_THICKNESS])
      cube(size = [PIN_DIA * PIN_SQUISH, PIN_LIP_DIA, PIN_LENGTH]);
  }
}
