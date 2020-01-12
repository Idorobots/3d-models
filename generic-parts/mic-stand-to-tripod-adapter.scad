STAND_INNER_DIA = 26;
STAND_OUTER_DIA = 36;
STAND_INNER_HEIGHT = 2;
STAND_OUTER_HEIGHT = STAND_INNER_HEIGHT + 5;

THREAD_LENGTH = 10;
THREAD_HEIGHT = 0.6;
THREAD_DIA = 21;
THREAD_PITCH = 1.0;

SCREW_DIA = 4;
SCREW_HEAD_DIA = 8;
SCREW_HEAD_LENGTH = 5;

$fn = 50;

use <tubes/threads.scad>


difference() {
    union() {
        thread(THREAD_DIA, THREAD_LENGTH, THREAD_PITCH, THREAD_HEIGHT);
        cylinder(d = THREAD_DIA - 2 * THREAD_HEIGHT, h = THREAD_LENGTH);

        difference() {
            cylinder(d = STAND_OUTER_DIA, h = STAND_OUTER_HEIGHT);

            translate([0, 0, STAND_INNER_HEIGHT])
            cylinder(d = STAND_INNER_DIA, h = STAND_OUTER_HEIGHT - STAND_INNER_HEIGHT);
        }
    }

    cylinder(d = SCREW_DIA, h = THREAD_LENGTH);

    translate([0, 0, THREAD_LENGTH - SCREW_HEAD_LENGTH])
    cylinder(d = SCREW_HEAD_DIA, h = SCREW_HEAD_LENGTH);
}
