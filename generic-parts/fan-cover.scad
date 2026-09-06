// 120x120x25 mm fan cage with rounded corners and mounting pegs

fan_size = 120;
fan_depth = 26;

clearance = 1;
wall = 1.2;
bottom = 3;

corner_r = 4;

peg_base_d = 8;
peg_base_h = 0.5;
peg_d = 4.0;
peg_h = 4.5;

// Standard 120 mm fan mounting-hole spacing
hole_spacing = 105;

inner = fan_size + 2 * clearance;
outer = inner + 2 * wall;

$fn = 64;

module rounded_square(size, r) {
    offset(r = r)
        square([size - 2*r, size - 2*r], center = true);
}

module fan_cage() {
    difference() {
        // Outer body
        linear_extrude(height = fan_depth + bottom)
            rounded_square(outer, corner_r);

        // Inner fan cavity
        translate([0, 0, bottom])
            linear_extrude(height = fan_depth + 0.2)
                rounded_square(inner, max(0.1, corner_r - wall));
    }

    // Pegs aligned to standard 120 mm fan holes
    for (x = [-hole_spacing/2, hole_spacing/2])
    for (y = [-hole_spacing/2, hole_spacing/2])
        translate([x, y, bottom]) {
            cylinder(h = peg_h, d = peg_d);
            cylinder(h = peg_base_h, d = peg_base_d);
        }
}

fan_cage();
