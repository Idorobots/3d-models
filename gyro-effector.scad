HEIGHT = 60;
FAN_DIA = 40;

HOTEND_TOP_DIA = 15;
HOTEND_TOP_HEIGHT = 13;
HOTEND_BOT_DIA = 30;
HOTEND_BOT_HEIGHT = 30;


module hotend_channel() {
  cylinder(h = HOTEND_BOT_HEIGHT, d = HOTEND_BOT_DIA);
}


module hotend() {
  union() {
    translate([0, 0, HOTEND_BOT_HEIGHT-10])
        cylinder(h = HOTEND_TOP_HEIGHT+20, d = HOTEND_TOP_DIA);

    hotend_channel();

    translate([0, 0, -10])
        hotend_channel();
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

module fan_hole(side, height, depth) {
  // FIXME Distance drifts a bit when given non-zero height.
  side_delta = sqrt(2) * (height + FAN_DIA/2);
  dist = (side - side_delta)*sqrt(6)/6;

  translate([-dist, 0, height + FAN_DIA/2])
      rotate([45, atan(1/sqrt(2)), -120])
      cylinder(h = depth*2, d = FAN_DIA, center = true);
}

module body(side) {
  limit = side * 0.95;

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

module cooler() {
  margin = 15;
  side = 2 * FAN_DIA + 2 * margin;
  fan_hole_depth = 4;
  fan_hole_height = 0;

  difference() {
    difference() {
      body(side);

      hotend();
    }

    hull() {
      fan_hole(side, fan_hole_height, fan_hole_depth);
      hotend_channel();
    }

    rotate([0, 0, 120])
        fan_hole(side, fan_hole_height, fan_hole_depth);

    rotate([0, 0, 240])
        fan_hole(side, fan_hole_height, fan_hole_depth);

  }
}

cooler();
