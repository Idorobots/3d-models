INNER_DIA_TOP_1 = 320;
INNER_DIA_TOP_2 = 315;
INNER_DIA_BOT_1 = 290;
INNER_DIA_BOT_2 = 280;
INNER_DEPTH = 25;
OUTER_DIA = 330;
OUTER_DEPTH = INNER_DEPTH;

WIDTH = 50;

$fn = 100;

module holder() {
  intersection() {
    difference() {
      cylinder(d = OUTER_DIA, h = OUTER_DEPTH);

      #union() {
        translate([0, 0, INNER_DEPTH/2])
        cylinder(d2 = INNER_DIA_TOP_1, d1 = INNER_DIA_TOP_2, h = INNER_DEPTH/2);
        cylinder(d2 = INNER_DIA_BOT_1, d1 = INNER_DIA_BOT_2, h = INNER_DEPTH/2);
      }
    }

    translate([-WIDTH/2, 0, 0])
    cube(size = [WIDTH, OUTER_DIA, max(INNER_DEPTH, OUTER_DEPTH)]);
  }
}

holder();
