wall = 2.0;

part = "top"; // top, bot

adapter_thickness = 4;
fan_thickness = 45;
adapter_face_thickness = 6;

hepa_corner_d = 10;
hepa_h = 58 + fan_thickness;
hepa_w = 133 + 2*wall;
hepa_l = 267 + 2*wall;

cover_thickness = 1.2;
cover_corner_d = 20 - cover_thickness;
cover_h = hepa_h + adapter_face_thickness;
cover_w = hepa_w;
cover_l = hepa_l + 2 * adapter_thickness;

side_mount_d = 6.5;
side_mount_spacing = 100;
side_mount_edge_offset = 10 + fan_thickness;


$fn = 50;

module rounded_rect(w, l, h, d) {
  linear_extrude(h = h)
  offset(r=d/2)
  square([w - d, l - d], center=true);
}

module side_mount_holes() {
  for (i = [-1, 1])
    translate([i * side_mount_spacing/2, cover_l/2 + 5, side_mount_edge_offset])
    rotate([90, 0, 0])
    cylinder(d=side_mount_d, h=cover_l + 10);
}

module hepa() {
  rounded_rect(hepa_w, hepa_l, hepa_h, hepa_corner_d);
  rounded_rect(hepa_w + 10, hepa_l - 2, hepa_h, hepa_corner_d);
}

module adapter() {
  difference() {
    translate([0, 0, -adapter_face_thickness])
    rounded_rect(cover_w, cover_l, cover_h, cover_corner_d);
    #hepa();
    #side_mount_holes();
  }
}

module split_keep(which="top") {
    // Large clipping boxes. The gap is only for preview/clearance at the seam.
    if (which == "top") {
        translate([-500, 0, -50]) cube([1000, 1000, 300], center=false);
    } else if (which == "bot") {
        translate([-500, -1000 - 0, -50]) cube([1000, 1000, 300], center=false);
    }
}


intersection() {
  adapter();
  split_keep(part);
}
