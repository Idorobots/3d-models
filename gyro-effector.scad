$fn = 30;

HEIGHT = 60;
FAN_DIA = 40;

HOTEND_TOP_DIA = 15;
HOTEND_TOP_HEIGHT = 13;
HOTEND_BOT_DIA = 25;
HOTEND_BOT_HEIGHT = 30;

module hotend_radiator() {
  cylinder(h = HOTEND_BOT_HEIGHT, d = HOTEND_BOT_DIA);
}

module hotend() {
  union() {
    translate([0, 0, HOTEND_BOT_HEIGHT-10])
        cylinder(h = HOTEND_TOP_HEIGHT+20, d = HOTEND_TOP_DIA);

    hotend_radiator();

    translate([0, 0, -10])
        hotend_radiator();
  }
}

module long_cylinder(h, d, l, center) {
  hull() {
    translate([-l/2, 0, 0])
        cylinder(h = h, d = d, center = center);

    translate([l/2, 0, 0])
        cylinder(h = h, d = d, center = center);
  }
}

module hotend_channel(d, l, height, side) {
  union() {
    hull() {
      cylinder(h = HOTEND_BOT_HEIGHT, d = HOTEND_BOT_DIA);
      translate([0, 0, height + l/2])
          rotate([0, 90, 0])
          long_cylinder(h = side, l=l, d = d);
    }

    hull() {
      cylinder(h = HOTEND_BOT_HEIGHT, d = HOTEND_BOT_DIA);
      translate([0, 0, height + l/2])
          rotate([0, 90, 120])
          long_cylinder(h = side, l=l, d = d);
    }

    hull() {
      cylinder(h = HOTEND_BOT_HEIGHT, d = HOTEND_BOT_DIA);
      translate([0, 0, height + l/2])
          rotate([0, 90, 240])
          long_cylinder(h = side, l=l, d = d);
    }
  }
}

module fan_hole(side, height, depth) {
  side_delta = sqrt(2) * (height + FAN_DIA/2);
  dist = (side - side_delta) * sqrt(6)/6;
  h = (height + FAN_DIA/2) * sqrt(6)/3;

  translate([-dist, 0, h])
      rotate([45, atan(1/sqrt(2)), -120])
      cylinder(h = depth*2, d = FAN_DIA, center = true);
}

module vent_hole(d, l, offset) {
  translate([offset, 0, 0])
      rotate([0, 0, 90])
      long_cylinder(h = 2, d = d, l=l, center=true);
}

module hotend_vent(side, height) {
  fan_hole_depth = 1;
  fan_hole_height = height;

  union() {
    hotend_channel(5, 10, 5, side * 0.85 * 0.5);
    hull() {
      fan_hole(side, fan_hole_height, fan_hole_depth);
      hotend_radiator();
    }
  }
}

module part_vent(side, height) {
  fan_hole_depth = 1;
  fan_hole_height = height;

  vent_hole_dia = 7;
  vent_hole_length = 20;
  vent_hole_offset = -25;

  hull() {
    fan_hole(side, fan_hole_height, fan_hole_depth);
    vent_hole(vent_hole_dia, vent_hole_length, vent_hole_offset);
  }
}

module body(side) {
  limit = side * 0.85;

  intersection() {
    union() {
      translate([0, 0, -side * sqrt(3)/6])
          rotate([45, atan(1/sqrt(2)), 0])
          cube([side, side, side], center=true);

      cylinder(h = side*sqrt(3)/3, d = HOTEND_TOP_DIA * 2);
    }
    intersection() {
      sphere(d = limit);
      cylinder(h = HEIGHT, d = limit);
    }
  }
}

module effector() {
  margin = 10;
  side = 2 * FAN_DIA + 2 * margin;

  fan_hole_height = 5;

  difference() {
    body(side);

    hotend();
    hotend_vent(side, fan_hole_height);

    rotate([0, 0, 120])
    part_vent(side, fan_hole_height);

    rotate([0, 0, 240])
    part_vent(side, fan_hole_height);
  }
}

effector();
