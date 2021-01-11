BOLT_DIA = 5.2;
BOLT_HEAD_DIA = 8.7;
BOLT_HEAD_LENGTH = 5;

TOP_DIA = 15;
TOP_THICKNESS = 2;
TOP_HEIGHT = BOLT_HEAD_LENGTH + TOP_THICKNESS * 2;

SLEEVE_OUTER_DIA = TOP_DIA;
SLEEVE_INNER_DIA = BOLT_DIA + 0.6;
SLEEVE_LENGTH = 20;

BOTTOM_HOLE_DIA = BOLT_DIA - 0.4;
BOTTOM_INNER_DIA = SLEEVE_OUTER_DIA + 0.6;
BOTTOM_OUTER_DIA = BOTTOM_INNER_DIA + 3;
BOTTOM_HEIGHT = 30;

MAGNET_DIA = 15;
MAGNET_THICKNESS = 3;

$fn = 100;

module sleeve() {
  difference() {
    cylinder(d = SLEEVE_OUTER_DIA, h = SLEEVE_LENGTH);
    cylinder(d = SLEEVE_INNER_DIA, h = SLEEVE_LENGTH);
  }
}

module top() {
  difference() {
    cylinder(d = TOP_DIA, h = TOP_HEIGHT);
    cylinder(d = BOLT_DIA, h = TOP_HEIGHT);
    cylinder(d = BOLT_HEAD_DIA, h = TOP_HEIGHT - TOP_THICKNESS);
  }
}

module bottom() {
  difference() {
    cylinder(d = BOTTOM_OUTER_DIA, h = BOTTOM_HEIGHT);
    cylinder(d = BOTTOM_HOLE_DIA, h = BOTTOM_HEIGHT);
    cylinder(d = BOTTOM_INNER_DIA, h = SLEEVE_LENGTH);
    translate([0, 0, BOTTOM_HEIGHT - MAGNET_THICKNESS])
    cylinder(d = MAGNET_DIA, h = MAGNET_THICKNESS);
  }
}


bottom();
!top();
sleeve();