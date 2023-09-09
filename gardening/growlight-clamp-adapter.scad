CLAMP_DIA = 18;
CLAMP_DEFORMATION = 1.35;
CLAMP_ANGLE = 0;

HOLE_DIA = 14.2;
HOLE_ANGLE = 45;

WALL_THICKNESS = 2;

WIDTH = HOLE_DIA + 2 * WALL_THICKNESS;
LENGTH = CLAMP_DIA + HOLE_DIA + 3 * WALL_THICKNESS;
HEIGHT = max(CLAMP_DIA/2 * CLAMP_DEFORMATION + 2 * WALL_THICKNESS, WIDTH);

$fn = 100;

module clamp() {
    w = CLAMP_DIA;
    rotate([0, -CLAMP_ANGLE, 0])
    translate([0, 0, -(w/2 * CLAMP_DEFORMATION)/2])
    intersection() {
        rotate([90, 0, 0])
        scale([1.0, CLAMP_DEFORMATION, 1.0])
        cylinder(d = w, h = WIDTH * 2, center = true);

        cylinder(d = WIDTH * 2, h = CLAMP_DIA);
    }
}

module hole() {
    rotate([HOLE_ANGLE, 0, 0])
    cylinder(d = HOLE_DIA, h = HEIGHT * 2, center = true);
}

module body() {
    difference() {
        hull() {
            w = CLAMP_DIA + 2 * WALL_THICKNESS;
            translate([-(CLAMP_DIA + WALL_THICKNESS)/2, 0, 0])
            rotate([0, -CLAMP_ANGLE, 0])
            translate([0, 0, -(w/2 * CLAMP_DEFORMATION)/2])
            intersection() {
                rotate([90, 0, 0])
                scale([1.0, CLAMP_DEFORMATION + 0.1, 1.0])
                cylinder(d = w, h = WIDTH, center = true);

                cylinder(d = WIDTH * 2, h = HEIGHT);
            }

            translate([(HOLE_DIA + WALL_THICKNESS)/2, 0, 0])
            rotate([HOLE_ANGLE, 0, 0])
            cylinder(d = HOLE_DIA + 2 * WALL_THICKNESS, h = HEIGHT, center = true);
        }

        #translate([-(CLAMP_DIA + WALL_THICKNESS)/2, 0, 0])
        clamp();
        #translate([(HOLE_DIA + WALL_THICKNESS)/2, 0, 0])
        hole();
    }
}

body();
