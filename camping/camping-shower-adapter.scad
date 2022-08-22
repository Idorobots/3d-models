TAP_DIA = 13;
TAP_LENGTH = 10;

SHOWER_DIA = 14;
SHOWER_LENGTH = 9;
SHOWER_PITCH = 1.5;

INNER_HOLE_DIA = min(TAP_DIA, SHOWER_DIA);

WALL_THICKNESS = 2;
ADAPTER_DIA = 2 * WALL_THICKNESS + max(TAP_DIA, SHOWER_DIA);
ADAPTER_LENGTH = TAP_LENGTH + 1 + SHOWER_LENGTH;

$fn = 50;

use <../generic-parts/thread.scad>


module tap() {
  cylinder(d = TAP_DIA, h = TAP_LENGTH);
}

module shower() {
  thread(SHOWER_DIA, SHOWER_LENGTH, SHOWER_PITCH);
}

module adapter() {
  union() {
    difference() {
      cylinder(d = ADAPTER_DIA, h = ADAPTER_LENGTH);
      tap();
      cylinder(d = INNER_HOLE_DIA, h = ADAPTER_LENGTH);
    }
    translate([0, 0, ADAPTER_LENGTH - SHOWER_LENGTH])
    shower();
  }
}

adapter();