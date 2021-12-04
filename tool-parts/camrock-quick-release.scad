OUTER_DIA_BOT = 54;
OUTER_DIA_TOP = 44;
INNER_DIA_BOT = 45;
INNER_DIA_TOP = 35;
INNER_VOID_THICKNESS = 7;
THICKNESS = 11;
LIP_THICKNESS = 4;
MOUNT_HOLE_DIA = 7;

$fn = 50;

module void() {
  union() {
    cylinder(d = INNER_DIA_BOT, h = LIP_THICKNESS, $fn = 6);
    translate([0, 0, LIP_THICKNESS])
    cylinder(d1 = INNER_DIA_BOT, d2 = INNER_DIA_TOP, h = INNER_VOID_THICKNESS - LIP_THICKNESS, $fn = 6);
    cylinder(d = MOUNT_HOLE_DIA, h = THICKNESS);
  }
}

module base() {
  difference() {
    union() {
      cylinder(d = OUTER_DIA_BOT, h = LIP_THICKNESS, $fn = 6);
      translate([0, 0, LIP_THICKNESS])
      cylinder(d1 = OUTER_DIA_BOT, d2 = OUTER_DIA_TOP, h = THICKNESS - LIP_THICKNESS, $fn = 6);
    }
    void();
  }
}

base();