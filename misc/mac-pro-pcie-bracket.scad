wall_thickness = 2;
bottom_thickness = wall_thickness;

bracket_inner_width = 45;
bracket_inner_length = 151;
bracket_width = bracket_inner_width + 2 * wall_thickness;
bracket_length = bracket_inner_length + wall_thickness;
bracket_height = 18;

bracket_rounding_dia = 40;
bracket_rounding_offset = [0, 16, 20];

bracket_lip_width = 8;
bracket_lip_length = bracket_length - bracket_rounding_offset[1] - 25;
bracket_lip_thickness = 1;
bracket_lip_offset = [0, bracket_rounding_offset[1]];
bracket_lip_both_sides = false;

opening_dia = 4;
opening_width = 33;
opening_length = 105;

opening_offset = [(bracket_width-opening_width)/2 - 0.5, bracket_length-opening_length-11.5];

mobo_shield_lip_dia = 2;

mount_hole_dia = 2;
mount_hole_spacing = [43.5, 116];
mount_hole_offset = [bracket_width-mount_hole_spacing[0]/2 - 3.5, bracket_length-mount_hole_spacing[1]/2 - 6];


$fn = 100;

module mount_holes(width, length, height, dia) {
    for (i = [-1, 1]) {
      for (j = [-1, 1]) {
        translate([i * width/2, j * length/2, 0])
        cylinder(d = dia, h = height);
      }
    }
}

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    mount_holes(width - corner_dia, length - corner_dia, height, corner_dia);
  }
}

module bracket_mask() {
    union() {
      translate(bracket_rounding_offset)
      rotate([0, 90, 0])
      cylinder(d = bracket_rounding_dia, h = bracket_width);
      translate([-bracket_lip_width + bracket_lip_offset[0], bracket_lip_offset[1]])
      cube([bracket_width + 2 * bracket_lip_width, bracket_length, bracket_height]);
    }
}

module bracket() {
  intersection() {
    union() {
      cube([bracket_width, bracket_length, bracket_height]);
      translate([-bracket_lip_width + bracket_lip_offset[0], bracket_lip_offset[1]])
      cube([bracket_width + (bracket_lip_both_sides ? 2 : 1) * bracket_lip_width, bracket_lip_length, bracket_lip_thickness]);
    }
    #bracket_mask();
  }
}

module mobo_shield() {
  translate([wall_thickness, wall_thickness, bottom_thickness])
  difference() {
    intersection() {
      cube([bracket_inner_width, bracket_inner_length, bracket_height + bottom_thickness]);
      bracket_mask();
    }

    for(i = [0, 1]) {
      translate([i * bracket_inner_width, 0, bracket_height - bottom_thickness])
      rotate([-90, 0, 0])
      cylinder(d = mobo_shield_lip_dia, h = bracket_length);
    }
  }
}

module opening() {
  translate(opening_offset)
  translate([opening_width/2, opening_length/2, -bottom_thickness])
  rounded_rect(opening_width, opening_length, 2 * bottom_thickness, opening_dia);
}

module mounts() {
  translate(mount_hole_offset)
  mount_holes(mount_hole_spacing[0], mount_hole_spacing[1], bracket_height/2, mount_hole_dia);
}

difference() {
  bracket();
  #mobo_shield();
  #opening();
  #mounts();
}
