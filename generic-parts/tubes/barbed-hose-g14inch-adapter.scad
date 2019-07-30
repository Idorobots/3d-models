THREAD_DIA = 13.157;
THREAD_PITCH = 1.337;
THREAD_HEIGHT = 0.856;
OUTER_DIA = 18;
INNER_DIA = THREAD_DIA - 2 * THREAD_HEIGHT;

HOLE_DIA = 5;
BARB_DIA = 7;
BARB_LENGTH = 20;
BARB_HEIGHT = 0.5;
BARBS = 4;
ADAPTER_ANGLE = 90;

G14_HEIGHT = 5;
GASKET_HEIGHT = 2;
HEX_HEIGHT = 2;

$fn = 50;

use <barbed-hose-adapter.scad>
use <threads.scad>

difference() {
    base_height = G14_HEIGHT + GASKET_HEIGHT;
    union() {
        thread(THREAD_DIA, G14_HEIGHT, THREAD_PITCH, THREAD_HEIGHT);
        cylinder(d = INNER_DIA, h = G14_HEIGHT);
        
        translate([0, 0, G14_HEIGHT])
        cylinder(d = OUTER_DIA, h = GASKET_HEIGHT);
        
        translate([0, 0, G14_HEIGHT + GASKET_HEIGHT])
        cylinder(d = OUTER_DIA, h = HEX_HEIGHT, $fn = 6);
        
        translate([0, 0, base_height + BARB_DIA/2])
        angled_barbed_hose_adapter_pos(HOLE_DIA, BARB_DIA, BARB_LENGTH, BARB_HEIGHT, HOLE_DIA, BARB_DIA, 0, 0, ADAPTER_ANGLE, BARBS);
        
        if(ADAPTER_ANGLE == 90) {
            translate([0, 0, base_height])
            cylinder(d = OUTER_DIA, h = BARB_DIA, $fn = 6);
        }
    }
    cylinder(d = HOLE_DIA, h = base_height);
    translate([0, 0, base_height + BARB_DIA/2])
    angled_barbed_hose_adapter_neg(HOLE_DIA, BARB_DIA, BARB_LENGTH, BARB_HEIGHT, HOLE_DIA, BARB_DIA, 0, 0, ADAPTER_ANGLE, BARBS);
}