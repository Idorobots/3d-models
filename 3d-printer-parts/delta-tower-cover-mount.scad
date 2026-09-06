// Reference geometry for boolean design
// Units: mm

$fn = 120;

// --------------------
// Parameters
// --------------------

extrusion_size = 20.5;
slot_width = 6;
slot_depth = 1.5;
center_bore_d = 5;

cover_radius = 50;
cover_thickness = 1;
cover_height = 60;       // vertical extent of reference section

mount_tab_spacing = 42;

part_depth = 15;          // extrusion depth for preview/reference bodies


rods = true;
rod_dia = 10;
rod_spacing = mount_tab_spacing;
rod_offset_x = 2.5;

// --------------------
// Preview layout
// --------------------

reference_scene();


// --------------------
// Scene
// --------------------

module reference_scene() {
  difference() {
    linear_extrude(part_depth)
    translate([-5, 0, 0])
    rounded_rect(16, 45, 1, true);

    #extrusion_20x20();

    #translate([36.5, 0, 0])
    rounded_cover_2d();

    #translate([rod_offset_x, 0, 0])
    rods();
  }
}

module rods() {
  for(i = [-1, 1]) {
    translate([0, i * rod_spacing/2])
    cylinder(d = rod_dia, h = part_depth);
  }
}

// --------------------
// 20x20 extrusion
// centered at origin
// --------------------

module extrusion_20x20() {
  linear_extrude(part_depth)
  difference() {
    square([extrusion_size, extrusion_size], center = true);

    // Four 6 mm slots
    translate([0, extrusion_size/2 - slot_depth/2])
    slot_cutout(slot_width, slot_depth);

    rotate(90)
    translate([0, extrusion_size/2 - slot_depth/2])
    slot_cutout(slot_width, slot_depth);

    rotate(180)
    translate([0, extrusion_size/2 - slot_depth/2])
    slot_cutout(slot_width, slot_depth);

    rotate(270)
    translate([0, extrusion_size/2 - slot_depth/2])
    slot_cutout(slot_width, slot_depth);
  }
}

module slot_cutout(w, d) {
    rounded_rect(w, d * 2, 1.2, center = true);
}


// --------------------
// Rounded cover shell
// 1 mm thick, radius 70
// open on the right side
// --------------------

module rounded_cover_2d() {
  linear_extrude(part_depth)
    intersection() {
    difference() {
        circle(r = cover_radius + 20);
        circle(r = cover_radius - cover_thickness);
    }

    // Keep only left-side arc section
    polygon([
        [0, -cover_height],
        [-cover_radius - 20, -cover_height],
        [-cover_radius - 20, cover_height],
        [0, cover_height]
    ]);
  }

  // mount tab center markers, 42 mm apart
  for (y = [-mount_tab_spacing/2 - 5, mount_tab_spacing/2 + 5])
    hull() {
      translate([-60, y, 0])
      cylinder(h = part_depth, d = 10);
      translate([0, y, 0])
      cylinder(h = part_depth, d = 10);
    }
}


// --------------------
// Helpers
// --------------------

module rounded_rect(w, h, r, center = false) {
  translate(center ? [-w/2, -h/2] : [0, 0])
  hull() {
    translate([r, r]) circle(r = r);
    translate([w-r, r]) circle(r = r);
    translate([r, h-r]) circle(r = r);
    translate([w-r, h-r]) circle(r = r);
  }
}
