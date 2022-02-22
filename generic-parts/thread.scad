
// Adapted from a library by Trevor Moseley.
module thread_segment(i, diameter, pitch, segments_per_turn) {
  a = 360/segments_per_turn; // segment angular length
	as = ((i % segments_per_turn) * a - 180); // angle to start of segment
	ae = as + a; // angle to end of segment
  sh = 5*(cos(30)*pitch)/8;
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
			[cos(as)*(r+sh),sin(as)*(r+sh),z], //0
			[cos(as)*r,sin(as)*r,z+(3/8*pitch)], //1
			[cos(as)*(r+sh),sin(as)*(r+sh),z+(3/4*pitch)], //2
			[cos(ae)*(r+sh),sin(ae)*(r+sh),z+h], //3
			[cos(ae)*r,sin(ae)*r,z+(3/8*pitch)+h], //4
			[cos(ae)*(r+sh),sin(ae)*(r+sh),z+(3/4*pitch)+h]], //5
		faces = [
			[0,1,2],			// near face
			[3,5,4],			// far face
			[0,3,4],[0,4,1],	// left face
			[0,5,3],[0,2,5],	// bottom face
			[1,4,5],[1,5,2]]);	// top face
}

module thread_turn(diameter, pitch, segments_per_turn) {
    for(i = [0:segments_per_turn-1]) {
        thread_segment(i, diameter, pitch, segments_per_turn);
    }
}

module thread(diameter, height, pitch) {
    intersection() {
        translate([0, 0, -height/2])
        union() {
            for(i = [0:(2*height/pitch)-1]) {
                translate([0, 0, i*pitch])	
                thread_turn(diameter, pitch, $fn);
            }
        }
        cylinder(d = diameter, h = height);
    }
}