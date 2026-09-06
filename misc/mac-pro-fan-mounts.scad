// Mac Pro intake fan mount

$fn = 60;

part = "top"; // bottom or top

module macpro_mount_holes(
    hole_d = 4,
    slot_len = 15,
    thickness = 10,
    bot_spacing_x = 34,
    bot_spacing_y = 12,
    bot_n_holes = 6,
    bot_offset_y = 30,
    top_spacing_x = 80,
    top_offset_y = 6,
    top_offset_z = 310

) {
    for (y = [0, bot_spacing_y]) {
        for (i = [0:bot_n_holes - 1]) {
            x = i * bot_spacing_x - (bot_n_holes-1)/2*bot_spacing_x;
            translate([x, y + bot_offset_y, 0])
            hull() {
              translate([-(slot_len-hole_d)/2, 0, 0])
              cylinder(d = hole_d, h = thickness);
              translate([(slot_len-hole_d)/2, 0, 0])
              cylinder(d = hole_d, h = thickness);
            }
        }
    }

    for (x = [-top_spacing_x/2, top_spacing_x/2]) {
        translate([x, top_offset_y, top_offset_z - thickness])
            hull() {
              translate([-(slot_len-hole_d)/2, 0, 0])
              cylinder(d = hole_d, h = thickness);
              translate([(slot_len-hole_d)/2, 0, 0])
              cylinder(d = hole_d, h = thickness);
            }
    }
}

module rounded_rect(w, l, h, r) {
    linear_extrude(height = h)
        offset(r = r)
            offset(delta = -r)
                square([w, l]);
}

module fan_assembly(
    w = 271,
    h = 137,
    t = 60,
    r = 5,
    hole_d = 4,
    hole_slot_h = 10,
    hole_spacing = 100,
    hole_from_top = 50,
    assembly_offset_x = 20,
    assembly_offset_z = 16
) {
  translate([-h/2 + assembly_offset_x, 0, assembly_offset_z])
  rotate([0, -90, -90])
    union() {
        rounded_rect(w, h, t, r);


        for (x = [0, w]) {
            for (z = [
                (h - hole_spacing)/2,
                (h - hole_spacing)/2 + hole_spacing
            ]) {
                translate([x, z, hole_from_top])
                    rotate([0, 90, 0])
                        cylinder(
                            h = 20,
                            d = hole_d,
                            center = true,
                            $fn = 32
                        );
            }
        }
    }
}

module bot_mount_holes(
  dia = 6,
  height = 16,
  head_dia =11,
  head_height = 2.5,
  spacing = 100,
  offset_x = 20,
  offset_y = 50
) {
  for(x = [-spacing/2, spacing/2]) {
    translate([x + offset_x, offset_y, 0]) {
      cylinder(d = head_dia, h = head_height);
      cylinder(d = dia, h = height);
    }
  }
}

module bot_mount(
  base_thickness = 1,
  base_width = 20,
  base_length = 115,
  base_offset_y = 35,
  standoff_dia = 15,
  standoff_spacing = 100,
  standoff_height = 16,
  standoff_offset_y = 50,
  cushion_dia = 12,
  cushion_height = 1,
  offset_x = 20,
  r = 5
) {
  for(x = [-standoff_spacing/2, standoff_spacing/2]) {
    translate([x + offset_x, standoff_offset_y, 0])
    difference() {
      cylinder(d = standoff_dia, h = standoff_height);
      translate([0, 0, standoff_height - cushion_height])
      cylinder(d = cushion_dia, h = cushion_height);
    }
  }

  hull() {
    translate([-base_length/2 + offset_x, -base_width/2 + base_offset_y, 0])
    rounded_rect(base_length, base_width, base_thickness, r);
    for(x = [-standoff_spacing/2, standoff_spacing/2]) {
      translate([x + offset_x, standoff_offset_y, 0])
      cylinder(d = standoff_dia, h = base_thickness);
    }
  }
}

module top_mount_holes(
  dia = 6,
  height = 16,
  head_dia =11,
  head_height = 2.5,
  spacing = 100,
  offset_x = 20,
  offset_y = 50,
  offset_z = 310
) {
  for(x = [-spacing/2, spacing/2]) {
    translate([x + offset_x, offset_y, offset_z - height]) {
      translate([0, 0, height-head_height])
      cylinder(d = head_dia, h = head_height);
      cylinder(d = dia, h = height);
    }
  }
}

module top_mount(
  base_thickness = 2.5,
  base_width = 20,
  base_length = 110,
  base_offset_y = 10,
  standoff_dia = 15,
  standoff_spacing = 100,
  standoff_height = 16,
  standoff_offset_y = 50,
  cushion_dia = 12,
  cushion_height = 1,
  offset_x = 20,
  offset_z = 310,
  r = 5
) {
  for(x = [-standoff_spacing/2, standoff_spacing/2]) {
    translate([x + offset_x, standoff_offset_y, offset_z-standoff_height])
    difference() {
      cylinder(d = standoff_dia, h = standoff_height);
      cylinder(d = cushion_dia, h = cushion_height);
    }
  }

  hull() {
    translate([-base_length/2, -base_width/2 + base_offset_y, offset_z - base_thickness])
    rounded_rect(base_length, base_width, base_thickness, r);
    for(x = [-standoff_spacing/2, standoff_spacing/2]) {
      translate([x + offset_x, standoff_offset_y, offset_z-base_thickness])
      cylinder(d = standoff_dia, h = base_thickness);
    }
  }
}

if (part == "bottom") {
  difference() {
    bot_mount();
    #fan_assembly();
    #macpro_mount_holes();
    #bot_mount_holes();
  }
}

if (part == "top") {
  difference() {
    top_mount();
    #fan_assembly();
    #macpro_mount_holes();
    #top_mount_holes();
  }
}
