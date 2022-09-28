HEIGHT = 6.5;
BASE_DIA = 20;
BASE_THICKNESS = 1.5;
COLUMN_DIA = 3;
HEAD_DIA = 4.5;

$fn = 30;

union() {
    cylinder(d = BASE_DIA, h = BASE_THICKNESS);
    translate([0, 0, HEIGHT-HEAD_DIA/2])
    sphere(d = HEAD_DIA, center = true);
    cylinder(d = COLUMN_DIA, h = HEIGHT-HEAD_DIA/2);
}
