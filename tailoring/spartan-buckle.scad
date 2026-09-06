BUCKLE_DIA = 72;
BUCKLE_THICKNESS = 4;

BACKGROUND_DIA = 70;
LOGO_DIA = 58;
LOGO_BAR_WIDTH = 8;
LOGO_DEPTH = 1;

LOOPS = false;
BELT_LOOP_SLOT_LENGTH = 51;
BELT_LOOP_SLOT_WIDTH = 3;
BELT_LOOP_THICKNESS = 2;

CATCH = true;
CATCH_LOOP_LENGTH = 55;
CATCH_LOOP_WIDTH = 20;
CATCH_LOOP_THICKNESS = 3;
CATCH_THICKNESS = CATCH_LOOP_THICKNESS+1;
CATCH_WIDTH = CATCH_LOOP_WIDTH-1;
CATCH_LENGTH = CATCH_LOOP_LENGTH+4;

$fn = 100;

module logo() {
    translate([0, 0, -LOGO_DEPTH])
    minkowski() {
        difference() {
            cylinder(d = LOGO_DIA, h = LOGO_DEPTH);

            rotate([0, 0, 45])
            translate([-LOGO_BAR_WIDTH/2, -LOGO_BAR_WIDTH/2, -LOGO_DEPTH])
            cube(size = [LOGO_BAR_WIDTH, LOGO_DIA, 2*LOGO_DEPTH]);

            rotate([0, 0, -45])
            translate([-LOGO_BAR_WIDTH/2, -LOGO_BAR_WIDTH/2, -LOGO_DEPTH])
            cube(size = [LOGO_BAR_WIDTH, LOGO_DIA, 2*LOGO_DEPTH]);
        }
        sphere(r = LOGO_DEPTH);
    }
}

module base() {
    hull() {
        rotate_extrude(angle = 360) {
            translate([(BUCKLE_DIA - LOGO_DEPTH)/2, 0, 0]) {
                translate([0, LOGO_DEPTH/2, 0])
                circle(d = LOGO_DEPTH);
                translate([0, BUCKLE_THICKNESS - LOGO_DEPTH/2, 0])
                circle(d = LOGO_DEPTH);
            }
        }
    }
}

module loops() {
    dia = BELT_LOOP_SLOT_WIDTH + 2 * BELT_LOOP_THICKNESS;
    difference() {
            hull() {
            translate([-BUCKLE_DIA/2 -BELT_LOOP_SLOT_WIDTH/2, -BELT_LOOP_SLOT_LENGTH/2, 0])
            cylinder(d = dia, h = BELT_LOOP_THICKNESS);

            translate([-BUCKLE_DIA/2 -BELT_LOOP_SLOT_WIDTH/2, BELT_LOOP_SLOT_LENGTH/2, 0])
            cylinder(d = dia, h = BELT_LOOP_THICKNESS);
        }
        hull() {
            translate([-BUCKLE_DIA/2 -BELT_LOOP_SLOT_WIDTH/2, -BELT_LOOP_SLOT_LENGTH/2, 0])
            cylinder(d = BELT_LOOP_SLOT_WIDTH, h = BELT_LOOP_THICKNESS);

            translate([-BUCKLE_DIA/2 -BELT_LOOP_SLOT_WIDTH/2, BELT_LOOP_SLOT_LENGTH/2, 0])
            cylinder(d = BELT_LOOP_SLOT_WIDTH, h = BELT_LOOP_THICKNESS);
        }
    }

    difference() {
        hull() {
            translate([BUCKLE_DIA/2 +BELT_LOOP_SLOT_WIDTH/2, -BELT_LOOP_SLOT_LENGTH/2, 0])
            cylinder(d = dia, h = BELT_LOOP_THICKNESS);

            translate([BUCKLE_DIA/2 +BELT_LOOP_SLOT_WIDTH/2, BELT_LOOP_SLOT_LENGTH/2, 0])
            cylinder(d = dia, h = BELT_LOOP_THICKNESS);
        }
        hull() {
            translate([BUCKLE_DIA/2 +BELT_LOOP_SLOT_WIDTH/2, -BELT_LOOP_SLOT_LENGTH/2, 0])
            cylinder(d = BELT_LOOP_SLOT_WIDTH, h = BELT_LOOP_THICKNESS);

            translate([BUCKLE_DIA/2 +BELT_LOOP_SLOT_WIDTH/2, BELT_LOOP_SLOT_LENGTH/2, 0])
            cylinder(d = BELT_LOOP_SLOT_WIDTH, h = BELT_LOOP_THICKNESS);
        }
    }
}

module catch() {
    difference() {
        union() {
            sx = CATCH_WIDTH-CATCH_THICKNESS;
            sy = CATCH_LENGTH-CATCH_THICKNESS;
            hull() {
                translate([-sx/2, -sy/2, 0])
                cylinder(d = CATCH_THICKNESS, h = 1);
                translate([sx/2, -sy/2, 0])
                cylinder(d = CATCH_THICKNESS, h = 1);
                translate([-sx/2, -sy/2, -CATCH_LOOP_THICKNESS/2])
                sphere(d = CATCH_THICKNESS);
                translate([sx/2, -sy/2, -CATCH_LOOP_THICKNESS/2])
                sphere(d = CATCH_THICKNESS);
            }

            hull() {
                translate([-sx/2, sy/2, 0])
                cylinder(d = CATCH_THICKNESS, h = 1);
                translate([sx/2, sy/2, 0])
                cylinder(d = CATCH_THICKNESS, h = 1);
                translate([-sx/2, sy/2, -CATCH_LOOP_THICKNESS/2])
                sphere(d = CATCH_THICKNESS);
                translate([sx/2, sy/2, -CATCH_LOOP_THICKNESS/2])
                sphere(d = CATCH_THICKNESS);
            }
        }
        #translate([0, 0, -CATCH_LOOP_THICKNESS/2])
        hull() {
            sx = CATCH_LOOP_WIDTH-CATCH_LOOP_THICKNESS;
            sy = CATCH_LOOP_LENGTH-CATCH_LOOP_THICKNESS;
            translate([-sx/2, -sy/2, 0])
            sphere(d = CATCH_LOOP_THICKNESS);
            translate([sx/2, -sy/2, 0])
            sphere(d = CATCH_LOOP_THICKNESS);
            translate([-sx/2, sy/2, 0])
            sphere(d = CATCH_LOOP_THICKNESS);
            translate([sx/2, sy/2, 0])
            sphere(d = CATCH_LOOP_THICKNESS);
        }
    }
}

module buckle() {
    difference() {
        union() {
            base();
            if(LOOPS) {
              loops();
            }
            if(CATCH) {
              catch();
            }
        }
        translate([0, 0, BUCKLE_THICKNESS + LOGO_DEPTH])
        logo();
    }
}

buckle();
