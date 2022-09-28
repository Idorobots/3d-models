LENGTH_UNITS = 3;
WIDTH_UNITS = 1;
THICKNESS_UNITS = 0.5;
HOLE_TYPES = [ // 1 - axle, 0 - peg
    1, 0, 1
];

// Internal parameters
XY_UNIT = 8;
Z_UNIT = 7.9;
BEAM_DIA = 7.5;
HOLE_INNER_DIA = 4.8;
HOLE_OUTER_DIA = 6.2;
HOLE_OUTER_DEPTH = 0.8;
HOLE_AXLE_WIDTH = 1.85;

TEST_DELTA = false; // Set to true to generate lengthwise 0.1-increments on the hole dia.
HOLE_AXLE_DELTA = 0.3; // Set to whatever your printer prints best out of the tested increments.
HOLE_PEG_DELTA = 0.25;

FOOT_EXTRA_DELTA = 0.1; // To battle the elephant foot.

$fn = 100;

module rounded_cube(length, width, thickness, corner_dia = 1) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (length - corner_dia)/2, j * (width - corner_dia)/2, 0])
                cylinder(d = corner_dia, h = thickness);
            }
        }
    }
}

module peg_hole(inner_dia, outer_dia, depth, thickness) {
    d = TEST_DELTA ? 0 : HOLE_PEG_DELTA;
    union() {
        translate([0, 0, thickness - depth])
        cylinder(d = outer_dia + d, h = depth);
        cylinder(d = inner_dia + d, h = thickness);
        translate([0, 0, depth])
        cylinder(d1 = outer_dia + d, d2 = inner_dia + d, h = depth*2/3);
        cylinder(d = outer_dia + d + FOOT_EXTRA_DELTA, h = depth);
    }
}

module axle_hole(inner_dia, axle_width, thickness) {
    d = TEST_DELTA ? 0 : HOLE_AXLE_DELTA;
    w = (inner_dia - axle_width);
    difference() {
        cylinder(d = inner_dia + d, h = thickness);
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                translate([i * (inner_dia + d)/2, j * (inner_dia + d)/2, 0])
                rounded_cube(w, w, thickness);
            }
        }
    }
}

module lego_translate(x, y, z) {
    translate([x * XY_UNIT, y * XY_UNIT, z * Z_UNIT])
    children();
}

module plate_body(length, width, thickness, dia) {
    hull() {
        for(i = [-1, 1]) {
            for(j = [-1, 1]) {
                lego_translate(i * (length - 1)/2, j * (width - 1)/2, 0)
                cylinder(d = dia, h = thickness * Z_UNIT);
            }
        }
    }
}

module plate_holes(length, width, thickness, hole_types, beam_dia) {
    lego_translate(-(length - 1)/2, -(width - 1)/2, 0)
    union() {
        for(i = [0:length]) {
            for(j = [0:width]) {
                d = TEST_DELTA ? i * 0.1 : 0;
                lego_translate(i, j, 0)
                if(hole_types != undef && hole_types[j * length + i]) {
                    axle_hole(HOLE_INNER_DIA + d, HOLE_AXLE_WIDTH + d, thickness * Z_UNIT);
                } else {
                    peg_hole(HOLE_INNER_DIA + d, HOLE_OUTER_DIA + d, HOLE_OUTER_DEPTH, thickness * Z_UNIT);
                }
            }
        }
    }
}

module plate(length, width, thickness, hole_types, beam_dia) {
    difference() {
        plate_body(length, width, thickness, beam_dia);
        plate_holes(length, width, thickness, hole_types);
    }
}

module beam(length, thickness, hole_types = [], beam_dia = BEAM_DIA) {
    plate(length, 1, thickness, hole_types, beam_dia);
}

beam(LENGTH_UNITS, THICKNESS_UNITS, HOLE_TYPES);
