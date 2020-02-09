THICKNESS = 1.2;
WIDTH = 130 - 2 * THICKNESS;
HEIGHT = 40 - THICKNESS;
CORNER_DIA = 15;

MOUNTING_HOLE_SPACING = 120;
MOUNTING_HOLE_DIA = 6;
MOUNTING_HOLE_HEAD_DIA = 8;
MOUNTING_HOLE_HEAD_HEIGHT = 4;
MOUNTING_HOLE_PEG_DIA = 12;

PORT_DIA = 7;
PORTS = 5;
PORTS_LENGTH = 7;

$fn = 30;

module pegs(width, length, height, corner_dia) {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * (width - corner_dia)/2, j * (length - corner_dia)/2, 0])
            cylinder(d = corner_dia, h = height);
        }
    }
}

module rounded_rect(width, length, height, corner_dia) {
    hull() {
        pegs(width, length, height, corner_dia);
    }
}

module ports() {
    for(i = [1:PORTS]) {
        hull() {
        translate([-WIDTH/2 + i * (WIDTH/(PORTS + 1)), 0, PORTS_LENGTH])
        rotate([90, 0, 0])
        cylinder(d = PORT_DIA, h = WIDTH);
            
        translate([-WIDTH/2 + i * (WIDTH/(PORTS + 1)), 0, -PORTS_LENGTH])
        rotate([90, 0, 0])
        cylinder(d = PORT_DIA, h = WIDTH);
        }
    }
}

difference() {
    union() {
        difference() {
            rounded_rect(WIDTH + 2 * THICKNESS, WIDTH + 2 * THICKNESS, HEIGHT + THICKNESS, CORNER_DIA);
            
            rounded_rect(WIDTH, WIDTH, HEIGHT, CORNER_DIA);
        }
        pegs(MOUNTING_HOLE_SPACING, MOUNTING_HOLE_SPACING, HEIGHT + THICKNESS, MOUNTING_HOLE_PEG_DIA);
    }

    delta = (MOUNTING_HOLE_PEG_DIA - MOUNTING_HOLE_DIA);
    pegs(MOUNTING_HOLE_SPACING - delta, MOUNTING_HOLE_SPACING - delta, HEIGHT + 2 * THICKNESS, MOUNTING_HOLE_DIA);

    head_delta = (MOUNTING_HOLE_PEG_DIA - MOUNTING_HOLE_HEAD_DIA);
    translate([0, 0, HEIGHT + THICKNESS - MOUNTING_HOLE_HEAD_HEIGHT])
    pegs(MOUNTING_HOLE_SPACING - head_delta, MOUNTING_HOLE_SPACING - head_delta, MOUNTING_HOLE_HEAD_HEIGHT, MOUNTING_HOLE_HEAD_DIA);
    
    ports();
}