TUBE_OUTER_DIA = 55;
TUBE_INNER_DIA = 51;

HEIGHT = 10;
THICKNESS = 1.5;

CAP_LIP = 5;
CHAMFER_SIZE = 1;

$fn = 50;

module tube() {
  difference() {
    cylinder(d = TUBE_OUTER_DIA, h = HEIGHT);
    cylinder(d = TUBE_INNER_DIA, h = HEIGHT);
  }
}

module cap() {
  difference() {
    cylinder(d = TUBE_INNER_DIA - 2 * THICKNESS, h = HEIGHT - THICKNESS);

    translate([(TUBE_INNER_DIA/2 - CAP_LIP), -TUBE_INNER_DIA/2, 0])
    cube(size = [TUBE_INNER_DIA, TUBE_INNER_DIA, THICKNESS]);

    translate([-TUBE_INNER_DIA - (TUBE_INNER_DIA/2 - CAP_LIP), -TUBE_INNER_DIA/2, 0])
    cube(size = [TUBE_INNER_DIA, TUBE_INNER_DIA, THICKNESS]);
  }
}

module chamfer() {
  difference() {
    cylinder(d = TUBE_OUTER_DIA, h = CHAMFER_SIZE);
    cylinder(d1 = TUBE_INNER_DIA, d2 = TUBE_INNER_DIA - 2 * CHAMFER_SIZE, h = CHAMFER_SIZE);
  }
}

module cover() {
  difference() {
    cylinder(d = TUBE_OUTER_DIA, h = HEIGHT);
    #translate([0, 0, THICKNESS])
    tube();
    #cap();
    #translate([0, 0, HEIGHT - CHAMFER_SIZE])
    chamfer();
  }
}

cover();
