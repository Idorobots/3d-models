FL_DIA = 28;
FL_LIP_DIA = 1;
FL_HEIGHT = 9;
DIFF_DIA = 32;
DIFF_LIP_DIA = 2;
DIFF_HEIGHT = 5;
DIA = 34;
HEIGHT = FL_HEIGHT + DIFF_HEIGHT;

$fn = 50;

module diffuser() {
  union() {
    difference() {
      cylinder(d = 2 * DIFF_DIA, h = DIFF_HEIGHT);
      cylinder(d = DIFF_DIA, h = DIFF_HEIGHT);
    }
    
    translate([0, 0, DIFF_LIP_DIA/2 + 0.5])
    rotate_extrude(angle = 360)
    translate([DIFF_DIA/2, 0, 0])
    circle(d = DIFF_LIP_DIA);
    
    cylinder(d = FL_DIA, h = DIFF_HEIGHT);
  }
}

module flashlight() {
  difference() {
    cylinder(d = FL_DIA, h = FL_HEIGHT);
    translate([0, 0, FL_HEIGHT/2])
    rotate_extrude(angle = 360)
    translate([FL_DIA/2, 0, 0])
    circle(d = FL_LIP_DIA);
  }
}

module body() {
  union() {
    translate([0, 0, FL_HEIGHT - 1])
    cylinder(d = DIA, h = DIFF_HEIGHT + 1);
    cylinder(d1 = FL_DIA + 1, d2 = DIA, h = FL_HEIGHT - 1);
  }
}

module adapter() {
  difference() {
    body();
    translate([0, 0, FL_HEIGHT])
    diffuser();
    //translate([0, 0, 1])
    flashlight();
  }
}

adapter();