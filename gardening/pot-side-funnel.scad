HEIGHT = 20;
FUNNEL_HEIGHT = 15;
WIDTH = 60;
COVER_INNER_DIA = 160;
COVER_OUTER_DIA = 180;
POT_OUTER_DIA = 147;
POT_OUTER_LIP_DIA = 150;
POT_LIP_HEIGHT = 4;
POT_LIP_WIDTH = 6;


$fn = 200;

intersection() {
  difference() {
    union() {
        cylinder(d = COVER_INNER_DIA, h = HEIGHT);
        translate([0, 0, HEIGHT])
        cylinder(d1 = COVER_INNER_DIA, d2 = COVER_OUTER_DIA, h = FUNNEL_HEIGHT);
    }
    translate([-(COVER_INNER_DIA-POT_OUTER_DIA)/2, 0, 0])
    cylinder(d = POT_OUTER_DIA, h = HEIGHT - POT_LIP_HEIGHT/2);
    translate([-(COVER_INNER_DIA-POT_OUTER_DIA)/2, 0, HEIGHT + POT_LIP_HEIGHT/2])
    cylinder(d1 = POT_OUTER_DIA, d2 = POT_OUTER_DIA - POT_LIP_WIDTH, h = FUNNEL_HEIGHT);
    translate([-(COVER_INNER_DIA-POT_OUTER_DIA)/2, 0, HEIGHT - POT_LIP_HEIGHT/2])
    cylinder(d1 = POT_OUTER_DIA, d2 = POT_OUTER_LIP_DIA, h = POT_LIP_HEIGHT/2);
    translate([-(COVER_INNER_DIA-POT_OUTER_DIA)/2, 0, HEIGHT])
    cylinder(d2 = POT_OUTER_DIA, d1 = POT_OUTER_LIP_DIA, h = POT_LIP_HEIGHT/2);
  }

  #translate([0, -WIDTH/2, 0])
  cube(size = [COVER_INNER_DIA, WIDTH, HEIGHT + FUNNEL_HEIGHT]);
}
