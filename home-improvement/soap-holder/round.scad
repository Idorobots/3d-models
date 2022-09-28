DIAMETER = 130;
HEIGHT = 3;
SLOT_WIDTH = 7;
N_SLOTS = 10;
FEET_DIA = 10;
N_FEET = N_SLOTS/2;
FEET_ANGLE_OFFSET = 90/N_FEET;

$fn = 50;

module base(diameter, height) {
    cylinder(h = height, d = diameter);
}

module slots(start, end, height, slot_width, n_slots) {
    for(i = [0 : n_slots]) {
        rotate([0, 0, i * 360/n_slots])
        hull() {
            translate([-end + slot_width/2, 0, 0])
            cylinder(d = slot_width, h = height);
            translate([-start - slot_width/2, 0, 0])
            cylinder(d = slot_width, h = height);
        }
    }
}

module feet(position, height, diameter, n_feet) {
    for(i = [0 : n_feet]) {
        rotate([0, 0, i * 360/n_feet + FEET_ANGLE_OFFSET])
        translate([-position, 0, height])
        scale([1.0, 1.0, 0.5])
        intersection() {
            sphere(d = diameter);
            cylinder(d = diameter, h = diameter/2);
        }
    }
}

union() {
    difference() {
        base(DIAMETER, HEIGHT);
        slots(DIAMETER/2 * 0.25, DIAMETER/2 * 0.9, HEIGHT, SLOT_WIDTH, N_SLOTS);
    }
    feet(DIAMETER/2 * 0.75, HEIGHT, FEET_DIA, N_FEET);
}
