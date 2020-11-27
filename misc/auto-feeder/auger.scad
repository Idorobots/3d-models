AUGER_CENTER_DIA = 8;
AUGER_DIA = 50;
AUGER_TWIST = 540;
AUGER_HEIGHT = 50;

SHAFT_LENGTH = 20;
SHAFT_MOUNT_LENGTH = 8;
SHAFT_DIA = AUGER_CENTER_DIA;

CIRCULAR = false;


$fn = 30;

module auger() {
  union() {
    linear_extrude(height = AUGER_HEIGHT, twist = AUGER_TWIST)
    translate([AUGER_DIA/4, 0, 0])
    if(!CIRCULAR) {
      square([AUGER_DIA/2, AUGER_CENTER_DIA], center = true);
    } else {
      circle(d = AUGER_DIA/2);
    }
    cylinder(d = AUGER_CENTER_DIA, h = AUGER_HEIGHT);
  }
}

module shaft() {
  union() {
    cylinder(d = SHAFT_DIA, h = SHAFT_LENGTH - SHAFT_MOUNT_LENGTH);
    translate([0, 0, SHAFT_LENGTH - SHAFT_MOUNT_LENGTH])
    cylinder(d = SHAFT_DIA, h = SHAFT_MOUNT_LENGTH, $fn = 6);
  }
}

union() {
  auger();
  translate([0, 0, AUGER_HEIGHT])
  shaft();
}