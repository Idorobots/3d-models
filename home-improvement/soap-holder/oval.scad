WIDTH = 70;
LENGTH = 110;
HEIGHT = 3;
SLOT_WIDTH = 7;
N_SLOTS = 3;
FEET_DIA = 10;

$fn = 50;

module base(width, length, height) {
    hull() {
        translate([length/2-width/2, 0, 0])
        cylinder(h = height, d = width);

        translate([-length/2+width/2, 0, 0])
        cylinder(h = height, d = width);
    }
}

module slots(width, length, height, slot_width, n_slots) {
    step = length / (n_slots-1);
    translate([-length/2, 0, 0])
    union() {
        for(i = [0: n_slots-1]) {
            hull() {
                translate([i * step, width/2-slot_width/2, 0])
                cylinder(h = height, d = slot_width);

                translate([i * step, -width/2+slot_width/2, 0])
                cylinder(h = height, d = slot_width);
            }
        }
    }
}

module feet(width, length, height, diameter) {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * (length/2 - diameter/2), j * (width/2 - diameter/2), height])
            scale([1.0, 1.0, 0.5])
            intersection() {
                sphere(d = diameter);
                cylinder(d = diameter, h = diameter/2);
            }
        }
    }
}

union() {
    difference() {
        base(WIDTH, LENGTH, HEIGHT);
        slots(WIDTH * 0.75, LENGTH * 0.4, HEIGHT, SLOT_WIDTH, N_SLOTS);
    }
    feet(WIDTH * 0.75, LENGTH * 0.7, HEIGHT, FEET_DIA);
}
