THICKNESS = 1;
HEIGHT = 80 ;
BOTTOM_SCREWS = true;

INNER_DIA = 210;
INNER_HEIGHT = HEIGHT - (BOTTOM_SCREWS ? 0 : THICKNESS);
OUTER_DIA = INNER_DIA + 2 * THICKNESS;
CHANNEL_DIA = 10;

N_SCREWS = 8;
SCREW_MOUNT_HEIGHT = 20;
SCREW_DIA = 4;
SCREW_MOUNT_DIA = SCREW_DIA + 4 * THICKNESS;

$fn = 100;

module screw_mount(outer_dia, screw_dia, height) {
    union() {
        translate([0, 0, height - screw_dia/2])
        sphere(d = screw_dia);
        cylinder(d1 = outer_dia, d2 = screw_dia, h = height - screw_dia/2);
    }
}

module screws(outer_dia, screw_dia, height) {
    for(i = [0:N_SCREWS]) {
        hull() {
            rotate([0, 0, i * 360/N_SCREWS])
            translate([-(OUTER_DIA + SCREW_DIA)/2, 0, 0])
            screw_mount(outer_dia, screw_dia, height);

            cylinder(d = 10, h = HEIGHT);
        }
    }
}

module screw_holes(outer_dia, screw_dia, height) {
    for(i = [0:N_SCREWS]) {
        rotate([0, 0, i * 360/N_SCREWS])
        translate([-(OUTER_DIA + SCREW_DIA)/2, 0, 0])
        screw_mount(outer_dia, screw_dia, height);
    }
}


difference() {
    union() {
        cylinder(d = OUTER_DIA, h = HEIGHT);
        intersection() {
            hull() {
                translate([0, 0, HEIGHT/3])
                cylinder(d = OUTER_DIA, h = HEIGHT/3);
                translate([(INNER_DIA-CHANNEL_DIA)/2, 0, HEIGHT/2])
                rotate([-90, 0, 0])
                cylinder(d = CHANNEL_DIA + 2 * THICKNESS, h = OUTER_DIA/4);
            }
            cube(size = [OUTER_DIA/2, OUTER_DIA/4, HEIGHT]);
        }
        screws(SCREW_MOUNT_DIA, SCREW_DIA, SCREW_MOUNT_HEIGHT);

        if(BOTTOM_SCREWS) {
            translate([0, 0, HEIGHT])
            rotate([180, 0, 0])
            screws(SCREW_MOUNT_DIA, SCREW_DIA, SCREW_MOUNT_HEIGHT);
        }
    }
    cylinder(d = INNER_DIA, h = INNER_HEIGHT);
    translate([(INNER_DIA-CHANNEL_DIA)/2, 0, HEIGHT/2])
    rotate([-90, 0, 0])
    cylinder(d = CHANNEL_DIA, h = OUTER_DIA);
    screw_holes(SCREW_DIA, 0, SCREW_MOUNT_HEIGHT - THICKNESS);

    if(BOTTOM_SCREWS) {
        translate([0, 0, HEIGHT])
        rotate([180, 0, 0])
        screw_holes(SCREW_DIA, 0, SCREW_MOUNT_HEIGHT - THICKNESS);
    }
}
