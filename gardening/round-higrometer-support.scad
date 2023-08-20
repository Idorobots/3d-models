METER_DIA = 41;
METER_SLOT_WIDTH = 7;
METER_SLOT_DEPTH = 1.5;
METER_SLOT_ANGLE = -30;
METER_THICKNESS = 5;

WIDTH = 15;
LENGTH = 120;
THICKNESS = 2;
POINT = 3;

$fn = 50;

module support() {
    hull() {
        translate([(LENGTH-WIDTH)/2, 0, 0])
        cylinder(d = WIDTH, h = THICKNESS);

        cylinder(d = WIDTH, h = THICKNESS);

        translate([(LENGTH-POINT), 0, 0])
        cylinder(d = POINT, h = THICKNESS);
    }
}

module holder() {
    cylinder(d = METER_DIA + 2 * METER_SLOT_DEPTH + 2 * THICKNESS, h = METER_THICKNESS);
}

module meter() {
    cylinder(d = METER_DIA, h = METER_THICKNESS);
    rotate([0, 0, METER_SLOT_ANGLE])
    translate([-METER_DIA/2 - METER_SLOT_DEPTH, -METER_SLOT_WIDTH/2, 0])
    cube(size = [METER_SLOT_DEPTH * 2 + METER_DIA, METER_SLOT_WIDTH, METER_THICKNESS]);
}

difference() {
    union() {
        support();
        holder();
    }
    #meter();
}
