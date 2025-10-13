CORNER_DIA = 15;
HEIGHT = 25;
WIDTH = 20;

MOUNT_HOLE_DIA = 4;
MOUNT_HOLE_HEAD_DIA = 8;
MOUNT_HOLE_HEAD_HEIGHT = 10;

$fn = 50;

module standoff() {
  union() {
    w = WIDTH - CORNER_DIA/2;

    cylinder(d = CORNER_DIA, h = HEIGHT);
    translate([-CORNER_DIA/2, 0, 0])
    cube(size = [w, w, HEIGHT]);
    translate([0, -CORNER_DIA/2, 0])
    cube(size = [w, w, HEIGHT]);
  }
}

difference() {
  standoff();
  #cylinder(d = MOUNT_HOLE_DIA, h = HEIGHT);
  #cylinder(d = MOUNT_HOLE_HEAD_DIA, h = MOUNT_HOLE_HEAD_HEIGHT);
}
