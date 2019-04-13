MAGNET_DIAMETER = 15.3;
MAGNET_INTERNAL_DIAMETER = 4.7;
MAGNET_HEIGHT = 3;

INNER_DIAMETER = 20;
OUTER_DIAMETER = 22;
HEIGHT = 15;
OFFSET = 1;

MOUNTING_HOLE_DIAMETER = 4;

TOLERANCE = 0.5;

$fn = 100;

module magnet() {
    union() {
        cylinder(d = MAGNET_DIAMETER, h = MAGNET_HEIGHT);
        cylinder(d = MAGNET_INTERNAL_DIAMETER, h = MAGNET_HEIGHT * 20, center = true);
    }
}

module bottom() {
    difference() {
        cylinder(d = OUTER_DIAMETER, h = HEIGHT);
        translate([0, 0, OFFSET])
            magnet();
        translate([0, 0, OFFSET + MAGNET_HEIGHT - TOLERANCE])
            cylinder(d = INNER_DIAMETER, h = HEIGHT);
    }
}

module top() {
    difference() {
    cylinder(d = INNER_DIAMETER - TOLERANCE, h = HEIGHT);
    translate([0, 0, HEIGHT - MAGNET_HEIGHT + TOLERANCE])
        magnet();
    }
}

top();

translate([25, 0, 0])
bottom();