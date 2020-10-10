INNER_DIA_TOP = 5.8;
INNER_DIA_BOT = 6.2;
INNER_HEIGHT = 7;
SLOT_WIDTH = 2;

OUTER_DIA = 12;
OUTER_HEIGHT = 2.5;
INSET = 0.5;

$fn = 300;

color("lightyellow")
union() {
  difference() {
      intersection() {
    scale([1, 1, OUTER_HEIGHT/(OUTER_DIA/2)])
    sphere(d = OUTER_DIA);

    cylinder(d = OUTER_DIA, h = OUTER_HEIGHT);
  }
  cylinder(d1 = OUTER_DIA - INSET, d2 = 0, h = INSET);
  }

  translate([0, 0, INSET])
  difference() {
    translate([0, 0, -INNER_HEIGHT])
    cylinder(d1 = INNER_DIA_BOT, d2 = INNER_DIA_TOP, h = INNER_HEIGHT);

    cube(size = [max(INNER_DIA_TOP, INNER_DIA_BOT), SLOT_WIDTH, INNER_HEIGHT*2], center = true);
  }
}
