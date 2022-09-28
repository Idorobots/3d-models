BED_HEIGHT = 3;
BED_DIAMETER = 220;
OVERHANG = 1;

WIDTH = 16;
LENGTH = 134;
HEIGHT = 5 + BED_HEIGHT;

BOLT_DIAMETER = 3.2;
BOLT_HEAD_DIAMETER = 5.2;
BOLT_SHAFT_LENGTH = 5;
SLOT_LENGTH = 8;
BOLT_OFFSET = 4;

difference() {
    translate([-LENGTH/2, -WIDTH/2, 0])
    cube(
        size = [LENGTH, WIDTH, HEIGHT]
    );

    translate([
        0,
        BED_DIAMETER/2 - WIDTH/2 - OVERHANG,
        HEIGHT - BED_HEIGHT
    ])
    cylinder(
        r = BED_DIAMETER/2,
        h = 2*BED_HEIGHT,
        $fn = 100
    );

    translate([
        -LENGTH/2 + BOLT_OFFSET,
        0,
        -1
    ])
    BoltSlot(
        BOLT_DIAMETER,
        BOLT_SHAFT_LENGTH + 1,
        BOLT_HEAD_DIAMETER,
        HEIGHT - BOLT_SHAFT_LENGTH + 2,
        SLOT_LENGTH
    );

    translate([
        LENGTH/2 - BOLT_OFFSET,
        0,
        -1
    ])
    BoltSlot(
        BOLT_DIAMETER,
        BOLT_SHAFT_LENGTH + 1,
        BOLT_HEAD_DIAMETER,
        HEIGHT - BOLT_SHAFT_LENGTH + 2,
        SLOT_LENGTH
    );
}

module Slot(
    diameter,
    height,
    width
) {
    linear_extrude(height = height)
    hull() {
        translate([0, -width/2, 0])
        circle(
            r = diameter/2,
            $fn = 25
        );

        translate([0, width/2, 0])
        circle(
            r = diameter/2,
            $fn = 25
        );
    }

}

module BoltSlot(
    shaftDiameter,
    shaftLength,
    headDiameter,
    headLength,
    slotWidth
) {
    union() {
        Slot(
            shaftDiameter,
            shaftLength + headLength,
            slotWidth
        );

        translate([0, 0, shaftLength])
        Slot(
            headDiameter,
            headLength,
            slotWidth
        );
    }
}
