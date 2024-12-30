WIDTH = 76;
LENGTH = 60;
DEPTH = 8.5;

CORNER_DIA = 4;

WALL_THICKNESS = 3.5;
SIDE_THICKNESS = 2;

HOLE_SPACING_X = 66;
HOLE_SPACING_Y = 51;
HOLE_DIA = 3;
HOLE_SUPPORT_DIA = 8;

IEC_WIDTH = 21;
IEC_LENGTH = 26;
IEC_OFFSET_X = 22;
IEC_OFFSET_Y = 8;

ONOFF_WIDTH = 20;
ONOFF_LENGTH = 12;
ONOFF_OFFSET_X = 22;
ONOFF_OFFSET_Y = -16;

FUSE_DIA = 15;
FUSE_OFFSET_X = -22;
FUSE_OFFSET_Y = 13;

CABLE_DIA = 15;
CABLE_OFFSET_X = -22;
CABLE_OFFSET_Y = -13;

TAB_DEPTH = WALL_THICKNESS;
TAB_WIDTH = 20;
TAB_LENGTH = WIDTH;
TAB_CORNER_DIA = 15;

TAB_HOLE_SPACING_X = 30;
TAB_HOLE_SPACING_Y = 10;
TAB_HOLE_DIA = 6;

$fn = 30;

module mount_holes(w, l, h, dia) {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * w/2, j * l/2, 0])
            cylinder(d = dia, h = h);
        }
    }
}

module rounded_rect(w, l, h, corner_dia) {
    hull() {
        mount_holes(w-corner_dia, l-corner_dia, h, corner_dia);
    }
}

module cavity() {
    w = WIDTH - 2 * WALL_THICKNESS;
    l = LENGTH - 2 * WALL_THICKNESS;
    difference() {
        rounded_rect(w, l, DEPTH - SIDE_THICKNESS, CORNER_DIA);
        mount_holes(HOLE_SPACING_X, HOLE_SPACING_Y, DEPTH, HOLE_SUPPORT_DIA);
    }
    #mount_holes(HOLE_SPACING_X, HOLE_SPACING_Y, DEPTH, HOLE_DIA);
}

module ports() {
    #translate([IEC_OFFSET_X, IEC_OFFSET_Y, 0])
    rounded_rect(IEC_WIDTH, IEC_LENGTH, DEPTH, 1);

    #translate([ONOFF_OFFSET_X, ONOFF_OFFSET_Y, 0])
    rounded_rect(ONOFF_WIDTH, ONOFF_LENGTH, DEPTH, 1);

    #translate([FUSE_OFFSET_X, FUSE_OFFSET_Y, 0])
    cylinder(d = FUSE_DIA, h = DEPTH);

    #translate([CABLE_OFFSET_X, CABLE_OFFSET_Y, 0])
    cylinder(d = CABLE_DIA, h = DEPTH);
}

module tab() {
    translate([0, LENGTH/2, DEPTH-TAB_DEPTH])
    difference() {
        rounded_rect(TAB_LENGTH, TAB_WIDTH * 2, TAB_DEPTH, TAB_CORNER_DIA);
        mount_holes(TAB_HOLE_SPACING_X, TAB_HOLE_SPACING_Y * 2, TAB_DEPTH, TAB_HOLE_DIA);
    }
}

module empty_side() {
    difference() {
        union() {
            rounded_rect(WIDTH, LENGTH, DEPTH, CORNER_DIA);
            tab();
        }
        cavity();
    }
}

module port_side() {
    difference() {
        union() {
            rounded_rect(WIDTH, LENGTH, DEPTH, CORNER_DIA);
            tab();
        }
        cavity();
        ports();
    }
}

empty_side();
//port_side();
