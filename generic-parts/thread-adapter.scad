INNER_DIA = 21;
OUTER_DIA = 23.5;
THICKNESS = 12;
THREAD_PITCH = 3;

SLOT_WIDTH = 2;
SLOT_DEPTH = 2;

$fn = 50;

use <thread.scad>;


difference() {
    union() {
        difference() {
            cylinder(d = OUTER_DIA, h = THICKNESS);
            cylinder(d = INNER_DIA, h = THICKNESS);
            thread(OUTER_DIA, THICKNESS, THREAD_PITCH);
        }
        thread(INNER_DIA, THICKNESS, THREAD_PITCH);
    }
    cube(size = [SLOT_WIDTH, OUTER_DIA, SLOT_DEPTH], center = true);
}
