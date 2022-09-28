LIP_WIDTH = 2.75;
LIP_TOP_THICKNESS = 0.1;
LIP_BOT_THICKNESS = 0.5;
LIP_LENGTH = 0.75;
LIP_ANGLE = 10;

FAT_WIDTH = 1.6;
FAT_THICKNESS_FROM = 0.9;
FAT_THICKNESS_TO = 1.2;
FAT_LENGTH = 2.2;

THIN_WIDTH = LIP_WIDTH - FAT_WIDTH;
THIN_THICKNESS_FROM = 0.6;
THIN_THICKNESS_TO = 0.8;
THIN_LENGTH = FAT_LENGTH;

CHAMFER_ANGLE = 42;
ANCHOR_THICKNESS = 0.6;
ANCHOR_LENGTH = 2;
ANCHOR_DIA = 1;

$fn = 50;

module part(width, thickness_from, thickness_to, length) {
    // a-----b
    // |      \
    // |       \
    // d--------c
    linear_extrude(height = length)
    polygon(points = [
        [0, 0], // a
        [thickness_from, 0], // b
        [thickness_to, width], // c
        [0, width] // d
    ]);
}

difference() {
    union() {
        part(FAT_WIDTH, FAT_THICKNESS_FROM, FAT_THICKNESS_TO, FAT_LENGTH);
        translate([FAT_THICKNESS_TO - THIN_THICKNESS_FROM, FAT_WIDTH, 0])
        part(THIN_WIDTH, THIN_THICKNESS_FROM, THIN_THICKNESS_TO, THIN_LENGTH);

        translate([FAT_THICKNESS_FROM - LIP_TOP_THICKNESS/2, 0, FAT_LENGTH])
        rotate([-90, 0, -LIP_ANGLE])
        part(LIP_LENGTH, LIP_TOP_THICKNESS, LIP_BOT_THICKNESS, LIP_WIDTH);

        translate([0, 0, -ANCHOR_LENGTH])
        union() {
            part(FAT_WIDTH, ANCHOR_THICKNESS, ANCHOR_THICKNESS, ANCHOR_LENGTH);

            translate([0, FAT_WIDTH/2, ANCHOR_LENGTH/2])
            rotate([0, 90, 0])
            cylinder(d = ANCHOR_DIA, h = ANCHOR_LENGTH);
        }
    }

    translate([-LIP_WIDTH, 0, 0])
    rotate([0, CHAMFER_ANGLE, -LIP_ANGLE])
    cube(size = [FAT_WIDTH, LIP_WIDTH * 3, FAT_LENGTH * 5], center = true);
}
