LED_DIA = 10;
LED_HEIGHT = 10;
LED_BASE_DIA = 28;
LED_BASE_WIDTH = 22;
LED_SWITCH_WIDTH = 8;
LED_SWITCH_HEIGHT = 4;

THICKNESS = 2;

HEIGHT = LED_HEIGHT + 2 * THICKNESS;
PEDESTAL_CHAMFER_DIA = 3;
PEDESTAL_INNER_DIA = 30;
PEDESTAL_OUTER_DIA = PEDESTAL_INNER_DIA + PEDESTAL_CHAMFER_DIA;
PEDESTAL_LIP_DIA = 25;



$fn = 100;

module channel() {
  translate([0, 0, LED_HEIGHT + THICKNESS])
  cylinder(d = PEDESTAL_LIP_DIA, h = HEIGHT);

  translate([0, 0, HEIGHT - THICKNESS])
  cylinder(d = PEDESTAL_INNER_DIA, h = HEIGHT);
}

module led() {
  cylinder(d = LED_DIA, h = HEIGHT);

  intersection() {
    cylinder(d = LED_BASE_DIA, h = LED_HEIGHT);
    cube(size = [LED_BASE_WIDTH, LED_BASE_DIA, LED_HEIGHT * 2], center = true);
  }

  translate([-LED_SWITCH_WIDTH/2, 0, 0])
  cube(size = [LED_SWITCH_WIDTH, LED_BASE_DIA, LED_SWITCH_HEIGHT]);
}

module pedestal() {
 difference() {
   union() {
     cylinder(d = PEDESTAL_OUTER_DIA, h = HEIGHT - PEDESTAL_CHAMFER_DIA/2);
     hull() {
       translate([0, 0, HEIGHT - PEDESTAL_CHAMFER_DIA/2])
       rotate_extrude(angle = 360)
       translate([-(PEDESTAL_OUTER_DIA - PEDESTAL_CHAMFER_DIA)/2, 0, 0])
       circle(d = PEDESTAL_CHAMFER_DIA);
     }
   }

   #channel();
   #led();
  }
}

pedestal();
