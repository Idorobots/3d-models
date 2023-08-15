WIDTH = 15;
LENGTH = 120;
THICKNESS = 0.8;
POINT = 3;

$fn = 30;

hull() {
    translate([-(LENGTH-WIDTH)/2, 0, 0])
    cylinder(d = WIDTH, h = THICKNESS);

    cylinder(d = WIDTH, h = THICKNESS);

    translate([(LENGTH-POINT)/2, 0, 0])
    cylinder(d = POINT, h = THICKNESS);
}
