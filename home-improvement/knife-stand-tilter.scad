STAND_DIA = 117;

ANGLE = 75;
DIA = 130;
HEIGHT = 50;

FOOT_ANGLE = 110;
FOOT_DIA = 0.9 * DIA;

$fn = 300;

module adapter() {
  difference() {
    a = 90 - ANGLE;
    b = STAND_DIA * 2;
    d = DIA - STAND_DIA;
    intersection() {
      union() {
        rotate([a, 0, 0]) {
          cylinder(d = DIA, h = HEIGHT * 2, center = true);
          translate([0, 0, HEIGHT])
          rotate_extrude(angle = 360, $fn = 200)
          translate([-STAND_DIA/2, 0, 0])
          circle(d = d, $fn = 50);
        }

        translate([0, -HEIGHT, -HEIGHT/2])
        rotate([FOOT_ANGLE + a, 0, 0])
        cylinder(d = FOOT_DIA, h = HEIGHT * 2, center = true);
      }

      translate([0, 0, b/2])
      cube(size = [b, b, b], center = true);
    }

    #intersection() {
      rotate([a, 0, 0])
      cylinder(d = STAND_DIA, h = HEIGHT * 3, center = true);

      translate([0, 0, b/2 + d/2])
      cube(size = [b, b, b], center = true);
    }
  }
}

adapter();
