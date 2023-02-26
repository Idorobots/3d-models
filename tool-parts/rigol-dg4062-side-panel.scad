WALL_THICKNESS = 1.5;
PANEL_THICKNESS = 5;

DIA_TOP = 10;
DIA_BOT = 14;

LENGTH = 153;
WIDTH = 45;
HEIGHT = 15;

BNC_HOLE_DIA = 13;
BNC_HOLES = 2;
BNC_HOLE_SPACING = 25;
BNC_HOLE_OFFSET = 20 + BNC_HOLE_SPACING/2;


$fn = 50;

module outline() {
    cylinder(d = DIA_BOT, h = HEIGHT);
    translate([0, 0, HEIGHT])
    cylinder(d1 = DIA_BOT, d2 = DIA_TOP, h = HEIGHT);
}

module unit(w = WIDTH - DIA_BOT, l = LENGTH - DIA_BOT) {
  hull() {
    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * w/2, j * l/2, 0])
        outline();
      }
    }
  }
}

module body() {
  union() {
    width = DIA_TOP/2;
    offset_w = -(WIDTH - DIA_BOT - width)/2;
    translate([offset_w, 0, 0])
    unit(w = width);

    length = (BNC_HOLES - 1) * BNC_HOLE_SPACING + BNC_HOLE_OFFSET/2 + 2 * WALL_THICKNESS;

    offset_l = -(LENGTH - DIA_BOT - length)/2;
    bend = offset_l + length/2 + BNC_HOLE_SPACING;

    hull() {
      translate([0, offset_l, 0])
      unit(l = length);

      #translate([offset_w, bend, 0])
      outline();
    }

    // This whole fillet is a giant mess.
    translate([offset_w, bend, 0])
    difference() {
      r = DIA_TOP/2 + DIA_BOT/2 + WALL_THICKNESS * 2 - 0.15;
      a = 12.6; // Should be asin(bend/something) :shrug:

      translate([-offset_w - DIA_TOP/2, 0, 0])
      cylinder(d = DIA_BOT/2, h = 2 * HEIGHT);
      #hull() {
        translate([r * cos(a), r * sin(a), 0])
        cylinder(d = DIA_TOP, h = HEIGHT);

        translate([r * cos(a), r * sin(a), 0])
        cylinder(d = DIA_TOP, h = HEIGHT);
      }
      #hull() {
        translate([r * cos(a), r * sin(a), HEIGHT])
        cylinder(d1 = DIA_TOP, d2 = DIA_BOT, h = HEIGHT);

        translate([r * cos(a), r * sin(a), HEIGHT])
        cylinder(d1 = DIA_TOP, d2 = DIA_BOT, h = HEIGHT);
      }
    }/**/
  }
}

module bnc_holes() {
  for(i = [0:BNC_HOLES-1]) {
    translate([0, BNC_HOLE_SPACING * i, 0])
    cylinder(d = BNC_HOLE_DIA, h = HEIGHT);
  }
}

module side_panel() {
  difference() {
    body();

    #translate([-WIDTH + DIA_BOT, 0, 0])
    unit();

    length = (BNC_HOLES - 1) * BNC_HOLE_SPACING + BNC_HOLE_OFFSET/2;
    placement = LENGTH - DIA_BOT - 2 * WALL_THICKNESS;
    #translate([DIA_BOT/2, -(placement - length)/2, -PANEL_THICKNESS])
    unit(WIDTH - 2 * DIA_BOT - 2 * WALL_THICKNESS, length);

    #translate([DIA_BOT/2, -(LENGTH - BNC_HOLE_OFFSET)/2, HEIGHT + PANEL_THICKNESS])
    bnc_holes();
  }
}

side_panel();
