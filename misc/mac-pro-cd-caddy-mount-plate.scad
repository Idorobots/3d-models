$fn = 64;

plate_w = 140;
plate_h = 190;
plate_offset = 15;
thickness = 3;
corner_r = 5;

standoff_d = 8;
standoff_h = 0;
standoff_hole_d = 3;
standoff_hole_bot_h = 2;
standoff_hole_bot_d = 5.5;
standoff_holes = [
  [16,39],
  [16,122],
  [128,76],
  [128,166]
];

right_tab_w = 15;
right_tab_h = 100 - plate_offset;
right_tab_offset = plate_offset;
right_tab_thickness = thickness;
right_holes = [
  [150, 48],
];
right_hole_d = 5;

left_tab_w = 16;
left_tab_h = 190;
left_tab_offset = 0;
left_tab_thickness = 1.5;
left_holes = [
  [-11, 40],
  [-11,123],
];
left_hole_d = 7;

bottom_tab_w = plate_offset;
bottom_tab_h = plate_w + right_tab_w;
bottom_tab_thickness = 1.5;
bottom_holes = [
  [36.5,6],
  [111.5,6]
];
bottom_hole_d = 5;

module rounded_rect(w, h, r) {
  hull() {
    translate([r, r]) circle(r);
    translate([w-r, r]) circle(r);
    translate([r, h-r]) circle(r);
    translate([w-r, h-r]) circle(r);
  }
}

// square connection edge on left,
// rounded outer edge on right
module tab_shape(w, h, r) {
  hull() {
    translate([-r, 0]) square(0.01);
    translate([-r, h]) square(0.01);

    translate([w-r, r]) circle(r);
    translate([w-r, h-r]) circle(r);
  }
}

difference() {
  union() {
    linear_extrude(thickness)
    translate([0, plate_offset])
    rounded_rect(plate_w, plate_h, corner_r);

    translate([0, 0, thickness - right_tab_thickness])
    linear_extrude(right_tab_thickness)
    translate([plate_w, right_tab_offset])
    tab_shape(right_tab_w, right_tab_h, corner_r);

    translate([0, 0, thickness - bottom_tab_thickness])
    linear_extrude(bottom_tab_thickness)
    translate([0, plate_offset])
    rotate([0, 0, -90])
    tab_shape(bottom_tab_w, bottom_tab_h, corner_r);

    translate([0, 0, thickness - left_tab_thickness])
    linear_extrude(left_tab_thickness)
    translate([0, left_tab_h])
    rotate([0, 0, 180])
    tab_shape(left_tab_w, left_tab_h, corner_r);

    for (p =  standoff_holes)
    translate([p[0], p[1], 0])
      cylinder(h = thickness + standoff_h, d = standoff_d);
  }

  for (p = bottom_holes)
    translate([p[0], p[1], -0.1])
    hull() {
      cylinder(h = thickness + 0.2, d = bottom_hole_d);
      translate([0, -10, 0])
      cylinder(h = thickness + 0.2, d = bottom_hole_d);
    }

  for (p = left_holes)
    translate([p[0], p[1], -0.1])
    hull() {
      cylinder(h = thickness + 0.2, d = left_hole_d);
      translate([-10, 0, 0])
      cylinder(h = thickness + 0.2, d = left_hole_d);
    }

  for (p = right_holes)
    translate([p[0], p[1], -0.1])
      cylinder(h = thickness + 0.2, d = right_hole_d);

  for (p =  standoff_holes) {
    translate([p[0], p[1], -0.1])
      cylinder(h = standoff_hole_bot_h + 0.1, d = standoff_hole_bot_d);

    translate([p[0], p[1], -0.1])
      cylinder(h = thickness + standoff_h + 0.2, d = standoff_hole_d);
  }
}
