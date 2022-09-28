LED_WIDTH = 2;
LED_LIP_WIDTH = 3;
LED_LENGTH = 5.2;
LED_LIP_LENGTH = LED_LENGTH;
LED_HEIGHT = 7;
LED_LIP_HEIGHT = 2;

LEDS = 16;
LED_SPACING = 2.54;

WALL_THICKNESS = 1.2;
LENGTH = LEDS * LED_SPACING + 2 * WALL_THICKNESS;
WIDTH = 8;
HEIGHT = LED_HEIGHT;

module led() {
  union() {
    translate([-LED_WIDTH/2, -LED_LENGTH/2, 0])
    cube(size = [LED_WIDTH, LED_LENGTH, LED_HEIGHT]);
    translate([-LED_LIP_WIDTH/2, -LED_LIP_LENGTH/2, 0])
    cube(size = [LED_LIP_WIDTH, LED_LIP_LENGTH, LED_LIP_HEIGHT]);
  }
}

module bar_graph() {
  difference() {
    translate([-LENGTH/2, -WIDTH/2, 0])
    cube(size = [LENGTH, WIDTH, HEIGHT]);

    translate([-((LEDS-1) * LED_SPACING)/2, 0, 0])
    for(i = [0 : LEDS-1]) {
      translate([i * LED_SPACING, 0, 0])
      led();
    }
  }
}

bar_graph();
