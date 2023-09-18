SPACER_HEIGHT = 5;
SPACER_TAB_HEIGHT = 5;
SPACER_WIDTH = 10;
SPACER_TAB_WIDTH = 2;

SPACER_ANGLE = 60;

SPACER_INNER_DIA = 50;
SPACER_OUTER_DIA = SPACER_INNER_DIA + SPACER_WIDTH * 2;

$fn = 100;


module spacer() {
    intersection() {
        difference() {
            union() {
                cylinder(d = SPACER_OUTER_DIA, h = SPACER_HEIGHT);
                cylinder(d1 = SPACER_INNER_DIA + SPACER_TAB_WIDTH * 2, d2 = SPACER_INNER_DIA + 2, h = SPACER_HEIGHT + SPACER_TAB_HEIGHT);
            }
            #cylinder(d = SPACER_INNER_DIA, h = SPACER_HEIGHT + SPACER_TAB_HEIGHT);

            #cylinder(d1 = SPACER_INNER_DIA + SPACER_TAB_WIDTH * 2, d2 = SPACER_INNER_DIA + 0, h = SPACER_TAB_HEIGHT);
        }

        rotate_extrude(angle = SPACER_ANGLE)
        square([SPACER_OUTER_DIA, SPACER_HEIGHT + SPACER_TAB_HEIGHT]);
    }
}

spacer();
