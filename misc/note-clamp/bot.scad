HEIGHT = 3;
WIDTH = 75;
LENGTH = 100;

SLANT = 4;
NOTE_BODY_DIA = 28;

BAR_CORNER_DIA = 6;
BAR_TOP_WIDTH = NOTE_BODY_DIA;
BAR_TOP_LENGTH = WIDTH - NOTE_BODY_DIA/2;
BAR_CONN_LENGTH = LENGTH - NOTE_BODY_DIA/2 - 2*SLANT;
BAR_CONN_WIDTH = 12;

HINGE_RADIUS = 3;
HINGE_HOLE_RADIUS = 1.6;
HINGE_HEIGHT = 6;
HINGE_SPACING = 12;
HINGE_WIDTH = 3;

$fn = 100;

module rounded_rect(width, length, height, corner_dia, slant = 0) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([j == -1 ? -slant : slant, 0, 0])
                translate([i * (width-corner_dia)/2, j * (length-corner_dia)/2, 0])
                cylinder(d = corner_dia, h = height, center = true);
            }
        }
    }
}

module outline() {
    union() {
        translate([-(BAR_CONN_LENGTH-BAR_TOP_WIDTH)/2, 0, 0])
        rounded_rect(BAR_TOP_WIDTH, BAR_TOP_LENGTH, HEIGHT, BAR_CORNER_DIA, -SLANT);

        translate([+SLANT/2, 0, 0])
        rounded_rect(BAR_CONN_LENGTH - SLANT - NOTE_BODY_DIA/2, BAR_CONN_WIDTH, HEIGHT, BAR_CORNER_DIA);

        translate([(BAR_CONN_LENGTH-NOTE_BODY_DIA)/2, 0, 0])
        cylinder(d = NOTE_BODY_DIA, h = HEIGHT, center = true);
    }
}

module hinge() {
    difference() {
        hull() {
            translate([0, 0, HINGE_HEIGHT])
                rotate([90, 0, 0])
                    cylinder(r = HINGE_RADIUS, h = HINGE_WIDTH, center = true);
            translate([-HINGE_RADIUS, -HINGE_WIDTH/2, 0]) cube(size = [2 * HINGE_RADIUS, HINGE_WIDTH, 1]);
        }
        translate([0, 0, HINGE_HEIGHT])
            rotate([90, 0, 0])
                cylinder(r = HINGE_HOLE_RADIUS, h = HINGE_WIDTH+2, center = true);
    }
}

union() {
    outline();
    translate([-0.16*LENGTH, -HINGE_SPACING/2, HEIGHT/2])
        hinge();
    translate([-0.16*LENGTH, HINGE_SPACING/2, HEIGHT/2])
        hinge();
}
