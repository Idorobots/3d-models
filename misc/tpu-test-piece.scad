DIA = 20;
HEIGHT = 7;

NUBS_DIA = 6;
NUBS_SCALE = 0.6;
NUBS_SPACING = 9;

HOLE_DIA = 3;
HOLE_HEAD_HEIGHT = 4;
HOLE_HEAD_DIA = 6;

$fn = 50;

difference() {
  union() {
    cylinder(d = DIA, h = HEIGHT);
    translate([-DIA/2, 0, 0])
    cube(size = [DIA, DIA/2, HEIGHT]);

    for(i = [-1, 1]) {
      for(j = [-1, 1]) {
        translate([i * NUBS_SPACING/2, j * NUBS_SPACING/2, HEIGHT])
        scale([1, 1, NUBS_SCALE])
        sphere(d = NUBS_DIA);
      }
    }
  }

  #cylinder(d = HOLE_DIA, h = HEIGHT);
  #translate([0, 0, HEIGHT - HOLE_HEAD_HEIGHT])
  cylinder(d = HOLE_HEAD_DIA, h = HOLE_HEAD_HEIGHT * 2);
}
