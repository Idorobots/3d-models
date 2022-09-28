BEARING_INNER_DIA = 30;
BEARING_OUTER_DIA = 42;
BEARING_THICKNESS = 7;

BOT_THICKNESS = BEARING_THICKNESS - 2;
BOT_INNER_DIA = 7.2;
BOT_OUTER_DIA = BEARING_INNER_DIA + 0.4;

LIP_THICKNESS = 1;
LIP_OUTER_DIA = BEARING_INNER_DIA + 4;
LIP_INNER_DIA = 4.4;

CONDUCTOR_THICKNESS = 1.4;
CONDUCTOR_WIDTH = 2.1;
CONDUCTOR_DIAS = [12.4, 18.4, 24.4, 30.4];

TOP_THICKNESS = BEARING_THICKNESS;
TOP_INNER_DIA = BEARING_OUTER_DIA + 0.6;
TOP_OUTER_DIA = BEARING_OUTER_DIA + 2;

MOUNT_THICKNESS = 3;
MOUNT_OUTER_DIA = TOP_OUTER_DIA;
MOUNT_INNER_DIA = LIP_INNER_DIA;

CONNECTOR_WIDTH = 7;
CONNECTOR_LENGTH = 12;
CONNECTOR_OFFSET = min(CONDUCTOR_DIAS)/2 - CONDUCTOR_WIDTH - 0.5;


$fn = 200;

module conductor(dia, width, thickness) {
	union() {
		difference() {
			cylinder(d = dia, h = thickness);
			cylinder(d = dia - 2 * width, h = thickness);
		}
		translate([(dia-width)/2, 0, 0])
		cylinder(d = width, h = dia);
	}
}

module bottom() {
    difference() {
        union() {
            cylinder(d = BOT_OUTER_DIA, h = BOT_THICKNESS);
            translate([0, 0, BOT_THICKNESS - LIP_THICKNESS])
            cylinder(d = LIP_OUTER_DIA, h = LIP_THICKNESS);
        }
        cylinder(d = BOT_INNER_DIA, h = BOT_THICKNESS - LIP_THICKNESS);
        cylinder(d = LIP_INNER_DIA, h = BOT_THICKNESS);

        for(d = CONDUCTOR_DIAS) {
            conductor(d, CONDUCTOR_WIDTH, CONDUCTOR_THICKNESS);
        }

        translate([0, 0, BOT_THICKNESS])
        rotate([0, 90, 0])
        cylinder(d = CONDUCTOR_WIDTH, h = BOT_OUTER_DIA);
    }
}

module top() {
    difference() {
        union() {
            cylinder(d = TOP_OUTER_DIA, h = TOP_THICKNESS);
            cylinder(d = MOUNT_OUTER_DIA, h = MOUNT_THICKNESS);
        }
        translate([0, 0, MOUNT_THICKNESS])
        cylinder(d = TOP_INNER_DIA, h = TOP_THICKNESS - MOUNT_THICKNESS);
        cylinder(d = MOUNT_INNER_DIA, h = TOP_THICKNESS);
        translate([CONNECTOR_OFFSET, -CONNECTOR_WIDTH/2, 0])
        cube(size = [CONNECTOR_LENGTH, CONNECTOR_WIDTH, MOUNT_THICKNESS]);
    }
}

//bottom();
top();
