HEIGHT = 20;

ID_TOP = 6;
OD_TOP = 7;

ID_BOT = OD_TOP;
OD_BOT = 10;

$fn = 200;

difference() {
  cylinder(d1 = OD_BOT, d2 = OD_TOP, h = HEIGHT);
  cylinder(d1 = ID_BOT, d2 = ID_TOP, h = HEIGHT);
}
