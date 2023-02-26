WALL_THICKNESS = 1.5;
PANEL_THICKNESS = 5;

DIA_TOP = 8;
DIA_BOT = 14;

LENGTH = 154;
WIDTH = 45;
HEIGHT = 15;

BNC_HOLE_DIA = 13;
BNC_HOLES = 2;
BNC_HOLE_SPACING = 35;
BNC_HOLE_OFFSET = 26 + BNC_HOLE_SPACING/2;

TOP_BAR = false;

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

    if(TOP_BAR) {
      translate([offset_w, 0, 0])
      unit(w = width);
    }

    length = (BNC_HOLES - 1) * BNC_HOLE_SPACING + BNC_HOLE_OFFSET/2 + 2 * WALL_THICKNESS;

    offset_l = -(LENGTH - DIA_BOT - length)/2;
    bend = offset_l + length/2 + BNC_HOLE_SPACING;

    hull() {
      translate([0, offset_l, 0])
      unit(l = length);

      #translate([offset_w, bend, 0])
      outline();
    }
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
