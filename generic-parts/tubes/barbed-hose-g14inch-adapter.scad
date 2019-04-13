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

use <tube-adapter.scad>

// Adapted from a library by Trevor Moseley.
module thread_segment(i, diameter, pitch, segments_per_turn, segment_height) {
    a = 360/segments_per_turn; // segment angular length
	as = ((i % segments_per_turn) * a - 180); // angle to start of segment
	ae = as + a; // angle to end of segment
    sh = segment_height;
    r = diameter/2 - sh;
    h = pitch/segments_per_turn;
	z = h*i;
	//          2 ____ 5
	//          /|   /|
	//         /_|__/ |
 	//       1 \ | 4\ |
	//          \|___\|
	//          0     3
	//  
	polyhedron(
		points = [
			[cos(as)*r,sin(as)*r,z], //0
			[cos(as)*(r+sh),sin(as)*(r+sh),z+(3/8*pitch)], //1
			[cos(as)*r,sin(as)*r,z+(3/4*pitch)], //2
			[cos(ae)*r,sin(ae)*r,z+h], //3
			[cos(ae)*(r+sh),sin(ae)*(r+sh),z+(3/8*pitch)+h], //4
			[cos(ae)*r,sin(ae)*r,z+(3/4*pitch)+h]], //5
		faces = [
			[0,1,2],			// near face
			[3,5,4],			// far face
			[0,3,4],[0,4,1],	// left face
			[0,5,3],[0,2,5],	// bottom face
			[1,4,5],[1,5,2]]);	// top face
}

module thread_turn(diameter, pitch, segments_per_turn, thread_height) {
    for(i = [0:segments_per_turn-1]) {
        thread_segment(i, diameter, pitch, segments_per_turn, thread_height);
    }
}

module thread(diameter, height, pitch, thread_height) {
    intersection() {
        translate([0, 0, -height/2])
        union() {
            for(i = [0:(2*height/pitch)-1]) {
                translate([0, 0, i*pitch])	
                thread_turn(diameter, pitch, $fn, thread_height);
            }
        }
        cylinder(d = diameter, h = height);
    }
}

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