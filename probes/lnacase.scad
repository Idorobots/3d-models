LNA_CONN_DIA = 7;
LNA_CONN_BASE = 1.5;
LNA_CONN_OFFSET_X = -1;
LNA_CONN_OFFSET_Y = 0;
LNA_CONN_OFFSET_Z = 1;
LNA_WIDTH = 26;
LNA_LENGTH = 36;
LNA_THICKNESS = 5;
LNA_HOLE_DIA = 3;
LNA_HOLE_SPACING_WIDTH = 17;
LNA_HOLE_SPACING_LENGTH = 26;

DC_DIA = 11;
DC_JACK_DIA = 8;
DC_LENGTH = 18;
DC_OFFSET_X = -6;
DC_OFFSET_Y = 0;
DC_OFFSET_Z = 1;

THICKNESS = 2;
LENGTH = LNA_LENGTH + 2 * LNA_CONN_BASE + 2 * THICKNESS;
WIDTH = LNA_WIDTH + (DC_LENGTH + DC_OFFSET_X) + 2 * THICKNESS;
HEIGHT = 20;

TOP = false;

$fn = 50;

module lna() {
    union() {
        cube(size = [LNA_WIDTH, LNA_LENGTH, LNA_THICKNESS], center = true);
        
        translate([LNA_CONN_OFFSET_X, LNA_CONN_OFFSET_Y, LNA_CONN_OFFSET_Z])
        rotate([90, 0, 0])
        cylinder(d = LNA_CONN_DIA, h = LNA_LENGTH + 20, center = true);

        translate([LNA_CONN_OFFSET_X, LNA_CONN_OFFSET_Y, LNA_CONN_OFFSET_Z])
        cube(size = [LNA_CONN_DIA, LNA_LENGTH + 2 * LNA_CONN_BASE, LNA_CONN_DIA], center = true);

        for (i = [-1, 1]) {
            for (j = [-1, 1]) {
                translate([i * LNA_HOLE_SPACING_WIDTH/2, j * LNA_HOLE_SPACING_LENGTH/2, -HEIGHT/3])
                cylinder(d = LNA_HOLE_DIA, h = HEIGHT * 2);
            }
        }
    }
}

module dc_jack() {
    translate([LNA_WIDTH/2 + DC_OFFSET_X, DC_OFFSET_Y, DC_OFFSET_Z])
    rotate([0, 90, 0])
    union() {
        cylinder(d = DC_DIA, h = DC_LENGTH);
        cylinder(d = DC_JACK_DIA, h = DC_LENGTH * 2);
    }
}

module case() {
    translate([WIDTH/2 - LNA_WIDTH/2 - THICKNESS, 0, 0])    
    cube(size = [WIDTH, LENGTH, HEIGHT], center = true);
}

intersection() {
    difference() {
        case();
        lna();
        dc_jack();
    }
    
    translate([0, 0, TOP ? 0 : -HEIGHT])
    cylinder(d = 2 * WIDTH, h = HEIGHT);
}