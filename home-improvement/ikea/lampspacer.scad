INNER_DIA = 98;
OUTER_DIA = 104;
HEIGHT = 1;

TAB_LENGTH = 5;
TAB_WIDTH = 4;
TAB_ANGLE = 110;
TABS = 5;

$fn = 200;

module half_slot(dia, length, height) {
    hull() {
        translate([-(length-dia)/2, 0, 0])
        cylinder(d = dia, h = height);

        translate([(length-dia)/2, 0, 0])
        translate([-dia/2, -dia/2, 0])
        cube(size = [dia, dia, height]);
    }
}

module tabs() {
    intersection() {
        for(i = [0:TABS-1]) {
            rotate([0, 0, i * 360/TABS])
            translate([INNER_DIA/2 - HEIGHT * sin(TAB_ANGLE), 0, 0])
            rotate([0, TAB_ANGLE, 0])
            translate([-TAB_LENGTH/2, 0, 0])
            half_slot(TAB_WIDTH, TAB_LENGTH, HEIGHT);
        }
        cylinder(d = OUTER_DIA, h = OUTER_DIA);
    }
}



module ring() {
    difference() {
        cylinder(d = OUTER_DIA, h = HEIGHT);
        cylinder(d = INNER_DIA, h = HEIGHT);
    }
}

difference() {
    union() {
        ring();
        tabs();
    }
    for(i = [1:TABS-1]) {
        rotate([0, 0, i * 360/TABS/TABS])
        scale(1.01)
        tabs();
    }
}