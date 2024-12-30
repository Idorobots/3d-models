BEARING_DIA = 10;
BEARING_THICKNESS = 3;
BEARING_FLANGE_DIA = 12;
BEARING_FLANGE_THICKNESS = 1;
BEARING_HOLE_DIA = 4.5;

TOP_PLATE_THICKNESS = 1.5;
TOP_PLATE_WIDTH = 9;
TOP_PLATE_LENGTH = 18.5;
TOP_PLATE_HOLE_DIA = 2.5;
TOP_PLATE_HOLE_SPACING = 9;

TOP_SEGMENT_LENGTH = 40;
TOP_SEGMENT_WIDTH = BEARING_DIA;
TOP_SEGMENT_THICKNESS = BEARING_THICKNESS + BEARING_FLANGE_THICKNESS + 2 * TOP_PLATE_THICKNESS;
TOP_SOCKET_DIA = 14;

BOT_SEGMENT_LENGTH = 40;
BOT_SEGMENT_WIDTH = BEARING_FLANGE_DIA;
BOT_SEGMENT_THICKNESS = BEARING_THICKNESS + BEARING_FLANGE_THICKNESS + TOP_PLATE_THICKNESS;
BOT_SOCKET_DIA = 20;

$fn = 50;

module bearing() {
    cylinder(d = BEARING_DIA, h = BEARING_THICKNESS + BEARING_FLANGE_THICKNESS);
    cylinder(d = BEARING_FLANGE_DIA, h = BEARING_FLANGE_THICKNESS);
}

module bot_segment() {
    difference() {
        hull() {
            cylinder(d = BOT_SEGMENT_WIDTH, h = BOT_SEGMENT_THICKNESS);
            translate([BOT_SEGMENT_LENGTH - BOT_SEGMENT_WIDTH, 0, 0])
            cylinder(d = BOT_SEGMENT_WIDTH, h = BOT_SEGMENT_THICKNESS);
        }
        cylinder(d = TOP_SOCKET_DIA, h = TOP_PLATE_THICKNESS);
        translate([0, 0, TOP_PLATE_THICKNESS])
        bearing();
        translate([BOT_SEGMENT_LENGTH, 0, 0])
        cylinder(d = BOT_SOCKET_DIA, h = BOT_SEGMENT_THICKNESS);
    }
}

module top_plate() {
    hull() {
        cylinder(d = TOP_PLATE_WIDTH, h = TOP_PLATE_THICKNESS);
        translate([-TOP_PLATE_LENGTH + TOP_PLATE_WIDTH, 0, 0])
        cylinder(d = TOP_PLATE_WIDTH, h = TOP_PLATE_THICKNESS);
    }
    cylinder(d = TOP_PLATE_HOLE_DIA, h = 15, center = true);
    translate([-TOP_PLATE_HOLE_SPACING, 0, 0])
    cylinder(d = TOP_PLATE_HOLE_DIA, h = 15, center = true);
}

module top_segment() {
    difference() {
        hull() {
            cylinder(d = TOP_SEGMENT_WIDTH, h = TOP_SEGMENT_THICKNESS);
            translate([-TOP_SEGMENT_LENGTH + TOP_SEGMENT_WIDTH, 0, 0])
            cylinder(d = TOP_SEGMENT_WIDTH, h = TOP_SEGMENT_THICKNESS);
        }
        #difference(){
            hull() {
                translate([0, -2, TOP_PLATE_THICKNESS])
                cylinder(d = TOP_SOCKET_DIA, h = BOT_SEGMENT_THICKNESS + TOP_PLATE_THICKNESS);
                translate([0, 2, TOP_PLATE_THICKNESS])
                cylinder(d = TOP_SOCKET_DIA, h = BOT_SEGMENT_THICKNESS + TOP_PLATE_THICKNESS);
            }
            cylinder(d = BEARING_HOLE_DIA, h = TOP_SEGMENT_THICKNESS);
        }
        translate([0, 0, TOP_SEGMENT_THICKNESS-TOP_PLATE_THICKNESS])
        top_plate();
    }
}

bot_segment();
translate([0, 0, -TOP_PLATE_THICKNESS])
top_segment();
