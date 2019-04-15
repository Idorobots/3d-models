HEIGHT = 3;
WIDTH = 75;
LENGTH = 100;

SLANT = 4;
NOTE_BODY_DIA = 28;

BAR_CORNER_DIA = 6;
BAR_TOP_WIDTH = NOTE_BODY_DIA;
BAR_CONN_WIDTH = 10;
BAR_TOP_LENGTH = WIDTH - NOTE_BODY_DIA/2;
BAR_CONN_LENGTH = LENGTH - NOTE_BODY_DIA/2 - 2 * SLANT;

HINGE_RADIUS = 3;
HINGE_HOLE_RADIUS = 1.6;
HINGE_HEIGHT = 6;
HINGE_WIDTH = 3;
HINGE_SPACING = 12 + 2 * HINGE_WIDTH + 2;

$fn = 100;

use <bot.scad>;

module note_body(dia, height) {
    rotate([0, 0, -2*SLANT])
    scale([0.75, 1, 1])
    cylinder(d = dia, h = height, center = true);
}

module outline() {
    union() {
        translate([-(BAR_CONN_LENGTH-BAR_TOP_WIDTH)/2, 0, 0])
        rounded_rect(BAR_TOP_WIDTH, BAR_TOP_LENGTH, HEIGHT, BAR_CORNER_DIA, SLANT);
        
        translate([SLANT+1, (BAR_TOP_LENGTH-BAR_CONN_WIDTH)/2, 0])
        rounded_rect(BAR_CONN_LENGTH, BAR_CONN_WIDTH, HEIGHT, BAR_CORNER_DIA);

        translate([-SLANT+1, -(BAR_TOP_LENGTH-BAR_CONN_WIDTH)/2, 0])
        rounded_rect(BAR_CONN_LENGTH, BAR_CONN_WIDTH, HEIGHT, BAR_CORNER_DIA);
        
        translate([BAR_CONN_LENGTH/2+SLANT, (BAR_TOP_LENGTH+NOTE_BODY_DIA)/2 - BAR_CONN_WIDTH, 0])
        note_body(NOTE_BODY_DIA, HEIGHT);
        
        translate([BAR_CONN_LENGTH/2-SLANT, -(BAR_TOP_LENGTH-NOTE_BODY_DIA)/2, 0])
        note_body(NOTE_BODY_DIA, HEIGHT);
    }
}

union() {
    outline();
    translate([-0.16*LENGTH, -HINGE_SPACING/2, HEIGHT/2])
        hinge();
    translate([-0.16*LENGTH, HINGE_SPACING/2, HEIGHT/2])
        hinge();
}