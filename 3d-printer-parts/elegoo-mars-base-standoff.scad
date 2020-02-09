FEET_BOLT_DIA = 6;
CORNER_DIA = 30;
WIDTH = 200;
HEIGHT = 30;
THICKNESS = 3;

USB = true;
USB_SLOT_WIDTH = 15;
USB_SLOT_HEIGHT = 8;
USB_MOUNTING_HOLES_DIA = 3;
USB_MOUNTING_HOLES_HEAD_DIA = 2 * USB_MOUNTING_HOLES_DIA;
USB_MOUNTING_HOLES_SPACING = 30;

ONOFF = false;

ONOFF_SLOT_WIDTH = 19;
ONOFF_SLOT_HEIGHT = 13;

ONOFF_ROUND = true;
ONOFF_HOLE_DIA = 12;

$fn = 50;

module standoffs() {
    translate([-(WIDTH-CORNER_DIA)/2, 0, 0])
    difference() {
        cylinder(d = CORNER_DIA, h = HEIGHT/2);
        cylinder(d = FEET_BOLT_DIA, h = HEIGHT/2);
    }

    translate([(WIDTH-CORNER_DIA)/2, 0, 0])
    difference() {
        cylinder(d = CORNER_DIA, h = HEIGHT/2);
        cylinder(d = FEET_BOLT_DIA, h = HEIGHT/2);
    }
}

module usb() {
    union() {
        for(i = [-1, 1]) {
            translate([i * USB_MOUNTING_HOLES_SPACING/2, 0, 0])
            union() {
                cylinder(d = USB_MOUNTING_HOLES_DIA, h = THICKNESS/2);
                translate([0, 0, THICKNESS/2])
                cylinder(d = USB_MOUNTING_HOLES_HEAD_DIA, h = THICKNESS/2);
            }
        }
        
        cube(size = [USB_SLOT_WIDTH, USB_SLOT_HEIGHT, THICKNESS*2], center = true);
    }
}

module onoff() {
    cube(size = [ONOFF_SLOT_WIDTH, ONOFF_SLOT_HEIGHT, THICKNESS*2], center = true);
}

module onoff_round() {
    cylinder(d = ONOFF_HOLE_DIA, h = THICKNESS * 2, center = true);
}


union() {
    standoffs();
    difference() {
        translate([-(WIDTH-CORNER_DIA)/2, CORNER_DIA/2 - THICKNESS, 0])
        cube(size = [(WIDTH-CORNER_DIA), THICKNESS, HEIGHT]);
        translate([0, 0, HEIGHT/2])
        rotate([0, 0, 180])
        standoffs();
        
        if (USB) {
            translate([-WIDTH/5, CORNER_DIA/2 - THICKNESS, HEIGHT/2])
            rotate([-90, 0, 0])
            usb();
        }

        if (ONOFF) {
            translate([WIDTH/5, CORNER_DIA/2 - THICKNESS, HEIGHT/2])
            rotate([-90, 0, 0])
            onoff();
        }

        if (ONOFF_ROUND) {
            translate([WIDTH/5, CORNER_DIA/2 - THICKNESS, HEIGHT/2])
            rotate([-90, 0, 0])
            onoff_round();
        }
    }
}