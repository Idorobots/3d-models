part = "top"; // top or bot

width = 41;
length = 107;
thickness = 1.5;
corner_dia = 5;

mount_width = 21;
mount_length = 69.5;
mount_height = 18;
mount_split_height = 8;
mount_pos = [4, 23.5];
mount_hole_dia = (part == "top") ? 4 : 3;
mount_hole_pos = [
  [12, 36.5],
  [12, 52],
  [12, 79]
];

hole_dia = 5.5;
hole_pos = [
  [9, 4],
  [37, 4],
  [37, 37],
  [20, 103],
  [37, 103]
];

usb_width = 13;
usb_height = 6;
usb_length = 30;
usb_z_offset = 2;
usb_sheeth_width = 14.5;
usb_sheeth_height = 8;
usb_sheeth_length = 19;
usb_tab_base_width = 17;
usb_tab_base_height = 9;
usb_tab_base_length = 9;
usb_tab_base_offset = 4.5;
usb_tabs_width = 26;
usb_tabs_height = 7;
usb_tabs_length = 4;
usb_tabs_offset = 10;
usb_pos = [
  [-2, 60],
  [-2, 72]
];

usbc_width = 9;
usbc_height = 3;
usbc_length = 27;
usbc_z_offset = 4;
usbc_sheeth_width = 12.5;
usbc_sheeth_height = 9.5;
usbc_sheeth_length = 21;
usbc_tabs_width = 31;
usbc_tabs_height = 9;
usbc_tabs_length = 6;
usbc_tabs_offset = 11;
usbc_pos = [
  [-2, 44],
  //[-2, 29]
];

usbc2_width = 9;
usbc2_height = 3;
usbc2_length = 27;
usbc2_z_offset = 4;
usbc2_sheeth_width = 15;
usbc2_sheeth_height = 9.5;
usbc2_sheeth_length = 25;
usbc2_tabs_width = 29;
usbc2_tabs_height = 9;
usbc2_tabs_length = 9;
usbc2_tabs_offset = 11;
usbc2_pos = [
  //[-2, 44],
  [-2, 29]
];

audio_width = 10.5;
audio_top_height = 6;
audio_top_offset = 8;
audio_top_length = 17.5;
audio_bot_height = audio_top_offset;
audio_bot_length = 10.5;
audio_base_width = 11;
audio_base_height = 5;
audio_base_length = 11.5;
audio_base_offset = -0.5;
audio_offset_z = -2;
audio_pos = [-2, 87];

button_width = 19;
button_length = 19;
button_offset = 7;
button_hole_dia = 2;
button_hole_pos = [
  [14, 109],
  [21, 123.5]
];

$fn = 60;

module rounded_rect(w, l, h, d) {
  hull() {
    for(i = [-1, 1]) {
     for(j = [-1, 1]) {
       translate([i*(w-d)/2, j*(l-d)/2, 0])
       cylinder(d = d, h = h);
     }
    }
  }
}

module base() {
  union() {
    translate([width/2, length/2, 0])
    rounded_rect(width, length, thickness, corner_dia);
    translate([mount_width/2 + mount_pos[0], mount_length/2 + mount_pos[1], 0])
    rounded_rect(mount_width, mount_length, mount_height, corner_dia);
    translate([button_width/2 + button_offset, (button_length + length)/2, 0])
    rounded_rect(button_width, button_length + length, thickness, corner_dia);
  }
}

module usb() {
  translate([usb_length, 0, usb_width/2 + usb_z_offset])
  rotate([0, -90, 0])
  union() {
    rounded_rect(usb_width, usb_height, usb_length, 1);
    rounded_rect(usb_sheeth_width, usb_sheeth_height, usb_sheeth_length, 1);
    translate([0, 0, usb_tab_base_offset])
    rounded_rect(usb_tab_base_width, usb_tab_base_height, usb_tab_base_length, 1);
    translate([0, 0, usb_tabs_offset])
    rounded_rect(usb_tabs_width, usb_tabs_height, usb_tabs_length, 1);
  }
}

module usbc() {
  translate([usbc_length, 0, usbc_width/2 + usbc_z_offset])
  rotate([0, -90, 0])
  union() {
    rounded_rect(usbc_width, usbc_height, usbc_length, 1);
    rounded_rect(usbc_sheeth_width, usbc_sheeth_height, usbc_sheeth_length, 1);
    translate([0, 0, usbc_tabs_offset])
    rounded_rect(usbc_tabs_width, usbc_tabs_height, usbc_tabs_length, 1);
  }
}

module usbc2() {
  translate([usbc2_length, 0, usbc2_width/2 + usbc2_z_offset])
  rotate([0, -90, 0])
  union() {
    rounded_rect(usbc2_width, usbc2_height, usbc2_length, 1);
    rounded_rect(usbc2_sheeth_width, usbc2_sheeth_height, usbc2_sheeth_length, 1);
    translate([0, 0, usbc2_tabs_offset])
    rounded_rect(usbc2_tabs_width, usbc2_tabs_height, usbc2_tabs_length, 1);
  }
}

module audio() {
  translate([0, 0, audio_offset_z])
  union() {
    translate([audio_top_length/2, 0, audio_top_offset])
    rounded_rect(audio_top_length, audio_width, audio_top_height, 1);
    translate([(audio_top_length - audio_bot_length/2), 0, 0])
    rounded_rect(audio_bot_length, audio_width, audio_bot_height, 1);
    translate([(audio_top_length - audio_bot_length/2) - audio_base_offset, 0])
    rounded_rect(audio_base_length, audio_base_width, audio_base_height, 1);
  }
}

module mount() {
  difference() {
    base();
    #for(p = hole_pos) {
      translate(p)
      cylinder(d = hole_dia, h = thickness);
    }
    #for(p = mount_hole_pos) {
      translate(p)
      cylinder(d = mount_hole_dia, h = mount_height);
    }
    #for(p = button_hole_pos) {
      translate(p)
      cylinder(d = button_hole_dia, h = thickness);
    }
    #for(p = usb_pos) {
      translate(p)
      usb();
    }
    #for(p = usbc_pos) {
      translate(p)
      usbc();
    }
    #for(p = usbc2_pos) {
      translate(p)
      usbc2();
    }

    #translate(audio_pos)
    audio();
  }
}

if(part == "top") {
  intersection() {
    mount();

    translate([width/2, length/2, mount_split_height])
    rounded_rect(width, length*2, mount_height, corner_dia);
  }
}
if(part == "bot") {
  intersection() {
    mount();

    translate([width/2, length/2, 0])
    rounded_rect(width, length*2, mount_split_height, corner_dia);
  }
}
