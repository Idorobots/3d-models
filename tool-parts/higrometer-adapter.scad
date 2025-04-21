THICKNESS = 2;
OUTER_DIA = 56.5;
INNER_DIA = 41.5;
SLOT_WIDTH = 6;
SLOT_DEPTH = 1.5;

PORT = true;
HIGROMETER_OFFSET = PORT ? (OUTER_DIA-INNER_DIA)/2 - 2 : 0;
PORT_DIA = 11;
PORT_OFFSET = -22.5;

$fn = 100;

difference() {
  cylinder(d = OUTER_DIA, h = THICKNESS);
  translate([HIGROMETER_OFFSET, 0, 0]) {
    #cylinder(d = INNER_DIA, h = THICKNESS);
    #translate([-SLOT_WIDTH/2, -SLOT_DEPTH - INNER_DIA/2, 0])
    cube([SLOT_WIDTH, SLOT_DEPTH * 2 + INNER_DIA, THICKNESS]);
  }

  #if(PORT) {
    translate([PORT_OFFSET, 0, 0])
    cylinder(d = PORT_DIA, h = THICKNESS);
  }
}
