HEIGHT = 15;

LIP_THICKNESS = 2;
LIP_DIA = 18;

BEARING_DIA = 12.4;

NUB_DIA = 12;
NUB_THICKNESS = 1.5;

MOUNT_HOLE_DIA = 4;

$fn = 200;

difference() {
  union() {
    cylinder(d = BEARING_DIA, h = HEIGHT);
    cylinder(d = LIP_DIA, h = LIP_THICKNESS);
  }

  cylinder(d = MOUNT_HOLE_DIA, h = HEIGHT);
  cylinder(d = NUB_DIA, h = NUB_THICKNESS);
}
