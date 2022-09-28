THICKNESS = 0.5;
HOLE_TYPES = [1, 0, 1];
CONNECTOR_SIZE = 4;
CONNECTOR_OFFSET = 1;

XY_UNIT = 8;
Z_UNIT = 7.9;

$fn = 50;

use <beam.scad>;
use <gear.scad>;

union() {
    gear(36, 37.2, 29, THICKNESS);
    beam(3, THICKNESS, HOLE_TYPES);
    rotate([0, 0, 90])
    beam(3, THICKNESS, HOLE_TYPES);
    for(i = [0:4]) {
        rotate([0, 0, i * 90])
        translate([1.5 * XY_UNIT + CONNECTOR_OFFSET, 0, THICKNESS * Z_UNIT/2])
        cube(size = [CONNECTOR_SIZE, CONNECTOR_SIZE, THICKNESS * Z_UNIT], center = true);
    }
}
