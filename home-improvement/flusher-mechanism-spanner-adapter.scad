SLOT_WIDTH = 3;
SLOT_THICKNESS = 1;
SLOTS = 18;
FLANGE_OUTER_DIA_TOP = 50;
FLANGE_OUTER_DIA_BOT = 50.8;
FLANGE_HEIGHT = 16;
FLANGE_INNER_DIA = 30;
FLANGE_CLEARANCE_HEIGHT = 11;

WALL_THICKNESS = 6;
OUTER_DIA = max([FLANGE_OUTER_DIA_TOP, FLANGE_OUTER_DIA_BOT]) + 2 * SLOT_THICKNESS + 2 * WALL_THICKNESS;

HEIGHT = FLANGE_HEIGHT + FLANGE_CLEARANCE_HEIGHT + 10;
FLAT_AT = 0.90;

$fn = 50;

module flange_neg() {
    union() {
        cylinder(d2 = FLANGE_OUTER_DIA_BOT, d1 = FLANGE_OUTER_DIA_TOP, h = FLANGE_HEIGHT);
        for(i = [0:SLOTS-1]) {
            rotate([0, 0, i * 360/SLOTS])
            translate([-(FLANGE_OUTER_DIA_TOP+FLANGE_OUTER_DIA_BOT)/4, 0, 0])
            translate([-SLOT_THICKNESS/2, -SLOT_WIDTH/2, 0])
            cube(size = [SLOT_THICKNESS, SLOT_WIDTH, FLANGE_HEIGHT]);
        }
    }
}

module flange_clearance_neg() {
    cylinder(d = FLANGE_INNER_DIA, h = FLANGE_CLEARANCE_HEIGHT);
}

module adapter_pos() {
    cylinder(d = OUTER_DIA, h = HEIGHT);
}

module adapter_neg() {
    union() {
        translate([-OUTER_DIA * FLAT_AT, 0, 0])
        translate([-OUTER_DIA/2, -OUTER_DIA/2, 0])
        cube(size = [OUTER_DIA, OUTER_DIA, HEIGHT - FLANGE_HEIGHT]);
        translate([OUTER_DIA * FLAT_AT, 0, 0])
        translate([-OUTER_DIA/2, -OUTER_DIA/2, 0])
        cube(size = [OUTER_DIA, OUTER_DIA, HEIGHT - FLANGE_HEIGHT]);
    }
}

difference() {
    adapter_pos();
    translate([0, 0, FLANGE_HEIGHT])
    adapter_neg();
    flange_neg();
    translate([0, 0, FLANGE_HEIGHT])
    flange_clearance_neg();
}
