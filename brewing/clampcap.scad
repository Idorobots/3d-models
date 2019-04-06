INTERNAL_DIA = 17;
INTERNAL_HEIGHT = 10;

EXTERNAL_DIA_TOP = 23;
EXTERNAL_DIA_BOT = 26;
EXTERNAL_HEIGHT = 6;

CLAMP_HOLE_DIA = 3;

$fn = 100;

difference() {
    union() {
        cylinder(d2 = EXTERNAL_DIA_BOT, d1 = EXTERNAL_DIA_TOP, h = EXTERNAL_HEIGHT);
        cylinder(d = INTERNAL_DIA, h = EXTERNAL_HEIGHT + INTERNAL_HEIGHT);
    }
    
    translate([0, 0, EXTERNAL_HEIGHT/2])
    rotate([90, 0, 0])
    cylinder(d = CLAMP_HOLE_DIA, h = max(EXTERNAL_DIA_TOP, EXTERNAL_DIA_BOT), center = true);
}