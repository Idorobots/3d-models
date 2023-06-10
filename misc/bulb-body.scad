WALL_THICKNESS = 1;

BULB_DIA = 48;
BULB_LIP_HEIGHT = 5;

TOP_DIA = BULB_DIA + 2 * WALL_THICKNESS;
BOT_DIA = 22;
BASE_DIA = 22;

BOT_HEIGHT = (BOT_DIA - BASE_DIA)/2;
TOP_HEIGHT = 35;
SEAM_DELTA = 0;

BOT_HOLE_DIA = 3;

WIRE_HOLE_DIA = 7;
WIRE_HOLE_HEIGHT = 10;
WIRE_HOLE_ANGLE = 10;

$fn = 100;

module body() {
    union() {
        hull() {
            translate([0, 0, BOT_HEIGHT])
            rotate_extrude(angle = 360)
            translate([BOT_DIA/2 - BOT_HEIGHT, 0, 0])
            circle(r = BOT_HEIGHT);
        }

        cylinder(d = BASE_DIA, h = BOT_HEIGHT);

        translate([0, 0, BOT_HEIGHT - SEAM_DELTA])
        cylinder(d1 = BOT_DIA, d2 = TOP_DIA, h = TOP_HEIGHT - BULB_LIP_HEIGHT + SEAM_DELTA);
        translate([0, 0, TOP_HEIGHT - BULB_LIP_HEIGHT + BOT_HEIGHT])
        cylinder(d = TOP_DIA, h = BULB_LIP_HEIGHT);
    }
}

module bulb_body() {
    difference() {
        wt2 = 2 * WALL_THICKNESS;
        body();

        s = (TOP_DIA - wt2)/TOP_DIA;
        #translate([0, 0, WALL_THICKNESS])
        scale([s, s, 1.0])
        body();

        #cylinder(d = BOT_HOLE_DIA, h = wt2);

        #translate([0, 0, WIRE_HOLE_HEIGHT])
        rotate([90 + WIRE_HOLE_ANGLE, 0, 0])
        cylinder(d = WIRE_HOLE_DIA, h = TOP_DIA);
    }
}
bulb_body();
