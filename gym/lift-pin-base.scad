NUB_DIA = 18;
NUB_THICKNESS = 4;
PLATE_DIA = 60.4;
PLATE_THICKNESS = 5;
BASE_DIA = 70;
BASE_THICKNESS = NUB_THICKNESS+PLATE_THICKNESS;

$fn = 100;

difference() {
    cylinder(d = BASE_DIA, h = BASE_THICKNESS);
    cylinder(d = NUB_DIA, h = NUB_THICKNESS);
    translate([0, 0, NUB_THICKNESS])
    cylinder(d = PLATE_DIA, h = PLATE_THICKNESS);
}
