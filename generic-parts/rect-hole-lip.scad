width = 33;
length = 105;
thickness = 4;
corner_dia = 4;

inner_width = width - 1;
inner_length = length - 1;

lip_width = 4;
lip_thickness = 1;

$fn = 100;

module rounded_rect(width, length, height, corner_dia) {
  hull() {
    for (i = [-1, 1]) {
      for (j = [-1, 1]) {
        translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2, 0])
        cylinder(d = corner_dia, h = height);
      }
    }
  }
}

difference() {
  union() {
    rounded_rect(width + 2 * lip_width, length + 2 * lip_width, lip_thickness, corner_dia);
    rounded_rect(width, length, lip_thickness + thickness, corner_dia);
  }

  rounded_rect(inner_width, inner_length, lip_thickness + thickness, corner_dia);
}
