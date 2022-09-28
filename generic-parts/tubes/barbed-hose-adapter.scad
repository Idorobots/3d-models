LENGTH = 40;
BARBS = 4;

TOP_HOLE_DIA = 5;
TOP_BARB_DIA = 7;
TOP_BARB_HEIGHT = 0.5;

BOT_HOLE_DIA = 9;
BOT_BARB_DIA = 12;
BOT_BARB_HEIGHT = 0.7;

ADAPTER_ANGLE = 0;

$fn = 50;

module barbs(barbs, inner_dia, outer_dia, length, barb_height) {
    for(i = [0:barbs-1]) {
        translate([0, 0, i * length/barbs])
        cylinder(d1 = outer_dia, d2 = outer_dia - 2 * barb_height, h = length/barbs);
    }
}

module angled_barbed_hose_adapter_pos(top_inner_dia, top_outer_dia, top_length, top_height, bot_inner_dia, bot_outer_dia, bot_length, bot_height, angle, barbs) {

    d = max([top_outer_dia, bot_outer_dia]);
    union() {
        sphere(d = d);

        rotate([180, 0, 0])
        barbs(barbs, bot_inner_dia, bot_outer_dia, bot_length, bot_height);

        rotate([angle, 0, 0])
        barbs(barbs, top_inner_dia, top_outer_dia, top_length, top_height);
    }
}

module angled_barbed_hose_adapter_neg(top_inner_dia, top_outer_dia, top_length, top_height, bot_inner_dia, bot_outer_dia, bot_length, bot_height, angle, barbs) {

    union() {
        sphere(d = bot_inner_dia);

        translate([0, 0, -bot_length])
        cylinder(d = bot_inner_dia, h = bot_length);

        rotate([angle, 0, 0])
        cylinder(d = top_inner_dia, h = top_length);
    }
}

difference() {
    angled_barbed_hose_adapter_pos(TOP_HOLE_DIA, TOP_BARB_DIA, LENGTH/2, TOP_BARB_HEIGHT, BOT_HOLE_DIA, BOT_BARB_DIA, LENGTH/2, BOT_BARB_HEIGHT, ADAPTER_ANGLE, BARBS);
    angled_barbed_hose_adapter_neg(TOP_HOLE_DIA, TOP_BARB_DIA, LENGTH/2, TOP_BARB_HEIGHT, BOT_HOLE_DIA, BOT_BARB_DIA, LENGTH/2, BOT_BARB_HEIGHT, ADAPTER_ANGLE, BARBS);
}
