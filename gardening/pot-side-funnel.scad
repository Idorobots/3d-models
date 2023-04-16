HEIGHT = 15;
FUNNEL_HEIGHT = 15;
WIDTH = 100;
COVER_INNER_DIA = 160;
COVER_OUTER_DIA = 180;
POT_OUTER_DIA = 145;


$fn = 100;

intersection() {
  difference() {
    union() {
        cylinder(d = COVER_INNER_DIA, h = HEIGHT);
        translate([0, 0, HEIGHT])
        cylinder(d1 = COVER_INNER_DIA, d2 = COVER_OUTER_DIA, h = FUNNEL_HEIGHT);
    }
    translate([-(COVER_INNER_DIA-POT_OUTER_DIA)/2, 0, 0])
    cylinder(d = POT_OUTER_DIA, h = HEIGHT + FUNNEL_HEIGHT);
  }

  #translate([0, -WIDTH/2, 0])
  cube(size = [COVER_INNER_DIA, WIDTH, HEIGHT + FUNNEL_HEIGHT]);
}
