TOP_DIA = 100;
BOT_DIA = 90;
HEIGHT = 7;
THICKNESS = 2;
MOUNT_HOLE_DIA = 4;
DRAIN_HOLE_DIA = 3;

$fn = 100;

difference() {
  cylinder(d1 = BOT_DIA, d2 = TOP_DIA, h = HEIGHT);
  translate([0, 0, THICKNESS])
  cylinder(d1 = BOT_DIA, d2 = TOP_DIA, h = HEIGHT);
  cylinder(d = MOUNT_HOLE_DIA, h = HEIGHT);
  for(i = [-1, 1]) {
    for(j = [-1, 1]) {
      translate([i * BOT_DIA/4, j * BOT_DIA/4, 0])
      cylinder(d = DRAIN_HOLE_DIA, h = HEIGHT);
    }
  }
}
