SHAFT_DIA = 22;
HEX_SHAFT_DIA = 22;
KEY_WIDTH = 4;
KEY_HEIGHT = 4;
KEY_DEPTH = 3;
HEIGHT = 25;

$fn = 200;

difference() {
  cylinder(d = SHAFT_DIA, h = HEIGHT);
  #cylinder(d = HEX_SHAFT_DIA, h = HEIGHT, $fn = 6);

 #translate([-KEY_WIDTH/2, SHAFT_DIA/2 - (KEY_HEIGHT - KEY_DEPTH), 0])
  cube([KEY_WIDTH, KEY_HEIGHT, HEIGHT]);
}
