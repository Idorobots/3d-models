HEIGHT = 1.2;
OUTER_DIA = 69.5;
INNER_DIA = 64;

RIM_HEIGHT = 3;
RIM_INNER_DIA = 68;

$fn = 500;

color("lightyellow")
intersection() {
difference() {
  union() {
    cylinder(d = OUTER_DIA, h = HEIGHT);
    cylinder(d = RIM_INNER_DIA, h = RIM_HEIGHT);
  }
  cylinder(d = INNER_DIA, h = RIM_HEIGHT);
}

#translate([-OUTER_DIA/2, 0, 0])
cube(size = [OUTER_DIA, OUTER_DIA/2, RIM_HEIGHT]);
}
