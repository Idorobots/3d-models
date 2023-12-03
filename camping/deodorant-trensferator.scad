WALL_THICKNESS = 1;

CAP_WIDTH = 22;
CAP_LENGTH = 63;
CAP_HEIGHT = 10;

TOP_LENGTH = 13;
TOP_WIDTH = 9;
TOP_HEIGHT = 4;

PORT_OUTER_DIA = TOP_WIDTH;
PORT_INNER_DIA = TOP_WIDTH - 2 * WALL_THICKNESS;
PORT_LENGTH = 5;

$fn = 50;

module bar(width, length, height) {
    hull() {
        translate([-(length-width)/2, 0, 0])
        cylinder(d = width, h = height);


        translate([(length-width)/2, 0, 0])
        cylinder(d = width, h = height);
    }
}

module cap(w1, w2, l1, l2, h1, h2) {
    hull() {
        bar(w1, l1, h1);
        translate([0, 0, h1])
        bar(w2, l2, h2);
    }
}

module port(dia) {
   cylinder(d = dia, h = CAP_HEIGHT + TOP_HEIGHT + PORT_LENGTH);
}

difference() {
    wt = WALL_THICKNESS;
    wt2 = 2 * wt;
    union() {
        cap(CAP_WIDTH + wt2, TOP_WIDTH + wt2, CAP_LENGTH + wt2, TOP_LENGTH + wt2, CAP_HEIGHT + wt, TOP_HEIGHT);
        port(PORT_OUTER_DIA);
    }

        cap(CAP_WIDTH, TOP_WIDTH, CAP_LENGTH, TOP_LENGTH, CAP_HEIGHT, TOP_HEIGHT);
        port(PORT_INNER_DIA);
}
