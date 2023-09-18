HOLE_DIA = 14.2;

WALL_THICKNESS = 2;
POT_WALL_THICKNESS = 6;
POT_DIA = 140;

WIDTH = 20;
HEIGHT = 25;

$fn = 100;

module hole() {
    cylinder(d = HOLE_DIA, h = HEIGHT * 2, center = true);
}

module pot() {
    translate([0, 0, HEIGHT - POT_WALL_THICKNESS/2])
    rotate_extrude(angle = 360)
    translate([-(POT_DIA-POT_WALL_THICKNESS)/2, 0, 0])
    circle(d = POT_WALL_THICKNESS);

    difference() {
        cylinder(d = POT_DIA, h = HEIGHT - POT_WALL_THICKNESS/2);
        cylinder(d = POT_DIA - 2 * POT_WALL_THICKNESS, h = HEIGHT - POT_WALL_THICKNESS/2);
    }
}

module adapter() {
    difference() {
        hull() {
            cylinder(d = HOLE_DIA + 2 * WALL_THICKNESS, h = HEIGHT);
            translate([-(WIDTH - WALL_THICKNESS), 0, 0])
            cylinder(d1 = POT_WALL_THICKNESS, d2 = WIDTH, h = HEIGHT);
        }

        #translate([-POT_DIA/2 -WIDTH/2 -WALL_THICKNESS, 0, -HEIGHT/4])
        pot();

        #hole();
    }
}

adapter();
