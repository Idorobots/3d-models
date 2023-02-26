WALL_THICKNESS = 2;
PANEL_THICKNESS = 5;

DIA_TOP = 10;
DIA_BOT = 14;

LENGTH = 153;
WIDTH = 40;
HEIGHT = 15;

BNC_HOLE_DIA = 10;
BNC_HOLES = 2;
BNC_HOLE_SPACING = 20;
BNC_HOLE_OFFSET = 20 + BNC_HOLE_SPACING/2;


$fn = 30;

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

module bnc_holes() {
  for(i = [0:BNC_HOLES-1]) {
    translate([0, BNC_HOLE_SPACING * i, 0])
    cylinder(d = BNC_HOLE_DIA, h = HEIGHT);
  }
}

module side_panel() {
  difference() {
    unit();

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
