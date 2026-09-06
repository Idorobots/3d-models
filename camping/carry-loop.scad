/*
Simple Two-Ring Carry Loop
Units: millimeters

bar_length = clear distance between the OUTER edges of the two rings.
The bar overlaps each ring slightly so the exported STL is one solid.
*/

// ---------- Configurable dimensions ----------

// Ring 1
ring1_id = 26;       // inside diameter
ring1_od = 35;       // outside diameter

// Ring 2
ring2_id = 10;       // inside diameter
ring2_od = 20;       // outside diameter

// Connecting bar
bar_length = 10;     // clear span between ring outer edges
bar_width  = 15;     // width of bar in the XY plane

// Whole part
thickness = 0.6;       // Z thickness

// Circle smoothness
$fn = 50;


// ---------- Internal settings ----------

// Small overlap ensures the bar and rings form one manifold solid.
join_overlap = 4.0;


// ---------- Validation ----------

assert(ring1_id > 0, "ring1_id must be > 0");
assert(ring2_id > 0, "ring2_id must be > 0");
assert(ring1_od > ring1_id, "ring1_od must be greater than ring1_id");
assert(ring2_od > ring2_id, "ring2_od must be greater than ring2_id");
assert(bar_length >= 0, "bar_length must be >= 0");
assert(bar_width > 0, "bar_width must be > 0");
assert(thickness > 0, "thickness must be > 0");

r1 = ring1_od / 2;
r2 = ring2_od / 2;

// Place ring 1 at x=0.
// Ring 2 is positioned so the clear OD-to-OD gap equals bar_length.
ring2_x = r1 + bar_length + r2;


// ---------- Geometry ----------

module ring(od, id, h) {
    difference() {
        cylinder(d = od, h = h);
        translate([0, 0, -0.01])
            cylinder(d = id, h = h + 0.02);
    }
}

module carry_loop() {
    union() {
        // Ring 1
        ring(ring1_od, ring1_id, thickness);

        // Ring 2
        translate([ring2_x, 0, 0])
            ring(ring2_od, ring2_id, thickness);

        // Connecting bar.
        // It extends join_overlap into each ring for a reliable union.
        translate([
            r1 - join_overlap,
            -bar_width / 2,
            0
        ])
            cube([
                bar_length + 2 * join_overlap,
                bar_width,
                thickness
            ]);
    }
}

carry_loop();
