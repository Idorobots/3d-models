$fn = 30;

HEIGHT = 60;
FAN_DIA = 40;

HOTEND_TOP_DIA = 15;
HOTEND_TOP_HEIGHT = 13;
HOTEND_BOT_DIA = 25;
HOTEND_BOT_HEIGHT = 30;
HOTEND_BOT_LIP = 2;

module hotend_radiator() {
  translate([0, 0, HOTEND_BOT_LIP])
      cylinder(h = HOTEND_BOT_HEIGHT - HOTEND_BOT_LIP, d = HOTEND_BOT_DIA);
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
  hull() {
    hotend_radiator();
    translate([0, 0, height + l/2])
        rotate([0, 90, 0])
        long_cylinder(h = side, l=l, d = d);
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

module vent_hole(d, l) {
  long_cylinder(h = 0.01, d = d, l=l, center=true);
}

module hotend_vent(side, height) {
  fan_hole_depth = 1;
  fan_hole_height = height;

  union() {
    hotend_channel(5, 15, 5, side * 0.5);
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
  vent_hole_length = 15;
  vent_hole_offset = -25;

  hull() {
    fan_hole(side, fan_hole_height, fan_hole_depth);
    translate([-25, 0, 0])
        rotate([0, 0, 90])
        vent_hole(vent_hole_dia, vent_hole_length);
  }
}

module body(side, limit) {
  l = side * limit;

  union() {
    intersection() {
      translate([0, 0, -side * sqrt(3)/6])
          rotate([45, atan(1/sqrt(2)), 0])
          cube([side, side, side], center=true);
      sphere(d = l);
      cylinder(h = HEIGHT, d = l);
    }

    cylinder(h = side*sqrt(3)/3, d = HOTEND_TOP_DIA * 2);
  }
}

module magnetic_mount(diameter, depth, length, lip) {
  d = diameter + lip;

  difference() {
    hull() {
      cylinder(d = d, h = length-d/2);
      difference() {
        sphere(d = d, center=true);
        cylinder(d=d, h = d/2);
      }
    }

    translate([0, 0, length-depth-d/2])
        cylinder(d = diameter, h = depth + 1);
  }
}

module magnetic_mounts(side, distance, angle, height, length) {
  diameter = 10;
  depth = 3;
  lip = 3;
  off = (diameter + lip)/2;
  l = length + off;

  side_delta = sqrt(2) * (height + off);
  dist = (side - side_delta) * sqrt(6)/6;
  h = (height + off) * sqrt(6)/3;

  translate([-dist, 0, h])
  rotate([0, -angle, 0])
  union() {
    translate([0, -distance/2, 0])
        magnetic_mount(diameter, depth, l, lip);

    translate([0, distance/2, 0])
        magnetic_mount(diameter, depth, l, lip);

  }
}

module effector() {
  margin = 10;
  side = 2 * FAN_DIA + 2 * margin;

  fan_hole_height = 5;

  mount_distance = 56.5;
  mount_angle = 40;
  mount_length = 7;
  mount_height = 2;

  union() {
    difference() {
      body(side, 0.90);

      hotend();
      hotend_vent(side, fan_hole_height);

      rotate([0, 0, 120])
          part_vent(side, fan_hole_height);

      rotate([0, 0, 240])
          part_vent(side, fan_hole_height);
    }

    magnetic_mounts(side, mount_distance, mount_angle, mount_height, mount_length);

    rotate([0, 0, 120])
        magnetic_mounts(side, mount_distance, mount_angle, mount_height, mount_length);

    rotate([0, 0, 240])
        magnetic_mounts(side, mount_distance, mount_angle, mount_height, mount_length);
  }
}

effector();
