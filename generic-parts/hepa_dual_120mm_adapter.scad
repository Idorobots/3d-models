/*
  HEPA filter to dual 120 mm fan adapter
  Filter: 134 x 268 x 32 mm
  Transition duct: 20 mm long
  Split: two mirrored printable halves along the horizontal centerline

  Coordinate system:
    X = filter/fan width
    Y = filter/fan height
    Z = airflow direction, fan side at z=0, filter pocket at z=duct_len

  Print one top_half and one bottom_half, or set part="both" to preview assembly.
*/

$fn = 96;

// ---------- Main parameters ----------
part = "both";            // "top", "bottom", "split", or "both"

filter_w = 132;
filter_h = 266;
filter_depth = 31;
filter_clearance = 1.0;   // extra clearance around filter

wall = 2.0;
face_thickness = 2.0;
duct_len = 25;

fan_size = 120;
fan_opening_d = 120;      // circular airflow opening for each 120 mm fan
fan_mount_spacing = 105;  // common 120 mm PC fan screw spacing
fan_mount_d = 5.0;
fan_centers_y = [-61.5, 61.5];

side_mount_d = 5.0;       // requested holes on the short sides
side_mount_spacing = 100; // requested spacing between the pair of holes
side_mount_edge_offset = 10;

split_gap = 0.6;          // clearance between printed halves in preview
corner_r = 5;

// ---------- Derived dimensions ----------
inner_w = filter_w + filter_clearance;
inner_h = filter_h + filter_clearance;
outer_w = inner_w + 2*wall;
outer_h = inner_h + 2*wall;
total_z = face_thickness + duct_len + filter_depth;
filter_z0 = face_thickness + duct_len;

// ---------- Helpers ----------
module rounded_rect_2d(w, h, r) {
    offset(r=r)
        square([w - 2*r, h - 2*r], center=true);
}

module slot_rect_3d(w, h, z0, z1, r=3) {
    translate([0, 0, z0])
        linear_extrude(height=z1-z0)
            rounded_rect_2d(w, h, r);
}

module split_keep(which="top") {
    // Large clipping boxes. The gap is only for preview/clearance at the seam.
    if (which == "top") {
        translate([-500, split_gap/2, -50]) cube([1000, 1000, 300], center=false);
    } else if (which == "bottom") {
        translate([-500, -1000 - split_gap/2, -50]) cube([1000, 1000, 300], center=false);
    } else if (which == "split") {
        translate([outer_w/2, 0, 0])
        cube([outer_w, split_gap, outer_h * 2], center = true);
    }
}

// ---------- Solid bodies ----------
module outer_transition() {
    // Smooth outside transition from fan face to filter pocket.
    hull() {
        translate([0, 0, 0])
            linear_extrude(height=0.2)
                rounded_rect_2d(outer_w, outer_h, corner_r);
        translate([0, 0, filter_z0])
            linear_extrude(height=0.2)
                rounded_rect_2d(outer_w, outer_h, corner_r);
    }
}

module filter_pocket_outer() {
    // Sleeve that wraps around the HEPA filter for its 32 mm depth.
    slot_rect_3d(outer_w, outer_h, filter_z0, filter_z0 + filter_depth, corner_r);
}

module airflow_void() {
    // Transition void from two round fan openings into the rectangular filter opening.
    hull() {
        for (cy = fan_centers_y)
            translate([0, cy, face_thickness])
            linear_extrude(height=0.4)
                rounded_rect_2d(fan_size, fan_size, corner_r);

        translate([0, 0, filter_z0 + 5])
            linear_extrude(height=0.4)
                rounded_rect_2d(inner_w, inner_h, 2);
    }
    for (cy = fan_centers_y)
        translate([0, cy, -0.5])
            linear_extrude(height=face_thickness + 0.5)
                circle(d=fan_opening_d);

    translate([0, 0, -0.5])
    linear_extrude(height = face_thickness + 0.5)
    rounded_rect_2d(fan_mount_spacing - 10, abs(fan_centers_y[0] - fan_centers_y[1]), corner_r);

    // Continue the rectangular void through the filter sleeve.
    slot_rect_3d(inner_w, inner_h, filter_z0 - 1, filter_z0 + filter_depth + 1, 2);
}

module fan_mount_holes() {
    // Optional/standard PC fan holes on the fan face.
    #for (cy = fan_centers_y)
        for (sx = [-1, 1])
            for (sy = [-1, 1])
                translate([sx*fan_mount_spacing/2, cy + sy*fan_mount_spacing/2, -2])
                    cylinder(d=fan_mount_d, h=face_thickness + 8);
}

module side_mount_holes() {
    // Holes on both short sides, 4 mm dia, 100 mm apart.
    // These pass through the top and bottom lips of the rectangular frame.
    #for (y_side = [-1, 1])
        for (xpos = [-side_mount_spacing/2, side_mount_spacing/2])
            translate([xpos, y_side*(outer_h/2) + total_z/2, side_mount_edge_offset])
              rotate([90, 0, 0])
                cylinder(d=side_mount_d, h=total_z + 4);
}

module seam_alignment_features() {
    // Simple printable alignment pins/sockets at the center split.
    #for (x_side = [-1, 1])
            translate([x_side*(outer_w/2-4), 0, 5])
              rotate([90, 0, 0])
                translate([0, 0, -total_z/2])
                cylinder(d=4, h=total_z);
}

module full_adapter() {
    difference() {
        union() {
            outer_transition();
            filter_pocket_outer();
        }
        #airflow_void();
        fan_mount_holes();
        side_mount_holes();
        seam_alignment_features();
    }
}

module adapter_half(which="top") {
    intersection() {
        full_adapter();
        split_keep(which);
    }
}

// ---------- Output ----------
if (part == "top") {
    adapter_half("top");
} else if (part == "bottom") {
    adapter_half("bottom");
} else if (part == "split") {
    adapter_half("split");
} else {
    adapter_half("top");
    adapter_half("bottom");
}
