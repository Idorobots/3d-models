OUTER_DIA = 17;
THREAD_DIA = 12;
THICKNESS = 6;
THREAD_PITCH = 1.5;
SLOT_WIDTH = 2;
SLOT_DEPTH = 2;

$fn = 100;

use <thread.scad>;

difference() {
    union() {
        difference() {
            cylinder(d = OUTER_DIA, h = THICKNESS);
            cylinder(d = THREAD_DIA, h = THICKNESS);
        }
        thread(THREAD_DIA, THICKNESS, THREAD_PITCH);
    }
    cube(size = [SLOT_WIDTH, OUTER_DIA, SLOT_DEPTH], center = true);
}
