TOP_WIDTH = 5;
TOP_HEIGHT = 2;
BOT_WIDTH = 10;

HOLE_DIA = 5;
HOLE_SPACING = 20;
HEIGHT = 8;
LENGTH = 34;

$fn = 30;

module raiser() {
  difference() {
    union() {
      translate([0, 0, HEIGHT - TOP_HEIGHT])
      hull() {
      translate([-(LENGTH - BOT_WIDTH)/2, 0, 0])
      cylinder(d2 = TOP_WIDTH, d1 = BOT_WIDTH, h = TOP_HEIGHT);
      translate([(LENGTH - BOT_WIDTH)/2, 0, 0])
      cylinder(d2 = TOP_WIDTH, d1 = BOT_WIDTH, h = TOP_HEIGHT);
      }
      hull() {
        translate([-(LENGTH - BOT_WIDTH)/2, 0, 0])
        cylinder(d = BOT_WIDTH, h = HEIGHT - TOP_HEIGHT);
        translate([(LENGTH - BOT_WIDTH)/2, 0, 0])
        cylinder(d = BOT_WIDTH, h = HEIGHT - TOP_HEIGHT);

      }
    }

    hull() {
      translate([-HOLE_SPACING/2, 0, 0])
      cylinder(d = HOLE_DIA, h = HEIGHT);
      translate([HOLE_SPACING/2, 0, 0])
      cylinder(d = HOLE_DIA, h = HEIGHT);

    }    
  }
}
raiser();
