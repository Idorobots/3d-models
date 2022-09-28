// 0 - No lip, teeth occupy full width.
// 1 - Regular lego lip.
// 2 - Full bottom.
// 3 - No lip at all.

BOTTOM_TYPE = 1;

THICKNESS = (BOTTOM_TYPE  == 0) ? 0.5 : 0.4;
DIAMETER = 13;
TEETH = 12;
HOLE_TYPES = [1];
CONNECTOR_SIZE = 4;
CONNECTOR_OFFSET = 1;

XY_UNIT = 8;
Z_UNIT = 7.9;

$fn = 50;

use <beam.scad>;
use <gear.scad>;

module lego_lip(inner_dia, outer_dia) {
    lip_thickness = 0.1 * Z_UNIT;
    bottom_thickness = 0.4;
    lego_translate(0, 0, THICKNESS)
    difference() {
        union() {
            translate([0, 0, -bottom_thickness])
            cylinder(d = outer_dia, h = bottom_thickness);
            cylinder(d = inner_dia + 2, h = lip_thickness);
        }
        translate([0, 0, -bottom_thickness])
        cylinder(d = inner_dia, h = lip_thickness + bottom_thickness);
    }
}

module stronger_bottom(inner_dia, outer_dia) {
    lip_thickness = 0.1 * Z_UNIT;
    lego_translate(0, 0, THICKNESS)
    difference() {
        cylinder(d = outer_dia, h = lip_thickness);
        cylinder(d = inner_dia, h = lip_thickness);
    }
}

union() {
    inner_dia = 6.8;
    gear(TEETH, DIAMETER, inner_dia, THICKNESS);
    beam(1, THICKNESS, HOLE_TYPES);

    if (BOTTOM_TYPE == 1) {
        lego_lip(inner_dia, DIAMETER);
    }

    if (BOTTOM_TYPE == 2) {
        stronger_bottom(inner_dia, DIAMETER);
    }
}
