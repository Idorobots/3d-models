CORNER_DIA = 30;
THICKNESS = 5;
WIDTH = 120;

$fn = 500;

hull() {
    translate([-(WIDTH-CORNER_DIA)/2, 0, 0])
    cylinder(d = CORNER_DIA, h = THICKNESS);
    translate([(WIDTH-CORNER_DIA)/2, 0, 0])
    cylinder(d = CORNER_DIA, h = THICKNESS);
}
