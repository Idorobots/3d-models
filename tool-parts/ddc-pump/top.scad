HEIGHT = 17;
WIDTH = 62;
LIMIT_WIDTH = 82;

CAVITY_DIA = 40.5;
CAVITY_PORT_DIA = 6;
CAVITY_DEPTH = 8;
CAVITY_ROUNDOVER_DIA = CAVITY_PORT_DIA;
CAVITY_WALL_THICKNESS = 1;

MOUNTING_HOLE_SPACING = 50;
MOUNTING_HOLE_INNER_DIA = 4.5;
MOUNTING_HOLE_OUTER_DIA = 8;
MOUNTING_HOLE_HEAD_DIA = 8;
MOUNTING_HOLE_HEAD_HEIGHT = 5;
MOUNTING_HOLE_STANDOFF_HEIGHT = 8;

HEX_MOUNTS = true;

$fn = 50;

module base() {
    intersection() {
        translate([0, 0, HEIGHT/2])
        cube(size = [WIDTH, WIDTH, HEIGHT], center = true);
        rotate([0, 0, 45])
        cube(size = [LIMIT_WIDTH, LIMIT_WIDTH, HEIGHT*2], center = true);
    }
}

module mounting_holes(width, length, height, dia) {
    for(i = [-1, 1]) {
        for(j = [-1, 1]) {
            translate([i * width/2, j * length/2, 0])
            cylinder(d = dia, h = height);
        }
    }
}

module cavity() {
    union() {
        translate([0, 0, CAVITY_ROUNDOVER_DIA/2])
        cylinder(d = CAVITY_DIA, h = CAVITY_DEPTH - CAVITY_ROUNDOVER_DIA/2);

        translate([0, 0, CAVITY_ROUNDOVER_DIA/2])
        hull() {
            rotate_extrude()
            translate([-(CAVITY_DIA-CAVITY_ROUNDOVER_DIA)/2, 0, 0])
            circle(d = CAVITY_ROUNDOVER_DIA);
        }
        
        translate([0, 0, -CAVITY_DEPTH/2])
        cylinder(d = CAVITY_PORT_DIA, h = CAVITY_DEPTH);

        translate([0, (CAVITY_DIA-CAVITY_PORT_DIA)/2, CAVITY_PORT_DIA/2])
        rotate([0, 90, 0])
        cylinder(d = CAVITY_PORT_DIA, h = CAVITY_DIA);

        translate([0, 0, -CAVITY_WALL_THICKNESS - CAVITY_PORT_DIA/2]) {
            sphere(d = CAVITY_PORT_DIA);
            rotate([0, 90, 0])
            cylinder(d = CAVITY_PORT_DIA, h = WIDTH);
        }
    }
}

difference() {
    union() {
        base();   
        mounting_holes(MOUNTING_HOLE_SPACING, MOUNTING_HOLE_SPACING, HEIGHT + MOUNTING_HOLE_STANDOFF_HEIGHT, MOUNTING_HOLE_OUTER_DIA);
    }

    translate([0, 0, HEIGHT - CAVITY_DEPTH])
    cavity();

    mounting_holes(MOUNTING_HOLE_SPACING, MOUNTING_HOLE_SPACING, HEIGHT + MOUNTING_HOLE_STANDOFF_HEIGHT, MOUNTING_HOLE_INNER_DIA);

    mounting_holes(MOUNTING_HOLE_SPACING, MOUNTING_HOLE_SPACING, MOUNTING_HOLE_HEAD_HEIGHT, MOUNTING_HOLE_HEAD_DIA, $fn = HEX_MOUNTS ? 6 : $fn);
}