// Configurable hollow cylinder holder array
// Units: millimeters

$fn = 96;

// ---------- Main parameters ----------
rows = 3;               // number of rows
cols = 3;               // number of columns
holder_od = 21.5;       // outside diameter of each holder
holder_height = 15;     // height above the top of the base
gap = 15;               // edge-to-edge spacing between holders
wall = 2.0;              // cylinder wall thickness
base_thickness = 3.0;   // base plate thickness
join_overlap = 0.20;      // small overlap to fuse holders to base
base_margin = 5.0;      // plate margin beyond holder outer edges
corner_radius = 4.0;    // base plate corner radius

// ---------- Derived dimensions ----------
holder_id = holder_od - 2*wall;
pitch = holder_od + gap;  // center-to-center spacing
base_x = cols*holder_od + (cols-1)*gap + 2*base_margin;
base_y = rows*holder_od + (rows-1)*gap + 2*base_margin;

assert(rows >= 1 && cols >= 1, "rows and cols must be at least 1");
assert(wall > 0 && wall < holder_od/2, "wall must be > 0 and less than holder radius");
assert(gap >= 0, "gap must be non-negative");
assert(corner_radius >= 0 && corner_radius <= min(base_x, base_y)/2,
       "corner_radius is too large for the base size");

// Rounded rectangular plate with exact outer X/Y dimensions.
module rounded_plate(x, y, h, r) {
    if (r <= 0) {
        cube([x, y, h]);
    } else {
        hull() {
            for (px = [r, x-r])
                for (py = [r, y-r])
                    translate([px, py, 0])
                        cylinder(h=h, r=r);
        }
    }
}

// Open-top hollow cylindrical shell.
// The cavity stops at the top face of the base, so the base acts as the bottom.
module hollow_holder(od, h, wall) {
    difference() {
        cylinder(d=od, h=h);
        translate([0, 0, -0.1])
            cylinder(d=od - 2*wall, h=h + 0.2);
    }
}

union() {
    // Base plate
    rounded_plate(base_x, base_y, base_thickness, corner_radius);

    // Holder grid
    for (r = [0 : rows-1])
        for (c = [0 : cols-1]) {
            x = base_margin + holder_od/2 + c*pitch;
            y = base_margin + holder_od/2 + r*pitch;

            translate([x, y, base_thickness - join_overlap])
                hollow_holder(holder_od, holder_height + join_overlap, wall);
        }
}
