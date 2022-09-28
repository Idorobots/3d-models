SHAFT_DIA = 11.4;

HEX_WIDTH = 10;
HEX_DIA = 5.2;

HEX_HOLE = false;

GEAR_DIA = 22.5; // 25
GEAR_THICKNESS = 3.5;

TOOTH_LENGTH = 3;
TOOTH_WIDTH = 4;
TOOTH_DISTANCE = 12; // 13

TEETH = round((GEAR_DIA * PI)/TOOTH_DISTANCE);


$fn = 100;

module gear() {
  difference() {
      union() {
      cylinder(d = GEAR_DIA - TOOTH_LENGTH/2, h = GEAR_THICKNESS, $fn = TEETH);

      for(i = [0:TEETH-1]) {
        rotate([0, 0, (i + 0.5) * 360/TEETH])
        translate([GEAR_DIA/2, 0, 0])
        scale([1.0, TOOTH_WIDTH/(TOOTH_LENGTH * 2), 1.0])
        cylinder(d = TOOTH_LENGTH * 2, h = GEAR_THICKNESS);
      }
    }

    if(HEX_HOLE) {
      union() {
        cylinder(d = HEX_DIA, h = GEAR_THICKNESS);
        cylinder(d = HEX_WIDTH, h = GEAR_THICKNESS/2, $fn = 6);
      }
    } else {
      cylinder(d = SHAFT_DIA, h = GEAR_THICKNESS);
    }
  }
}

gear();
