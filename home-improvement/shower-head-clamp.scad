HEIGHT = 31;
DIA = 32.4;
WALL_THICKNESS = 1.5;

LIP_DIA = 31;
LIP_SMALL_HEIGHT = 1.5;
LIP_HEIGHT = 3;
LIP_THICKNESS = 0.8;

LIP_NUB_WIDTH = 5;
LIP_NUB_THICKNESS = 2.5;

HOLE_INNER_DIA = 12;
HOLE_OUTER_DIA = 18;
HOLE_HEIGHT = 5;

BASE_HEIGHT = 3;
BASE_SLOT_WIDTH = 6;

CUTOUT_1_HEIGHT = 11;
CUTOUT_1_DIA = 28;

CUTOUT_2_HEIGHT = 28;
CUTOUT_2_DIA = 12;

SIDES_HEIGHT = 19;

$fn = 50;

module cutout(dia, height) {
    translate([0, 0, height + dia/2])
    rotate([90, 0, 0])
    cylinder(d = dia, h = DIA * 2, center = true);
}

module body_neg() {
    union() {
        hull() {
            cutout(CUTOUT_1_DIA, CUTOUT_1_HEIGHT);
            translate([0, 0, CUTOUT_1_HEIGHT])
            cutout(CUTOUT_1_DIA, CUTOUT_1_HEIGHT);
        }

        translate([0, DIA/2 + CUTOUT_2_DIA/2, SIDES_HEIGHT + HEIGHT/2])
        cube(size = [DIA, DIA, HEIGHT], center = true);

        translate([0, -DIA/2 - CUTOUT_2_DIA/2, SIDES_HEIGHT + HEIGHT/2])
        cube(size = [DIA, DIA, HEIGHT], center = true);

        rotate([0, 0, 90])
        cutout(CUTOUT_2_DIA, CUTOUT_2_HEIGHT);
    }
}

module lip_neg() {
    union() {
        difference() {
            cylinder(d = DIA, h = LIP_SMALL_HEIGHT);
            cylinder(d = DIA - 2 * (WALL_THICKNESS - LIP_THICKNESS), h = LIP_HEIGHT);
        }
        difference() {
            cylinder(d = DIA - 2 * WALL_THICKNESS, h = LIP_HEIGHT);
            difference() {
                cube(size = [DIA, LIP_NUB_WIDTH, LIP_HEIGHT * 2], center = true);
                cylinder(d = DIA - 2 * LIP_NUB_THICKNESS, h = LIP_HEIGHT);
            }
        }
    }
}

module hole_neg() {
    union() {
        cylinder(d = HOLE_INNER_DIA, h = HEIGHT);

        d = DIA - 2 * WALL_THICKNESS;
        translate([0, 0, HOLE_HEIGHT + LIP_HEIGHT])
        cylinder(d = d, h = HEIGHT);
        
        translate([0, 0, BASE_HEIGHT + LIP_HEIGHT])
        difference() {
            h = HOLE_HEIGHT - BASE_HEIGHT;
            cylinder(d = d, h = h);
            cylinder(d = HOLE_OUTER_DIA, h = h);
        }
        difference() {
            intersection() {
                cube(size = [BASE_SLOT_WIDTH, d, (BASE_HEIGHT + LIP_HEIGHT)* 2], center = true);
                cylinder(d = d, h = (BASE_HEIGHT + LIP_HEIGHT) * 2);
            }
            cylinder(d = HOLE_OUTER_DIA, h = BASE_HEIGHT + LIP_HEIGHT);
        }
    }
}

difference() {
    cylinder(d = DIA, h = HEIGHT);
    
    body_neg();
    lip_neg();
    hole_neg();
}