WIDTH_MID = 14.5;
WIDTH_SIDE = 13;
LENGTH = 35.5;

MID_SPACING = 10;

INNER_WIDTH_MID = WIDTH_MID - 2;
INNER_WIDTH_SIDE = WIDTH_SIDE - 2;
INNER_LENGTH = LENGTH - 2;
INNER_MID_SPACING = MID_SPACING - 2;

HEIGHT_LIP = 4;
HEIGHT_TOP = 3.5;

WALL_THICKNESS = 1;

N_HOLES = 8;
N_ROWS = 3;
HOLE_DIA = 1.5;

HOLE_EXCLUSION = 5;

$fn = 100;

module profile(wm, ws, l, h) {
    hull() {
        translate([-MID_SPACING/2, 0, 0])
        cylinder(d = wm, h = h);
        translate([MID_SPACING/2, 0, 0])
        cylinder(d = wm, h = h);
        translate([-(l - ws)/2, 0, 0])
        cylinder(d = ws, h = h);
        translate([(l - ws)/2, 0, 0])
        cylinder(d = ws, h = h);
    }
}

module top(wm, ws, l, h) {
    scale([1.0, 1.0, 2*h/wm])
    intersection() {
        cylinder(d = l, h = 3*h);
        hull() {
            translate([-MID_SPACING/2, 0, 0])
            sphere(d = wm);
            translate([MID_SPACING/2, 0, 0])
            sphere(d = wm);
            translate([-(l - ws)/2, 0, 0])
            sphere(d = ws);
            translate([(l - ws)/2, 0, 0])
            sphere(d = ws);
        }
    }
}

module holes() {
    for(i = [0 : N_ROWS - 1]) {
        for(j = [0 : N_HOLES - 1]) {
            translate([(j - N_HOLES/2 + 0.5) * (LENGTH - HOLE_EXCLUSION)/N_HOLES, (i - N_ROWS/2 + 0.5) * (WIDTH_SIDE - HOLE_EXCLUSION)/N_ROWS, 0])
            cylinder(d = HOLE_DIA, h = HEIGHT_LIP + HEIGHT_TOP);
        }
    }
}

difference() {
    union() {
        translate([0, 0, HEIGHT_LIP])
        top(WIDTH_MID, WIDTH_SIDE, LENGTH, HEIGHT_TOP);
        profile(INNER_WIDTH_MID, INNER_WIDTH_SIDE, INNER_LENGTH, HEIGHT_LIP);
    }
    wt2 = WALL_THICKNESS * 2;
    profile(INNER_WIDTH_MID - wt2, INNER_WIDTH_SIDE - wt2, INNER_LENGTH - wt2, HEIGHT_LIP);

    #holes();
}
