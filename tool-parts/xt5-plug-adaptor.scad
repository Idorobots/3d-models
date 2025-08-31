HOLE_DIA = 3.5;
HOLE_SPACING = 5;
HOLE_OFFSET = 1.5;

CHANNEL_DIA = 3;

WIDTH = 11.5;
HEIGHT = 15;

TOP_SCALE = 0.9;
BOT_SCALE = 0.2;

$fn = 100;

difference() {
  hull() {
    intersection() {
      scale([1.0, TOP_SCALE, 1.0])
      cylinder(d = WIDTH, h = HEIGHT);
      translate([-WIDTH/2, 0, 0])
      cube(size = [WIDTH, WIDTH, HEIGHT]);
    }

      intersection() {
      scale([1.0, BOT_SCALE, 1.0])
      cylinder(d = WIDTH, h = HEIGHT);
      translate([-WIDTH/2, -WIDTH, 0])
      cube(size = [WIDTH, WIDTH, HEIGHT]);
    }
  }

  #translate([0, WIDTH/2 * TOP_SCALE, 0])
  cylinder(d = CHANNEL_DIA, h = HEIGHT);

  #translate([-HOLE_SPACING/2, HOLE_OFFSET, 0])
  cylinder(d = HOLE_DIA, h = HEIGHT);

  #translate([HOLE_SPACING/2, HOLE_OFFSET, 0])
  cylinder(d = HOLE_DIA, h = HEIGHT);
}
