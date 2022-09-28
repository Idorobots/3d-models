PORT_LENGTH = 18;
PORT_DIA = 11.5;

WALL_THICKNESS = 1.5;
CAP_DIA = PORT_DIA + 2 * WALL_THICKNESS;
CAP_LENGTH = PORT_LENGTH + CAP_DIA/2;

TOP_DIA = PORT_DIA - 2 * WALL_THICKNESS;
TOP_THICKNESS = 2 * WALL_THICKNESS;
TOP_HOLE_DIA = 4;

$fn = 50;

module port() {
  cylinder(d = PORT_DIA, h = PORT_LENGTH);
}

module top() {
  difference() {
    hull() {
      rotate([90, 0, 0])
      cylinder(d = TOP_DIA, h = TOP_THICKNESS, center = true);
      translate([0, 0, -TOP_DIA])
      sphere(d = TOP_DIA);
    }
    rotate([90, 0, 0])
    cylinder(d = TOP_HOLE_DIA, h = CAP_DIA, center = true);
  }
}

module cap() {
  difference() {
    union() {
      cylinder(d = CAP_DIA, h = CAP_LENGTH - CAP_DIA/2);
      translate([0, 0, CAP_LENGTH - CAP_DIA/2])
      sphere(d = CAP_DIA);
      translate([0, 0, CAP_LENGTH])
      top();
    }
    port();
  }
}

cap();
